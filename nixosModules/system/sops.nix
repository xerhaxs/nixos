{ config, lib, pkgs, sops-nix, ... }:

{
  imports = [
    sops-nix.nixosModules.sops
  ];

  options.nixos = {
    system.sops = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Sops.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.sops.enable {
    #systemd.services.webdav.serviceConfig.EnvironmentFile = [ 
    #  config.sops.secrets.changeme_env.path 
    #];

    environment.systemPackages = with pkgs; [
      sops
    ];

    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "${config.xdg.userDirs.documents}/Wichtige Datein/sops/age/keys.txt";
      #age.keyFile = "/mount/Data/Datein/Dokumente/Wichtige Datein/sops/age/keys.txt";
      #age.keyFile = "/home/jf/Dokumente/Wichtige Datein/sops/age/keys.txt";

      secrets = {
        changeme = { };
        changeme_env = { };

        "etesync/secret" = { };
        "etesync/users/admin/username" = { };
        "etesync/users/admin/password" = { };

        "firefoxsync/secret" = { };

        "homeassistant/longitude" = { };
        "homeassistant/latitude" = { };

        "mailserver/users/admin/email" = { };
        "mailserver/users/admin/password" = { };
        "mailserver/users/jf/email" = { };
        "mailserver/users/jf/password" = { };
        "mailserver/users/xerhaxs/email" = { };
        "mailserver/users/xerhaxs/password" = { };

        "monero/users/username" = { };
        "monero/users/password" = { };
        "monero/users/address" = { };

        "freshrss/users/defaultUser/username" = { };
        "freshrss/users/defaultUser/password" = { };

        "nextcloud/users/admin/username" = { };
        "nextcloud/users/admin/password" = { };

        "nginx/acme/email" = { };
        "nginx/acme/api_key" = { };

        "nzbget/control/username" = { };
        "nzbget/control/password" = { }; 

        "pufferpanel/users/admin/email" = { };
        "pufferpanel/users/admin/password" = { };

        "radicale/htpasswd" = { };

        "searxng/secret" = { };

        "webdav/users/admin/username" = { };
        "webdav/users/admin/password" = { };

        "synology-nas/user" = { };

        "wireguard/home/privateKey" = { };
        "wireguard/home/presharedKey" = { };

        wifi = { };
      };
    };
  };
}