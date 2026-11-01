{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.nixos.system.vulnscan;
  textfileDir = "/var/lib/prometheus-node-exporter";

  # Critical and High per package, the rest only as totals (Prometheus series stay manageable).
  toMetrics = pkgs.writeText "vulnscan-metrics.jq" ''
    def quoted: tojson;
    ($ignore | split(" ")) as $ignored
    | [
        .matches[]
        | select(.vulnerability.id as $id | ($ignored | index($id)) | not)
        | {
            cve: .vulnerability.id,
            severity: .vulnerability.severity,
            package: .artifact.name,
            version: .artifact.version,
            fixed: ((.vulnerability.fix.versions // []) | join(","))
          }
      ]
    | unique
    | (group_by(.severity) | map({ key: .[0].severity, value: length }) | from_entries) as $counts
    | (
        [ "Critical", "High", "Medium", "Low", "Negligible", "Unknown" ][]
        | "nixos_cve_open{severity=\(quoted)} \($counts[.] // 0)"
      ),
      (
        .[]
        | select(.severity == "Critical" or .severity == "High")
        | "nixos_cve_package{cve=\(.cve | quoted),severity=\(.severity | quoted),package=\(.package | quoted),version=\(.version | quoted),fixed_in=\(.fixed | quoted)} 1"
      )
  '';

  scan = pkgs.writeShellApplication {
    name = "vulnscan";
    runtimeInputs = [
      config.nix.package
      pkgs.coreutils
      pkgs.grype
      pkgs.jq
      pkgs.sbomnix
    ];
    text = ''
      work="$(mktemp -d)"
      trap 'rm -rf "$work"' EXIT
      cd "$work"

      sbomnix /run/current-system --cdx sbom.cdx.json --spdx sbom.spdx.json --csv sbom.csv
      grype sbom:sbom.cdx.json -o json --file grype.json -q

      {
        jq -r --arg ignore ${lib.escapeShellArg (lib.concatStringsSep " " cfg.ignore)} -f ${toMetrics} grype.json
        echo "nixos_cve_sbom_components $(jq '.components | length' sbom.cdx.json)"
        echo "nixos_cve_scan_timestamp_seconds $(date +%s)"
      } > metrics.prom
      install -m 0644 metrics.prom ${textfileDir}/vulnscan.prom
    '';
  };
in

{
  options.nixos = {
    system.vulnscan = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Scan the closure of the running system for known vulnerabilities (sbomnix + grype, the database is downloaded, nothing about the host leaves it) and export the result to Prometheus.";
      };

      interval = lib.mkOption {
        type = lib.types.str;
        default = if config.nixos.desktop.enable then "weekly" else "daily";
        defaultText = lib.literalExpression ''"weekly" on desktops, "daily" on servers'';
        description = "systemd OnCalendar expression of the scan.";
      };

      ignore = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "CVE-2026-24061" ];
        description = "Checked false positives. Findings are matched by name and version, patches of nixpkgs are not known to the scanner.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ scan ];

    systemd.tmpfiles.rules = [
      "d ${textfileDir} 0755 root root -"
    ];

    systemd.services.vulnscan = {
      description = "Scan the running system for known vulnerabilities";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      unitConfig.ConditionACPower = true;
      environment = {
        GRYPE_DB_CACHE_DIR = "/var/cache/grype";
        GRYPE_CHECK_FOR_APP_UPDATE = "false";
        NIX_REMOTE = "daemon";
      };
      serviceConfig = config.nixos.system.hardening.unitHardening // {
        Type = "oneshot";
        ExecStart = lib.getExe scan;
        Nice = 19;
        IOSchedulingClass = "idle";
        TimeoutStartSec = "2h";
        CacheDirectory = "grype";
        ProtectSystem = "strict";
        ReadWritePaths = [ textfileDir ];
      };
    };

    systemd.timers.vulnscan = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.interval;
        RandomizedDelaySec = "2h";
        Persistent = true;
      };
    };
  };
}
