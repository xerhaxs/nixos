{ config, pkgs, ... }:

{
  services = {
    desktopManager = {
      plasma6.enable = true;
      plasma6.enableQt5Integration = true;
    };
  };

  qt = {
    enable = true;
    platformTheme = "kde";
  };

  environment = {
    plasma6.excludePackages = with pkgs; with kdePackages; [
      elisa
      spectacle
      kwalletmanager
      breeze
      breeze-icons
      breeze-gtk
      oxygen
      oxygen-icons5
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
}
