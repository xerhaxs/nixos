{ config, lib, osConfig, pkgs, ... }:

{
  imports = [
    ./browser
    ./communication
    ./development
    ./editing
    ./education
    ./gaming
    ./media
    ./office
    ./screenshot
    ./sync
    ./terminal
    ./vpn

    ./common.nix
  ];

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
    homeManager.applications = {
      browser.enable = true;
      communication.enable = true;
      development.enable = true;
      editing.enable = true;
      education.enable = true;
      gaming.enable = lib.mkIf osConfig.nixos.userEnvironment.game.enable true;
      media.enable = true;
      office.enable = true;
      screenshot.enable = true;
      sync.enable = true;
      terminal.enable = true;
      vpn.enable = true;

      common.enable = true;
    };
  };
}