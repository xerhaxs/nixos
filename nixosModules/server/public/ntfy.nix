{
  config,
  lib,
  pkgs,
  ...
}:

let
  hostname = "push.${config.nixos.server.network.nginx.domain}";
  port = 2586;
in

{
  options.nixos = {
    server.public.ntfy = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable ntfy push server (UnifiedPush).";
      };

      declarativeAuth = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Users, tokens and access rules from sops (ntfy/env with NTFY_AUTH_USERS, NTFY_AUTH_TOKENS, NTFY_AUTH_ACCESS).";
      };
    };
  };

  config = lib.mkIf config.nixos.server.public.ntfy.enable {
    sops.secrets."ntfy/env" = lib.mkIf config.nixos.server.public.ntfy.declarativeAuth {
      restartUnits = [ "ntfy-sh.service" ];
    };

    services.ntfy-sh = {
      enable = true;
      environmentFile =
        lib.mkIf config.nixos.server.public.ntfy.declarativeAuth
          config.sops.secrets."ntfy/env".path;
      settings = {
        base-url = "https://${hostname}";
        listen-http = "127.0.0.1:${toString port}";
        behind-proxy = true;

        auth-file = "/var/lib/ntfy-sh/user.db";
        auth-default-access = "deny-all";
        auth-access = [ "*:up*:write-only" ];
        enable-login = true;
        enable-signup = false;

        cache-duration = "24h";
        attachment-expiry-duration = "24h";
        attachment-total-size-limit = "1G";
        visitor-request-limit-burst = 60;
        visitor-request-limit-replenish = "5s";
      };
    };

    environment.systemPackages = [
      config.services.ntfy-sh.package
    ];

    environment.variables.NTFY_AUTH_FILE = config.services.ntfy-sh.settings.auth-file;

    # On top of the sandboxing of the nixpkgs module (mkDefault, the module values win).
    systemd.services.ntfy-sh.serviceConfig = lib.mapAttrs (_: lib.mkDefault) (
      config.nixos.system.hardening.unitHardening
      // {
        CapabilityBoundingSet = "";
        PrivateDevices = true;
        ProcSubset = "pid";
        ProtectHostname = true;
        ProtectProc = "invisible";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
      }
    );

    services.nginx = {
      virtualHosts = {
        "${hostname}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString port}";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_buffering off;
              proxy_request_buffering off;
              proxy_read_timeout 3m;
              client_max_body_size 20M;
            '';
          };
        };
      };
    };

  };
}
