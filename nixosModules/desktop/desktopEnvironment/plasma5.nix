{ config, lib, pkgs, ... }:

{
  options.nixos = {
    desktop.desktopEnvironment.plasma5 = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Plasma5 desktop environment.";
      };
    };
  };

  config = lib.mkIf config.nixos.desktop.desktopEnvironment.plasma5.enable {
    services.xserver.desktopManager.plasma5 = {
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

      systemPackages = with pkgs; with libsForQt5; [
        kaccounts-providers
        kaccounts-integration
        plasma-browser-integration
        #kwayland-integration
        #sddm-kcm
        #libsForQt5.akonadi
        #libsForQt5.akonadi-import-wizard
        #libsForQt5.plasma-browser-integration
        #libsForQt5.kwin-tiling
        #libsForQt5.bismuth
        #libsForQt5.qt5.qtdeclarative
        #libsForQt5.qt5.qtwebchannel
        #plasma-framework
        #gst_all_1.gst-libav
      ];
    };
  };
}
