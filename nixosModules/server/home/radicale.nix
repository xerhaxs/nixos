{ config, lib, pkgs, ... }:

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
          hosts = [ "0.0.0.0:5232" "[::]:5232" ];
        };

        auth = {
          type = "htpasswd";
          htpasswd_filename = config.sops.secrets."radicale/htpasswd".path;
          htpasswd_encryption = "plain";
        };

        storage = {
          filesystem_folder = "/var/lib/radicale/";
        };
      };
    };
  };
}
