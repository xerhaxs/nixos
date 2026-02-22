{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.home.radicale = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Radiacle.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.home.radicale.enable {
    systemd.services.radicale.serviceConfig.EnvironmentFile = [
      config.sops.secrets."radicale/htpasswd".path
    ];

    sops.secrets."radicale/htpasswd" = {
      owner = config.systemd.services.radicale.serviceConfig.User;
    };

    services.radicale = {
      enable = true;
      settings = {
        server = {
          hosts = [
            "0.0.0.0:5232"
            "[::]:5232"
          ];
        };

        auth = {
          type = "htpasswd";
          htpasswd_filename = config.sops.secrets."radicale/htpasswd".path;
          htpasswd_encryption = "plain";
        };

        storage = {
          filesystem_folder = "/applications/radicale";
          #filesystem_folder = "/var/lib/radicale/";
        };
      };
    };

    services.nginx = {
      virtualHosts = {
        "radicale.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:5232/";
            extraConfig = ''
              proxy_set_header X-Script-Name /radicale;
              proxy_pass_header Authorization;
            '';
          };
        };
      };
    };
  };
}
