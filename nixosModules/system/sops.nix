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

        "sabnzbd" = lib.mkIf config.nixos.server.usenet.sabnzbd.enable {
          owner = config.services.sabnzbd.user;
          group = config.services.sabnzbd.group;
          mode = "0400";
        };

        "searxng/secret" = { };

        "truenas-smb/user" = { };

        "user/nixos-convertible/jf" = {
          neededForUsers = true;
        };
        "user/nixos-desktop/jf" = {
          neededForUsers = true;
        };
        "user/nixos-framework/jf" = {
          neededForUsers = true;
        };
        "user/nixos-server1/admin" = {
          neededForUsers = true;
        };
        "user/nixos-server2/admin" = {
          neededForUsers = true;
        };
        "user/nixos-server3/admin" = {
          neededForUsers = true;
        };
        "user/nixos-serverpublic/admin" = {
          neededForUsers = true;
        };
        "user/nixos-vmdesktop/admin" = {
          neededForUsers = true;
        };
        "user/nixos-vmserver/admin" = {
          neededForUsers = true;
        };

        "webdav/users/admin/username" = { };
        "webdav/users/admin/password" = { };

        "wifi" = { };
      };
    };
  };
}