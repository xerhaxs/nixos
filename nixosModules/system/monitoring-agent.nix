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
      "d /var/lib/prometheus-node-exporter 0755 root root -"
    ];

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
