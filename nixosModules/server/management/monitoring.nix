{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.nixos.server.management.monitoring;
  domain = config.nixos.server.network.nginx.domain;
  dataDir = config.nixos.server.dataDir;
  lanSubnet = config.nixos.system.networking.lan.subnet;
  wgInterface = config.nixos.system.wireguard.interface;

  prometheusPort = 9091;
  grafanaPort = 3010;
  lokiPort = 3100;

  # Loki rules, directory layout <dir>/<tenant>/<file> (tenant "fake" without auth).
  lokiRules = pkgs.writeTextDir "fake/audit.yaml" (
    builtins.toJSON {
      groups = [
        {
          name = "audit";
          rules = [
            {
              alert = "ExecOutsideNixStore";
              expr = ''sum by (host) (count_over_time({transport="audit"} |~ "exe=" !~ "auid=4294967295" !~ "exe=\"(/nix/store/|/run/wrappers/|/run/current-system/)" [5m])) > 0'';
              labels.severity = "critical";
              annotations.summary = "A user session executed a program outside /nix/store on {{ $labels.host }}";
            }
          ];
        }
      ];
    }
  );
  alertmanagerPort = 9093;
  blackboxPort = 9115;

  # The JSON of grafana.com comes from the flake inputs grafana-<name>, the revision is in flake.nix.
  dashboard =
    name:
    pkgs.runCommand "grafana-dashboard-${name}.json" { src = inputs."grafana-${name}"; } ''
      sed -e 's/\''${DS_PROMETHEUS}/prometheus/g' \
          -e 's/\''${DS_SIGNCL-PROMETHEUS}/prometheus/g' \
          -e 's/\''${DS_LOKI}/loki/g' \
          "$src" > "$out"
    '';

  dashboards = pkgs.linkFarm "grafana-dashboards" (
    map
      (name: {
        name = "${name}.json";
        path = dashboard name;
      })
      [
        "alertmanager"
        "blackbox"
        "logs"
        "nginx"
        "node-exporter-full"
        "pihole"
        "postgresql"
        "smartctl"
        "unbound"
        "wireguard"
        "zfs"
      ]
    ++ [
      {
        name = "security-updates.json";
        path = pkgs.writeText "security-updates.json" (
          builtins.toJSON (import ./dashboards/security-updates.nix)
        );
      }
    ]
  );

  nodeTargets = lib.mapAttrsToList (name: address: {
    targets = [ "${address}:9100" ];
    labels.instance = name;
  }) cfg.nodes;

  exporterJob = job: port: hosts: {
    job_name = job;
    static_configs = map (name: {
      targets = [ "${cfg.nodes.${name}}:${toString port}" ];
      labels.instance = name;
    }) (lib.filter (name: cfg.nodes ? ${name}) hosts);
  };

  alertRules = {
    groups = [
      {
        name = "system";
        rules = [
          {
            alert = "InstanceDown";
            expr = ''up{job="node", instance=~"NixOS-Server1|NixOS-ServerGaming|NixOS-ServerPublic"} == 0'';
            "for" = "5m";
            labels.severity = "critical";
            annotations.summary = "{{ $labels.instance }} is not reachable";
          }
          {
            alert = "DiskSpaceLow";
            expr = ''(node_filesystem_avail_bytes{fstype!~"tmpfs|ramfs|overlay|squashfs"} / node_filesystem_size_bytes) < 0.10'';
            "for" = "15m";
            labels.severity = "warning";
            annotations.summary = "{{ $labels.instance }}: less than 10% free on {{ $labels.mountpoint }}";
          }
          {
            alert = "DiskWillFillIn24h";
            expr = ''predict_linear(node_filesystem_avail_bytes{fstype!~"tmpfs|ramfs|overlay|squashfs"}[6h], 24 * 3600) < 0'';
            "for" = "1h";
            labels.severity = "warning";
            annotations.summary = "{{ $labels.instance }}: {{ $labels.mountpoint }} will be full within 24h";
          }
          {
            alert = "MemoryLow";
            expr = "(node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) < 0.05";
            "for" = "10m";
            labels.severity = "warning";
            annotations.summary = "{{ $labels.instance }}: less than 5% memory available";
          }
          {
            alert = "SystemdUnitFailed";
            expr = ''node_systemd_unit_state{state="failed"} == 1'';
            "for" = "5m";
            labels.severity = "warning";
            annotations.summary = "{{ $labels.instance }}: {{ $labels.name }} failed";
          }
          {
            alert = "SmartFailing";
            expr = "smartctl_device_smart_status == 0";
            labels.severity = "critical";
            annotations.summary = "{{ $labels.instance }}: SMART status of {{ $labels.device }} is failing";
          }
          {
            alert = "ZfsPoolUnhealthy";
            expr = ''node_zfs_zpool_state{state!="online"} == 1'';
            labels.severity = "critical";
            annotations.summary = "{{ $labels.instance }}: ZFS pool {{ $labels.zpool }} is {{ $labels.state }}";
          }
          {
            alert = "CertificateExpiresSoon";
            expr = "(probe_ssl_earliest_cert_expiry - time()) / 86400 < 14";
            labels.severity = "warning";
            annotations.summary = "Certificate of {{ $labels.instance }} expires in less than 14 days";
          }
          {
            alert = "EndpointDown";
            expr = ''probe_success{job="blackbox"} == 0'';
            "for" = "10m";
            labels.severity = "warning";
            annotations.summary = "{{ $labels.instance }} is not reachable";
          }
          {
            alert = "NewCriticalVulnerability";
            expr = ''delta(nixos_cve_open{severity="Critical"}[1d]) > 0'';
            labels.severity = "warning";
            annotations.summary = "{{ $labels.instance }}: new critical CVE candidates, see the dashboard Security und Updates";
          }
          {
            alert = "VulnerabilityScanStale";
            expr = "time() - nixos_cve_scan_timestamp_seconds > 14 * 86400";
            "for" = "1h";
            labels.severity = "warning";
            annotations.summary = "{{ $labels.instance }}: the last vulnerability scan is older than 14 days";
          }
          {
            alert = "RebootRequired";
            expr = "nixos_reboot_required == 1";
            "for" = "3d";
            labels.severity = "warning";
            annotations.summary = "{{ $labels.instance }} runs an old kernel or initrd, reboot it";
          }
          {
            alert = "NixpkgsOutdated";
            expr = ''(time() - nixos_flake_input_last_modified_seconds{input="nixpkgs"}) / 86400 > 21'';
            "for" = "1d";
            labels.severity = "warning";
            annotations.summary = "{{ $labels.instance }}: nixpkgs is older than 21 days, update flake.lock";
          }
        ];
      }
    ];
  };
in

{
  options.nixos = {
    server.management.monitoring = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Prometheus, Alertmanager, Loki and Grafana.";
      };

      nodes = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {
          NixOS-Server1 = "127.0.0.1";
          NixOS-Desktop = "10.75.0.80";
          NixOS-Framework = "10.100.0.4";
          NixOS-Convertible = "10.100.0.5";
          NixOS-ServerGaming = "10.100.0.6";
          NixOS-ServerPublic = "10.100.0.1";
        };
        description = "Hosts to scrape (hostname -> address in the LAN or the WireGuard network).";
      };

      probes = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default =
          map (name: "https://${name}") (
            lib.filter (name: name != "_" && lib.hasInfix "." name) (
              lib.attrNames config.services.nginx.virtualHosts
            )
          )
          ++ map (name: "https://${name}.${config.nixos.site.domain}") [
            "cloud"
            "matrix"
            "cryptpad"
            "push"
            "bluemap"
            "countdown"
          ]
          ++ [ "https://mail.${config.nixos.site.mailDomain}" ];
        defaultText = lib.literalExpression "all nginx vhosts of this host and the main public services";
        description = "HTTPS endpoints checked for availability and certificate expiry.";
      };

      pihole = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Export Pi-hole metrics (secret monitoring/pihole-env with PIHOLE_PASSWORD).";
      };

      retention = lib.mkOption {
        type = lib.types.str;
        default = "180d";
        description = "Retention of the metrics.";
      };

      alerts = {
        ntfy = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "Send alerts to ntfy (secret monitoring/ntfy-token, topic in monitoring/ntfy-url).";
        };

        mail = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "Send alerts by mail (uses the account of nixos.system.notify.mail and its password secret).";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = lib.mkMerge [
      (lib.mkIf cfg.alerts.ntfy {
        "monitoring/ntfy-token" = { };
        "monitoring/ntfy-url" = { };
      })
      (lib.mkIf cfg.pihole { "monitoring/pihole-env" = { }; })
    ];

    systemd.services.alertmanager.serviceConfig.LoadCredential =
      lib.optionals cfg.alerts.ntfy [
        "ntfy-url:${config.sops.secrets."monitoring/ntfy-url".path}"
        "ntfy-token:${config.sops.secrets."monitoring/ntfy-token".path}"
      ]
      ++ lib.optional cfg.alerts.mail "mail-password:${config.sops.secrets."notify/mail-password".path}";

    systemd.tmpfiles.rules = lib.mkIf (!lib.hasPrefix "/var/lib" dataDir) [
      "d ${dataDir}/prometheus 0750 prometheus prometheus -"
    ];
    systemd.services.prometheus.serviceConfig.BindPaths = lib.mkIf (!lib.hasPrefix "/var/lib" dataDir) [
      "${dataDir}/prometheus:/var/lib/prometheus2"
    ];

    services.prometheus = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = prometheusPort;
      retentionTime = cfg.retention;
      stateDir = "prometheus2";
      globalConfig = {
        scrape_interval = "30s";
        evaluation_interval = "30s";
      };

      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = nodeTargets;
        }
        (exporterJob "smartctl" 9633 [
          "NixOS-Server1"
          "NixOS-Desktop"
          "NixOS-Framework"
          "NixOS-Convertible"
        ])
        (exporterJob "nginx" 9113 [
          "NixOS-Server1"
          "NixOS-ServerGaming"
          "NixOS-ServerPublic"
        ])
        (exporterJob "postgres" 9187 [
          "NixOS-Server1"
          "NixOS-ServerPublic"
        ])
        (exporterJob "wireguard" 9586 [
          "NixOS-Server1"
          "NixOS-ServerGaming"
          "NixOS-ServerPublic"
        ])
        {
          job_name = "unbound";
          static_configs = [
            { targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.unbound.port}" ]; }
          ];
        }
        {
          job_name = "alertmanager";
          static_configs = [ { targets = [ "127.0.0.1:${toString alertmanagerPort}" ]; } ];
        }
        {
          job_name = "blackbox";
          metrics_path = "/probe";
          params.module = [ "https_2xx" ];
          static_configs = [ { targets = cfg.probes; } ];
          relabel_configs = [
            {
              source_labels = [ "__address__" ];
              target_label = "__param_target";
            }
            {
              source_labels = [ "__param_target" ];
              target_label = "instance";
            }
            {
              target_label = "__address__";
              replacement = "127.0.0.1:${toString blackboxPort}";
            }
          ];
        }
      ]
      ++ lib.optional cfg.pihole {
        job_name = "pihole";
        static_configs = [
          { targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.pihole.port}" ]; }
        ];
      };

      ruleFiles = [ (pkgs.writeText "alert-rules.yml" (builtins.toJSON alertRules)) ];

      alertmanagers = [
        { static_configs = [ { targets = [ "127.0.0.1:${toString alertmanagerPort}" ]; } ]; }
      ];

      exporters = {
        pihole = lib.mkIf (cfg.pihole && config.services.pihole-ftl.enable) {
          enable = true;
          listenAddress = "127.0.0.1";
          piholeHostname = "127.0.0.1";
        };

        unbound = lib.mkIf config.services.unbound.enable {
          enable = true;
          listenAddress = "127.0.0.1";
          unbound.host = "unix:///run/unbound/unbound.ctl";
        };

        blackbox = {
          enable = true;
          listenAddress = "127.0.0.1";
          port = blackboxPort;
          configFile = pkgs.writeText "blackbox.yml" (
            builtins.toJSON {
              modules.https_2xx = {
                prober = "http";
                timeout = "10s";
                http = {
                  valid_status_codes = [
                    200
                    204
                    301
                    302
                    307
                    308
                    401
                    403
                  ];
                  follow_redirects = true;
                  preferred_ip_protocol = "ip4";
                };
              };
            }
          );
        };
      };

      alertmanager = {
        enable = true;
        listenAddress = "127.0.0.1";
        port = alertmanagerPort;
        configuration = {
          route = {
            receiver = "default";
            group_by = [
              "alertname"
              "instance"
            ];
            group_wait = "1m";
            group_interval = "10m";
            repeat_interval = "12h";
          };
          receivers = [
            (
              {
                name = "default";
              }
              // lib.optionalAttrs cfg.alerts.ntfy {
                webhook_configs = [
                  {
                    url_file = "/run/credentials/alertmanager.service/ntfy-url";
                    http_config.authorization.credentials_file = "/run/credentials/alertmanager.service/ntfy-token";
                    send_resolved = true;
                  }
                ];
              }
              // lib.optionalAttrs cfg.alerts.mail {
                email_configs = [
                  {
                    to = config.nixos.system.notify.mail.to;
                    from = config.nixos.system.notify.mail.from;
                    smarthost = "${config.nixos.system.notify.mail.host}:${toString config.nixos.system.notify.mail.port}";
                    auth_username = config.nixos.system.notify.mail.from;
                    auth_password_file = "/run/credentials/alertmanager.service/mail-password";
                    require_tls = true;
                    send_resolved = true;
                  }
                ];
              }
            )
          ];
        };
      };
    };

    systemd.services.prometheus-pihole-exporter.serviceConfig.EnvironmentFile =
      lib.mkIf cfg.pihole
        config.sops.secrets."monitoring/pihole-env".path;

    services.unbound.localControlSocketPath = lib.mkIf config.services.unbound.enable "/run/unbound/unbound.ctl";
    systemd.services.prometheus-unbound-exporter.serviceConfig.SupplementaryGroups =
      lib.mkIf config.services.unbound.enable
        [ "unbound" ];

    services.loki = {
      enable = true;
      dataDir = "${dataDir}/loki";
      configuration = {
        auth_enabled = false;
        server = {
          http_listen_address = "0.0.0.0";
          http_listen_port = lokiPort;
          grpc_listen_address = "127.0.0.1";
          grpc_listen_port = 9095;
        };
        common = {
          path_prefix = "${dataDir}/loki";
          replication_factor = 1;
          ring = {
            instance_addr = "127.0.0.1";
            kvstore.store = "inmemory";
          };
        };
        schema_config.configs = [
          {
            from = "2026-01-01";
            store = "tsdb";
            object_store = "filesystem";
            schema = "v13";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];
        storage_config.filesystem.directory = "${dataDir}/loki/chunks";
        limits_config = {
          retention_period = "720h";
          reject_old_samples = true;
          reject_old_samples_max_age = "168h";
        };
        compactor = {
          working_directory = "${dataDir}/loki/compactor";
          retention_enabled = true;
          delete_request_store = "filesystem";
        };
        analytics.reporting_enabled = false;
        ruler = {
          storage = {
            type = "local";
            local.directory = lokiRules;
          };
          rule_path = "${dataDir}/loki/ruler";
          alertmanager_url = "http://127.0.0.1:${toString alertmanagerPort}";
          ring.kvstore.store = "inmemory";
          enable_api = false;
        };
      };
    };

    networking.firewall = {
      extraCommands = ''
        iptables -A nixos-fw -p tcp -s ${lanSubnet} --dport ${toString lokiPort} -j nixos-fw-accept
      '';
      interfaces.${wgInterface}.allowedTCPPorts = lib.mkIf config.nixos.system.wireguard.enable [
        lokiPort
      ];
    };

    systemd.services.grafana-secret-key = {
      description = "Create the secret key of Grafana";
      before = [ "grafana.service" ];
      requiredBy = [ "grafana.service" ];
      serviceConfig = config.nixos.system.hardening.unitHardening // {
        Type = "oneshot";
        ProtectSystem = "strict";
        ReadWritePaths = [ dataDir ];
      };
      script = ''
        key=${config.services.grafana.dataDir}/secret_key
        if [ ! -s "$key" ]; then
          install -d -o grafana -g grafana -m 0750 ${config.services.grafana.dataDir}
          (umask 077; head -c 48 /dev/urandom | base64 > "$key")
          chown grafana:grafana "$key"
        fi
      '';
    };

    services.grafana = {
      enable = true;
      dataDir = "${dataDir}/grafana";
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = grafanaPort;
          domain = "grafana.${domain}";
          root_url = "https://grafana.${domain}";
          enable_gzip = true;
        };
        security = {
          secret_key = "$__file{${config.services.grafana.dataDir}/secret_key}";
          cookie_secure = true;
          disable_gravatar = true;
        };
        analytics = {
          reporting_enabled = false;
          check_for_updates = false;
          check_for_plugin_updates = false;
        };
        users.allow_sign_up = false;
      };

      provision = {
        enable = true;
        datasources.settings.datasources = [
          {
            name = "Prometheus";
            uid = "prometheus";
            type = "prometheus";
            url = "http://127.0.0.1:${toString prometheusPort}";
            isDefault = true;
          }
          {
            name = "Loki";
            uid = "loki";
            type = "loki";
            url = "http://127.0.0.1:${toString lokiPort}";
          }
          {
            name = "Alertmanager";
            uid = "alertmanager";
            type = "alertmanager";
            url = "http://127.0.0.1:${toString alertmanagerPort}";
            jsonData.implementation = "prometheus";
          }
        ];
        dashboards.settings.providers = [
          {
            name = "nixos";
            folder = "NixOS";
            options.path = dashboards;
            disableDeletion = true;
          }
        ];
      };
    };

    services.nginx = {
      virtualHosts = {
        "grafana.${domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString grafanaPort}";
            proxyWebsockets = true;
          };
        };
      };
    };

    environment.persistence."/persistent" =
      lib.mkIf (config.nixos.disko.disko-luks-btrfs-tmpfs.enable && lib.hasPrefix "/var/lib" dataDir)
        {
          directories = [
            "/var/lib/prometheus2"
            {
              directory = "${dataDir}/grafana";
              user = "grafana";
              group = "grafana";
              mode = "0750";
            }
            {
              directory = "${dataDir}/loki";
              user = "loki";
              group = "loki";
              mode = "0750";
            }
          ];
        };
  };
}
