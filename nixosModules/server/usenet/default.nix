{ config, lib, pkgs, ... }:

with lib;

{ 
  options.nixos = {
    server.usenet = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable usenet modules bundle.";
      };
    };
  };

  config = mkIf config.nixos.server.usenet.enable {
    imports = [
      ./lidarr.nix
      ./nzbget.nix
      ./nzbhydra2.nix
      ./radarr.nix
      ./readarr.nix
      ./sonarr.nix
    ];
  };
}
