{ config, lib, pkgs, ... }:

{ 
  options.nixos = {
    server.usenet = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable usenet modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.usenet.enable {
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
