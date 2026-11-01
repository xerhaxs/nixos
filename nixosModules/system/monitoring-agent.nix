{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.nixos.system.monitoring-agent;
  exporters = config.services.prometheus.exporters;

  isServer1 = config.networking.hostName == "NixOS-Server1";

  ports = [
    exporters.node.port
  ]
  ++ lib.optional exporters.smartctl.enable exporters.smartctl.port
  ++ lib.optional exporters.nginx.enable exporters.nginx.port
  ++ lib.optional exporters.postgres.enable exporters.postgres.port
  ++ lib.optional exporters.wireguard.enable exporters.wireguard.port;

  firewallRules = lib.concatMapStrings (
    source:
    lib.concatMapStrings (port: ''
      iptables -A nixos-fw -p tcp -s ${source} --dport ${toString port} -j nixos-fw-accept
    '') ports
  ) cfg.scrapers;

  textfileDir = "/var/lib/prometheus-node-exporter";

  lock = lib.importJSON ../../flake.lock;

  inputMetrics = pkgs.writeText "flake-inputs.prom" (
    lib.concatStrings (
      lib.mapAttrsToList (
        name: node:
        let
          locked = lock.nodes.${node}.locked or { };
          rev = lib.substring 0 7 (locked.rev or "");
        in
        lib.optionalString (locked ? lastModified) ''
          nixos_flake_input_last_modified_seconds{input="${name}",rev="${rev}"} ${toString locked.lastModified}
        ''
      ) lock.nodes.root.inputs
    )
  );

  versionMetrics = pkgs.writeShellScript "nixos-version-metrics" ''
    reboot=0
    for item in initrd kernel kernel-modules; do
      if [ "$(readlink /run/booted-system/$item)" != "$(readlink /run/current-system/$item)" ]; then
        reboot=1
      fi
    done
    {
      cat ${inputMetrics}
      echo "nixos_reboot_required $reboot"
      echo "nixos_system_info{revision=\"$(/run/current-system/sw/bin/nixos-version --configuration-revision | cut -c1-7)\",kernel=\"$(${pkgs.coreutils}/bin/uname -r)\"} 1"
    } > ${textfileDir}/nixos-version.prom.tmp
    mv ${textfileDir}/nixos-version.prom.tmp ${textfileDir}/nixos-version.prom
  '';
in

{
  options.nixos = {
    system.monitoring-agent = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Export metrics (prometheus exporters) and ship the journal to Loki.";
      };

      scrapers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "10.75.0.21"
          "10.100.0.2"
        ];
        description = "Addresses of the monitoring server (LAN and WireGuard) allowed to scrape the exporters.";
      };

      lokiUrl = lib.mkOption {
        type = lib.types.str;
        default =
          if isServer1 then
            "http://127.0.0.1:3100/loki/api/v1/push"
          else if config.nixos.system.wireguard.enable then
            "http://10.100.0.2:3100/loki/api/v1/push"
          else
            "http://10.75.0.21:3100/loki/api/v1/push";
        description = "Loki push endpoint.";
      };

      smart = lib.mkOption {
        type = lib.types.bool;
        default = config.services.smartd.enable && !config.services.qemuGuest.enable;
        defaultText = lib.literalExpression "smartd enabled and no VM";
        description = "Export SMART values of the disks.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.prometheus.exporters = {
      node = {
        enable = true;
        port = 9100;
        enabledCollectors = [
          "systemd"
          "processes"
          "textfile"
        ];
        extraFlags = [ "--collector.textfile.directory=/var/lib/prometheus-node-exporter" ];
      };

      smartctl = lib.mkIf cfg.smart {
        enable = true;
        port = 9633;
      };

      nginx = lib.mkIf config.services.nginx.enable {
        enable = true;
        port = 9113;
      };

      postgres = lib.mkIf config.services.postgresql.enable {
        enable = true;
        port = 9187;
        runAsLocalSuperUser = true;
      };

      wireguard = lib.mkIf config.nixos.system.wireguard.enable {
        enable = true;
        port = 9586;
      };
    };

    services.nginx.statusPage = lib.mkIf config.services.nginx.enable true;

    systemd.tmpfiles.rules = [
      "d ${textfileDir} 0755 root root -"
    ];

    # Age of the flake inputs, deployed commit and whether a reboot is pending.
    systemd.services.nixos-version-metrics = {
      description = "Export the version of the running system";
      path = [ pkgs.coreutils ];
      serviceConfig = config.nixos.system.hardening.unitHardening // {
        Type = "oneshot";
        ExecStart = versionMetrics;
        ProtectSystem = "strict";
        ReadWritePaths = [ textfileDir ];
      };
    };

    systemd.timers.nixos-version-metrics = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "2min";
        OnUnitActiveSec = "1h";
      };
    };

    networking.firewall.extraCommands = firewallRules;

    services.alloy.enable = true;

    environment.etc."alloy/config.alloy".text = ''
      loki.relabel "journal" {
        forward_to = []
        rule {
          source_labels = ["__journal__systemd_unit"]
          target_label  = "unit"
        }
        rule {
          source_labels = ["__journal_priority_keyword"]
          target_label  = "level"
        }
        rule {
          source_labels = ["__journal__transport"]
          target_label  = "transport"
        }
      }

      loki.source.journal "journal" {
        max_age       = "12h"
        relabel_rules = loki.relabel.journal.rules
        forward_to    = [loki.write.server.receiver]
        labels        = { host = "${config.networking.hostName}" }
      }

      loki.write "server" {
        endpoint {
          url = "${cfg.lokiUrl}"
        }
      }
    '';
  };
}
