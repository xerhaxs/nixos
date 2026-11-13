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

  # Exporter name (path below the metrics vhost) -> port.
  exporterPorts = {
    node = exporters.node.port;
  }
  // lib.optionalAttrs exporters.smartctl.enable { smartctl = exporters.smartctl.port; }
  // lib.optionalAttrs exporters.nginx.enable { nginx = exporters.nginx.port; }
  // lib.optionalAttrs exporters.postgres.enable { postgres = exporters.postgres.port; };

  ports = lib.attrValues exporterPorts;

  # Only hosts in the LAN ship their journal, the VPS keep it (no way from them to NixOS-Server1).
  shipJournal = isServer1 || config.nixos.system.networking.lan.enable;

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
        default = [ "10.75.0.21" ];
        description = "Addresses of the monitoring server in the LAN allowed to scrape the exporters.";
      };

      lokiUrl = lib.mkOption {
        type = lib.types.str;
        default =
          if isServer1 then
            "http://127.0.0.1:3100/loki/api/v1/push"
          else
            "http://10.75.0.21:3100/loki/api/v1/push";
        description = "Loki push endpoint (only hosts in the LAN ship their journal).";
      };

      remote = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "For hosts outside the LAN (VPS): the exporters listen on 127.0.0.1 only, nginx serves them over HTTPS on remote.hostName and only to a client certificate signed by remote.caCertificate (NixOS-Server1 fetches them, nothing connects from here to NixOS-Server1).";
        };

        hostName = lib.mkOption {
          type = lib.types.str;
          default = "metrics-${lib.toLower (lib.removePrefix "NixOS-" config.networking.hostName)}.${config.nixos.site.domain}";
          defaultText = lib.literalExpression ''"metrics-<host without NixOS->.''${config.nixos.site.domain}"'';
          description = "Name of the metrics vhost (certificate by DNS-01, no DNS record needed, Prometheus connects to the IP).";
        };

        caCertificate = lib.mkOption {
          type = lib.types.path;
          default = ./monitoring-ca.pem;
          defaultText = lib.literalExpression "./monitoring-ca.pem";
          description = "CA that signs the client certificate of NixOS-Server1 (public, the key stays offline).";
        };
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
    assertions = [
      {
        assertion = cfg.remote.enable -> builtins.pathExists cfg.remote.caCertificate;
        message = "nixos.system.monitoring-agent.remote: the CA certificate ${toString cfg.remote.caCertificate} is missing, create it and git add it (TODO 30.3).";
      }
    ];

    services.prometheus.exporters = lib.mkMerge [
      {
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
      }
      (lib.genAttrs [ "node" "smartctl" "nginx" "postgres" ] (_: {
        listenAddress = lib.mkIf cfg.remote.enable "127.0.0.1";
      }))
    ];

    services.nginx.virtualHosts.${cfg.remote.hostName} = lib.mkIf cfg.remote.enable {
      forceSSL = true;
      enableACME = true;
      acmeRoot = null;
      http2 = true;
      # Without a certificate of the CA nginx answers 400 and passes nothing on.
      extraConfig = ''
        ssl_client_certificate ${cfg.remote.caCertificate};
        ssl_verify_client on;
        ssl_verify_depth 1;
      '';
      locations = lib.mapAttrs' (
        name: port:
        lib.nameValuePair "= /${name}" { proxyPass = "http://127.0.0.1:${toString port}/metrics"; }
      ) exporterPorts;
    };

    services.nginx.statusPage = lib.mkIf config.services.nginx.enable true;

    systemd.tmpfiles.rules = [
      "d ${textfileDir} 0755 root root -"
    ];

    # Results of vulnscan and ClamAV survive a reboot, Grafana shows the last known state.
    environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [ textfileDir ];
    };

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

    networking.firewall.extraCommands = lib.mkIf (!cfg.remote.enable) firewallRules;

    services.alloy.enable = shipJournal;

    environment.etc."alloy/config.alloy" = lib.mkIf shipJournal {
      text = ''
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
  };
}
