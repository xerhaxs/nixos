{ config, lib, pkgs, ... }:

{
  services.xserver = {
    desktopManager = {
      plasma5.bigscreen.enable = true;
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
  };
}
