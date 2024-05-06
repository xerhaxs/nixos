{ config, lib, pkgs, ... }:

{
  options.nixos = {
    desktop.desktopEnvironment.plasma6 = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Plasma6 desktop environment.";
      };
    };
  };

  config = lib.mkIf config.nixos.desktop.desktopEnvironment.plasma6.enable {
    services.desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = true;
    };

    qt = {
      enable = true;
      platformTheme = "kde";
    };

    programs.kdeconnect.package = lib.mkForce pkgs.kdePackages.kdeconnect-kde;

    environment = {
      plasma6.excludePackages = with pkgs; with kdePackages; [
        elisa
        spectacle
        kwalletmanager
        reeze
        breeze-icons
        breeze-gtk
        oxygen
        oxygen-icons5
        oxygen-sounds
        plasma-workspace-wallpapers
        plasma-welcome
      ];

      systemPackages = with pkgs; with kdePackages; [
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
