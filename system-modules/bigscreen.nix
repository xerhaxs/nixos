{ config, pkgs, ... }:

{
  services.xserver = {
    desktopManager = {
      plasma5.bigscreen.enable = true;
    };
  };

  qt.platformTheme = "kde";

  environment = {
    plasma5.excludePackages = with pkgs; [
      libsForQt5.elisa
      libsForQt5.spectacle
      libsForQt5.kwalletmanager
      libsForQt5.breeze-qt5
      libsForQt5.breeze-gtk
      libsForQt5.breeze-icons
      libsForQt5.oxygen
      libsForQt5.oxygen-icons5
    ];

    systemPackages = with pkgs; [
      maliit-keyboard
    ];
  };
}
