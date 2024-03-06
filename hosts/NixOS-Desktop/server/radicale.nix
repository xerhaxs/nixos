{ config, pkgs, ... }:

{
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
        filesystem_folder = "/mount/Data/Datein/Server/radicale";
      };
    };
  };
}
