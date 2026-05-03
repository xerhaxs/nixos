{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.sync.radicale = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Radicale.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.sync.radicale.enable {
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
          filesystem_folder = "/pool01/applications/radicale";
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
          http2 = true;
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

    /* environment.persistence."/persistent" = lib.mkIf config.nixos.disko-luks-btrfs-tmpfs.enable {
      directories = [
        "/var/lib/radicale"
      ];
    }; */
  };
}
