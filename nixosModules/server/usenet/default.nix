{ config, lib, pkgs, ... }:

{ 
  imports = [
    ./lidarr.nix
    ./nzbget.nix
    ./nzbhydra2.nix
    ./radarr.nix
    ./readarr.nix
    ./sabnzbd.nix
    ./sonarr.nix
  ];

  options.nixos = {
    server.usenet = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable usenet modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.usenet.enable {
    nixos.server.usenet = {
      lidarr.enable = true;
      nzbget.enable = true;
      nzbhydra2.enable = true;
      radarr.enable = true;
      readarr.enable = true;
      sabnzbd.enable = true;
      sonarr.enable = true;
    };
  };
}
