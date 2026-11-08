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

  # Matrix ids are @name:matrix.<domain>, the apex of the domain is not used.
  bridgePermissions = {
    "${matrixDomain}" = "user";
    "@${userName}:${matrixDomain}" = "admin";
  };

  enabledBridges = lib.filter (b: cfg.bridges.${b}.enable) [
    "discord"
    "signal"
    "telegram"
    "whatsapp"
  ];

  # On top of the sandboxing of the nixpkgs modules (mkDefault, the module values win). The bridges
  # parse a lot of foreign data, they only need network sockets and their state directory.
  bridgeHardening = lib.mapAttrs (_: lib.mkDefault) (
    config.nixos.system.hardening.unitHardening
    // {
      AmbientCapabilities = "";
      CapabilityBoundingSet = "";
      PrivateDevices = true;
      ProcSubset = "pid";
      ProtectHostname = true;
      ProtectProc = "invisible";
      RemoveIPC = true;
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
        "AF_NETLINK"
        "AF_UNIX"
      ];
      SystemCallFilter = [
        "@system-service"
        "~@privileged"
      ];
      UMask = "0077";
    }
  );

  # History of new portal rooms, older messages can only go into empty rooms.
  backfillMessages = 10000;

  # Megabridges (Signal, WhatsApp), backfill only happens at login.
  megabridgeBackfill = {
    enabled = true;
    max_initial_messages = backfillMessages;
    max_catchup_messages = backfillMessages;
    threads.max_initial_messages = backfillMessages;
  };

  # Accepts all pending invites of one user, the bridges invite to every new portal.
  acceptInvites = pkgs.writeShellScriptBin "matrix-accept-invites" ''
    set -eu
    api=http://127.0.0.1:8008/_matrix/client/v3
    user=''${1:?usage: matrix-accept-invites <user>}
    read -rsp "Matrix password of $user: " pw
    echo
    login=$(${pkgs.jq}/bin/jq -n --arg u "$user" --arg p "$pw" \
      '{type: "m.login.password", identifier: {type: "m.id.user", user: $u}, password: $p}')
    unset pw
    at=$(printf %s "$login" | ${pkgs.curl}/bin/curl -fsS -X POST -d @- "$api/login" | ${pkgs.jq}/bin/jq -r .access_token)
    unset login
    trap '${pkgs.curl}/bin/curl -fsS -X POST -H "Authorization: Bearer $at" "$api/logout" > /dev/null' EXIT
    filter='{"room":{"timeline":{"limit":0},"state":{"types":[]},"ephemeral":{"types":[]},"account_data":{"types":[]}},"presence":{"types":[]},"account_data":{"types":[]}}'
    invites=$(${pkgs.curl}/bin/curl -fsS -G -H "Authorization: Bearer $at" \
      --data-urlencode "filter=$filter" --data-urlencode "timeout=0" "$api/sync" \
      | ${pkgs.jq}/bin/jq -r '.rooms.invite // {} | keys[] | @uri')
    count=0
    for room in $invites; do
      ${pkgs.curl}/bin/curl -fsS -X POST -H "Authorization: Bearer $at" -d '{}' "$api/rooms/$room/join" > /dev/null
      count=$((count + 1))
    done
    echo "$count invites accepted"
  '';
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

        doublePuppet = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "Let the bridges act as the local Matrix users (secret matrix/doublepuppet_token): they join new portals themselves and messages sent on the phone appear from the own account.";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.mkIf cfg.bridges.doublePuppet {
        # Appservice without URL, it only owns a token that may act as every local user.
        sops.secrets."matrix/doublepuppet_token".restartUnits = [ "matrix-synapse.service" ];

        sops.templates."matrix-doublepuppet.yaml" = {
          owner = "matrix-synapse";
          content = builtins.toJSON {
            id = "doublepuppet";
            url = null;
            as_token = config.sops.placeholder."matrix/doublepuppet_token";
            # Never used, synapse sends nothing to an appservice without URL.
            hs_token = "doublepuppet-unused";
            sender_localpart = "_doublepuppet";
            rate_limited = false;
            namespaces.users = [
              {
                regex = "@.*:${lib.escapeRegex matrixDomain}";
                exclusive = false;
              }
            ];
          };
        };

        # Read by systemd as root before the bridge starts, envsubst puts it into the bridge config.
        sops.templates."mautrix-doublepuppet.env".content = ''
          MAUTRIX_DOUBLEPUPPET_TOKEN=${config.sops.placeholder."matrix/doublepuppet_token"}
        '';

        services.matrix-synapse.settings.app_service_config_files = [
          config.sops.templates."matrix-doublepuppet.yaml".path
        ];
      })

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
            server_name = matrixDomain;
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

            # Only with a token from the admin API (_synapse/admin/v1/registration_tokens/new).
            enable_registration = true;
            registration_requires_token = true;
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

        environment.systemPackages = [ acceptInvites ];

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
              # Federation on 443 instead of 8448.
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
              domain = matrixDomain;
            };
            appservice = {
              hostname = "127.0.0.1";
              port = 29334;
              address = "http://127.0.0.1:29334";
            };
            bridge = {
              permissions = bridgePermissions;
              backfill.forward_limits =
                let
                  limits = {
                    dm = backfillMessages;
                    channel = backfillMessages;
                    thread = backfillMessages;
                  };
                in
                {
                  initial = limits;
                  missed = limits;
                };
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
            # The module defaults to localhost:8448, synapse listens on 8008.
            homeserver.address = "http://127.0.0.1:8008";
            appservice = {
              hostname = "127.0.0.1";
              address = "http://127.0.0.1:29328";
            };
            bridge.permissions = bridgePermissions;
            backfill = megabridgeBackfill;
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
              domain = matrixDomain;
            };
            appservice = {
              hostname = "127.0.0.1";
              port = 29317;
              address = "http://127.0.0.1:29317";
            };
            bridge = {
              # "user" is only the relay bot here, logging in with an own account needs "full".
              permissions = bridgePermissions // {
                "${matrixDomain}" = "full";
              };
              # Create portals for all chats at login, direct chats included.
              sync_create_limit = 0;
              sync_direct_chats = true;
              backfill = {
                enable = true;
                forward_limits =
                  let
                    limits = {
                      user = backfillMessages;
                      normal_group = backfillMessages;
                      supergroup = backfillMessages;
                      channel = backfillMessages;
                    };
                  in
                  {
                    initial = limits;
                    sync = limits;
                  };
                forward_timeout = 3600;
              };
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
            # The module defaults to localhost:8448, synapse listens on 8008.
            homeserver.address = "http://127.0.0.1:8008";
            appservice = {
              hostname = "127.0.0.1";
              address = "http://127.0.0.1:29318";
            };
            bridge.permissions = bridgePermissions;
            backfill = megabridgeBackfill;
            # Asks the phone for a year of history instead of three months, only at login.
            network.history_sync.request_full_sync = true;
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

      (lib.mkIf cfg.bridges.doublePuppet (
        let
          secret = "as_token:$MAUTRIX_DOUBLEPUPPET_TOKEN";
          bridges = enabledBridges;
          envFile = config.sops.templates."mautrix-doublepuppet.env".path;
        in
        {
          sops.templates."mautrix-doublepuppet.env".restartUnits = map (b: "mautrix-${b}.service") bridges;

          services.mautrix-discord.settings.bridge.login_shared_secret_map.${matrixDomain} = secret;
          services.mautrix-signal.settings.double_puppet.secrets.${matrixDomain} = secret;
          services.mautrix-telegram.settings.bridge.login_shared_secret_map.${matrixDomain} = secret;
          services.mautrix-whatsapp.settings.double_puppet.secrets.${matrixDomain} = secret;

          systemd.services = lib.genAttrs (map (b: "mautrix-${b}") bridges) (service: {
            serviceConfig.EnvironmentFile = lib.mkForce (
              lib.filter (f: f != null) [
                config.services.${service}.environmentFile
                envFile
              ]
            );
          });
        }
      ))

      {
        systemd.services = lib.genAttrs (map (b: "mautrix-${b}") enabledBridges) (_: {
          serviceConfig = bridgeHardening;
        });
      }
    ]
  );
}
