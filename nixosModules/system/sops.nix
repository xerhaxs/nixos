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
      age.keyFile = "/root/.secrets/keys.txt";

      secrets = {
        changeme = { };
        changeme_env = { };

        "cloudflare/api_key" = { };

        "glance" = { };

        "lemmy/users/admin/password" = { };

        "monero/users/username" = { };
        "monero/users/password" = { };
        "monero/users/address" = { };

        "nginx/acme/email" = { };
        "nginx/acme/api_key" = { };

        "radicale/htpasswd" = { };

        "sabnzbd" = {
          owner = config.services.sabnzbd.user;
          group = config.services.sabnzbd.group;
          mode = "0400";
        };

        "searxng/secret" = { };

        "webdav/users/admin/username" = { };
        "webdav/users/admin/password" = { };

        "truenas-smb/user" = { };

        "wifi" = { };
      };
    };
  };
}