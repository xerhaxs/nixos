{
  config,
  lib,
  pkgs,
  userName,
  ...
}:

let
  cfg = config.nixos.server.public.matrix;
  domain = config.nixos.server.network.nginx.domain;
  matrixDomain = "matrix.${domain}";

  bridgePermissions = {
    "${domain}" = "user";
    "@${userName}:${domain}" = "admin";
  };

  wellKnownServer = builtins.toJSON { "m.server" = "${matrixDomain}:443"; };
  wellKnownClient = builtins.toJSON {
    "m.homeserver".base_url = "https://${matrixDomain}";
  };
in

{
  options.nixos = {
    server.public.matrix = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable matrix server.";
      };

      bridges = {
        discord.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable the Discord bridge (mautrix-discord).";
        };
        signal.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable the Signal bridge (mautrix-signal).";
        };
        telegram.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable the Telegram bridge (mautrix-telegram), needs api_id/api_hash from my.telegram.org.";
        };
        whatsapp.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable the WhatsApp bridge (mautrix-whatsapp).";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        sops.secrets = {
          "matrix/registration_shared_secret" = {
            owner = "matrix-synapse";
          };
          "matrix/macaroon_secret_key" = { };
          "matrix/form_secret" = { };
        };

        sops.templates."synapse-secrets.yaml" = {
          owner = "matrix-synapse";
          content = ''
            registration_shared_secret: "${config.sops.placeholder."matrix/registration_shared_secret"}"
            macaroon_secret_key: "${config.sops.placeholder."matrix/macaroon_secret_key"}"
            form_secret: "${config.sops.placeholder."matrix/form_secret"}"
          ''
          + lib.optionalString config.nixos.server.public.coturn.enable ''
            turn_shared_secret: "${config.sops.placeholder."coturn/secret"}"
          '';
        };

        services.matrix-synapse = {
          enable = true;
          dataDir = "${config.nixos.server.dataDir}/matrix-synapse";
          extraConfigFiles = [ config.sops.templates."synapse-secrets.yaml".path ];

          settings = {
            server_name = domain;
            public_baseurl = "https://${matrixDomain}";

            listeners = [
              {
                port = 8008;
                bind_addresses = [
                  "127.0.0.1"
                  "::1"
                ];
                type = "http";
                tls = false;
                x_forwarded = true;
                resources = [
                  {
                    names = [
                      "client"
                      "federation"
                    ];
                    compress = true;
                  }
                ];
              }
            ];

            database = {
              name = "psycopg2";
              args = {
                database = "matrix-synapse";
                user = "matrix-synapse";
              };
            };

            enable_registration = false;
            allow_guest_access = false;
            url_preview_enabled = false;
            report_stats = false;
            max_upload_size = "100M";
            suppress_key_server_warning = true;

            media_retention.remote_media_lifetime = "90d";

            turn_uris = lib.mkIf config.nixos.server.public.coturn.enable [
              "turns:turn.${domain}:5349?transport=tcp"
              "turn:turn.${domain}:3478?transport=udp"
              "turn:turn.${domain}:3478?transport=tcp"
            ];
            turn_user_lifetime = "1h";
          };
        };

        services.postgresql = {
          enable = true;
          ensureUsers = [ { name = "matrix-synapse"; } ];
        };

        systemd.services.matrix-synapse-db = {
          description = "Create the synapse database with C collation";
          after = [
            "postgresql.service"
            "postgresql-setup.service"
          ];
          requires = [ "postgresql.service" ];
          before = [ "matrix-synapse.service" ];
          requiredBy = [ "matrix-synapse.service" ];
          path = [ config.services.postgresql.package ];
          serviceConfig = config.nixos.system.hardening.unitHardening // {
            Type = "oneshot";
            RemainAfterExit = true;
            User = "postgres";
          };
          script = ''
            if ! psql -tAc "SELECT 1 FROM pg_database WHERE datname = 'matrix-synapse'" | grep -q 1; then
              psql -c 'CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse" TEMPLATE template0 LC_COLLATE = "C" LC_CTYPE = "C";'
            fi
          '';
        };

        services.nginx = {
          virtualHosts = {
            "${matrixDomain}" = {
              forceSSL = true;
              enableACME = true;
              acmeRoot = null;
              kTLS = true;
              http2 = true;
              locations."/".return = "404";
              locations."/_matrix" = {
                proxyPass = "http://127.0.0.1:8008";
                extraConfig = ''
                  client_max_body_size 100M;
                '';
              };
              locations."/_synapse/client".proxyPass = "http://127.0.0.1:8008";
            };

            "${domain}" = {
              forceSSL = true;
              enableACME = true;
              acmeRoot = null;
              kTLS = true;
              http2 = true;
              locations."= /.well-known/matrix/server".extraConfig = ''
                default_type application/json;
                return 200 '${wellKnownServer}';
              '';
              locations."= /.well-known/matrix/client".extraConfig = ''
                default_type application/json;
                add_header Access-Control-Allow-Origin "*";
                ${config.nixos.server.network.nginx.securityHeaders}
                return 200 '${wellKnownClient}';
              '';
            };
          };
        };

        environment.persistence."/persistent" =
          lib.mkIf
            (
              config.nixos.disko.disko-luks-btrfs-tmpfs.enable
              && lib.hasPrefix "/var/lib/" config.services.matrix-synapse.dataDir
            )
            {
              directories = [
                {
                  directory = config.services.matrix-synapse.dataDir;
                  user = "matrix-synapse";
                  group = "matrix-synapse";
                  mode = "0700";
                }
              ];
            };
      }

      (lib.mkIf cfg.bridges.discord.enable {
        services.mautrix-discord = {
          enable = true;
          package = pkgs.mautrix-discord.overrideAttrs (old: {
            buildInputs = [ ];
            preBuild = (old.preBuild or "") + ''
              export GOFLAGS="$GOFLAGS -tags=nocrypto"
            '';
          });
          settings = {
            homeserver = {
              address = "http://127.0.0.1:8008";
              domain = domain;
            };
            appservice = {
              hostname = "127.0.0.1";
              port = 29334;
              address = "http://127.0.0.1:29334";
            };
            bridge = {
              permissions = bridgePermissions;
              encryption = {
                allow = false;
                default = false;
              };
            };
          };
        };

        environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
          directories = [ "/var/lib/mautrix-discord" ];
        };
      })

      (lib.mkIf cfg.bridges.signal.enable {
        # MAUTRIX_SIGNAL_PICKLE_KEY=..., MAUTRIX_SIGNAL_PROVISIONING_SECRET=...
        sops.secrets."mautrix-signal/env".restartUnits = [ "mautrix-signal.service" ];

        services.mautrix-signal = {
          enable = true;
          package = pkgs.mautrix-signal.override { withGoolm = true; };
          environmentFile = config.sops.secrets."mautrix-signal/env".path;
          settings = {
            appservice = {
              hostname = "127.0.0.1";
              address = "http://127.0.0.1:29328";
            };
            bridge.permissions = bridgePermissions;
            encryption = {
              allow = true;
              default = true;
              pickle_key = "$MAUTRIX_SIGNAL_PICKLE_KEY";
            };
            provisioning.shared_secret = "$MAUTRIX_SIGNAL_PROVISIONING_SECRET";
          };
        };

        environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
          directories = [ "/var/lib/mautrix-signal" ];
        };
      })

      (lib.mkIf cfg.bridges.telegram.enable {
        # MAUTRIX_TELEGRAM_TELEGRAM_API_ID=..., MAUTRIX_TELEGRAM_TELEGRAM_API_HASH=... (https://my.telegram.org/apps)
        sops.secrets."mautrix-telegram/env".restartUnits = [ "mautrix-telegram.service" ];

        services.mautrix-telegram = {
          enable = true;
          package = pkgs.mautrix-telegram.override { withE2BE = false; };
          environmentFile = config.sops.secrets."mautrix-telegram/env".path;
          settings = {
            homeserver = {
              address = "http://127.0.0.1:8008";
              domain = domain;
            };
            appservice = {
              hostname = "127.0.0.1";
              port = 29317;
              address = "http://127.0.0.1:29317";
            };
            bridge = {
              permissions = bridgePermissions;
              encryption = {
                allow = false;
                default = false;
              };
            };
          };
        };

        environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
          directories = [ "/var/lib/mautrix-telegram" ];
        };
      })

      (lib.mkIf cfg.bridges.whatsapp.enable {
        # MAUTRIX_WHATSAPP_PICKLE_KEY=..., MAUTRIX_WHATSAPP_PROVISIONING_SECRET=...
        sops.secrets."mautrix-whatsapp/env".restartUnits = [ "mautrix-whatsapp.service" ];

        services.mautrix-whatsapp = {
          enable = true;
          package = pkgs.mautrix-whatsapp.override { withGoolm = true; };
          environmentFile = config.sops.secrets."mautrix-whatsapp/env".path;
          settings = {
            appservice = {
              hostname = "127.0.0.1";
              address = "http://127.0.0.1:29318";
            };
            bridge.permissions = bridgePermissions;
            encryption = {
              allow = true;
              default = true;
              pickle_key = "$MAUTRIX_WHATSAPP_PICKLE_KEY";
            };
            provisioning.shared_secret = "$MAUTRIX_WHATSAPP_PROVISIONING_SECRET";
          };
        };

        environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
          directories = [ "/var/lib/mautrix-whatsapp" ];
        };
      })
    ]
  );
}
