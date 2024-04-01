{ config, lib, pkgs, ... }:

{
  imports = [
    ../pkgs/wallpaper-engine-kde-plugin.nix
  ];

  services.xserver = {
    desktopManager = {
      plasma5.enable = true;
    };
  };

  qt = {
    enable = true;
    platformTheme = "kde";
  };

  environment = {
    plasma5.excludePackages = with pkgs; with libsForQt5; [
      elisa
      spectacle
      kwalletmanager
      breeze-qt5
      breeze-gtk
      breeze-icons
      oxygen
      oxygen-icons5
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
}
