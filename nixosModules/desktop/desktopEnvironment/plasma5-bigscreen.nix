{ config, lib, pkgs, ... }:

{
  options.nixos = {
    desktop.desktopEnvironment.plasma5-bigscreen = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Plasma5 Bigscreen desktop environment.";
      };
    };
  };

  config = lib.mkIf config.nixos.desktop.desktopEnvironment.plasma5-bigscreen.enable {
    services.xserver.desktopManager.plasma5.bigscreen = {
      enable = true;
    };

    qt = {
      enable = true;
      platformTheme = "kde";
    };

    environment = {
      plasma5.excludePackages = with pkgs; with libsForQt5; [
        elisa
        spectacle
        konsole
        kwalletmanager
        breeze-qt5
        breeze-gtk
        breeze-icons
        oxygen
        oxygen-icons5
        oxygen-sounds
        plasma-workspace-wallpapers
      ];
    };
  };
}
