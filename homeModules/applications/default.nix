{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable applications modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.enable {
    imports = [
      ./browser
      ./communication
      ./development
      ./editing
      ./flatpak
      ./gaming
      ./media
      ./office
      ./screenshot
      ./sync
      ./terminal
      ./vpn
    ];
  };
}