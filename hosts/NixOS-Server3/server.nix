{ config, lib, pkgs, ... }:

{
  services.xserver.displayManager.startx.enable = true;

  nixos.server.network.nginx.enable = true;

  nixos.server.usenet.enable = true;

  networking.firewall.enable = lib.mkForce false; # only for testing purpos

  services.mullvad-vpn.enable = true;

  users.groups = {
    nzbget = { # uid = 245
      gid = 100;
    }; 
    sonarr = { # uid = 274;
      gid = 100;
    };
    radarr = { # uid = 275;
      gid = 100;
    };
    lidarr = { # uid = 306;
      gid = 100;
    };
  };

  environment.systemPackages = [
    pkgs.mullvad
  ];
}