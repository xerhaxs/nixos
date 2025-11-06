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
      age.keyFile = "/root/keys.txt";

      secrets = {
        changeme = { };
        changeme_env = { };

        "cloudflare/api_key" = { };

        "freshrss/users/defaultUser/username" = { };
        "freshrss/users/defaultUser/password" = { };

        "lemmy/users/admin/password" = { };

        "monero/users/username" = { };
        "monero/users/password" = { };
        "monero/users/address" = { };

        "nginx/acme/email" = { };
        "nginx/acme/api_key" = { };

        "pihole/password" = { };

        "radicale/htpasswd" = { };

        "searxng/secret" = { };

        "webdav/users/admin/username" = { };
        "webdav/users/admin/password" = { };

        "truenas-smb/user" = { };

        "wifi" = { };
      };
    };
  };
}