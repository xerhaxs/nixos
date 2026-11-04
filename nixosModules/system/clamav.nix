{
  config,
  lib,
  pkgs,
  ...
}:

let
  textfileDir = "/var/lib/prometheus-node-exporter";

  # Same scan as the nixpkgs unit, the summary and the findings go to the node exporter.
  scan = pkgs.writeShellApplication {
    name = "clamdscan-metrics";
    runtimeInputs = [
      config.services.clamav.package
      pkgs.coreutils
      pkgs.gnugrep
      pkgs.gnused
      pkgs.jq
    ];
    text = ''
      out="$(mktemp)"
      trap 'rm -f "$out"' EXIT
      start=$(date +%s)

      set +e
      clamdscan --multiscan --fdpass --infected --allmatch ${lib.escapeShellArgs config.services.clamav.scanner.scanDirectories} | tee "$out"
      rc=''${PIPESTATUS[0]}
      set -e

      infected=$(sed -n 's/^Infected files: //p' "$out" | tail -n 1)
      errors=$(sed -n 's/^Total errors: //p' "$out" | tail -n 1)
      {
        echo "clamav_scan_infected_files ''${infected:-0}"
        echo "clamav_scan_errors ''${errors:-0}"
        echo "clamav_scan_exit_code $rc"
        echo "clamav_scan_duration_seconds $(( $(date +%s) - start ))"
        echo "clamav_scan_timestamp_seconds $(date +%s)"
        { grep -m 100 ' FOUND$' "$out" || true; } \
          | jq -R -r 'capture("^(?<path>.*): (?<signature>[^ ]+) FOUND$")
              | "clamav_infected_file{path=\(.path | tojson),signature=\(.signature | tojson)} 1"'
      } > ${textfileDir}/clamav.prom.tmp
      mv ${textfileDir}/clamav.prom.tmp ${textfileDir}/clamav.prom

      # 1 means "found something", that is reported through the metrics and not as a failed unit.
      exit "$rc"
    '';
  };
in

{
  options.nixos = {
    system.clamav = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable ClamAV virus scanner.";
      };

      extraScanDirectories = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "/mount/Data" ];
        description = "Additional directories of the daily scan (user data, shares, uploads).";
      };

      excludePaths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "^/pool01/shares/video" ];
        description = "Regular expressions of paths that are not scanned (ExcludePath).";
      };
    };
  };

  config = lib.mkIf config.nixos.system.clamav.enable {
    services.clamav = {
      daemon = {
        enable = true;
        settings = {
          ExcludePath = [
            "^/proc/"
            "^/sys/"
            "/\\.zfs/"
            "/\\.snapshots/"
          ]
          ++ config.nixos.system.clamav.excludePaths;
        };
      };

      updater = {
        enable = true;
        interval = "hourly";
        frequency = 12;
      };

      scanner = {
        enable = true;
        interval = "*-*-* 04:00:00";
        scanDirectories = [
          "/home"
          "/var/lib"
          "/tmp"
          "/etc"
          "/var/tmp"
        ]
        ++ config.nixos.system.clamav.extraScanDirectories;
      };
    };

    systemd.services.clamdscan.serviceConfig = {
      ExecStart = lib.mkForce (lib.getExe scan);
      SuccessExitStatus = 1;
    };

    # Clients are often off at 04:00, the missed scan runs after the next boot.
    systemd.timers.clamdscan.timerConfig.Persistent = true;

    environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        "/var/lib/clamav"
      ];
    };
  };
}
