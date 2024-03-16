{ config, pkgs, ... }:

let
  wallpaper-engine-kde-plugin = pkgs.plasma5Packages.callPackage ./wallpaper-engine-plasma-plugin.nix {
    inherit (pkgs.gst_all_1) gst-libav;
    inherit (pkgs.python3Packages) websockets;
    inherit (pkgs.libsForQt5.qt5) qtwebsockets;
  };
    # Python packages
  python-packages = ps: with ps; [
    websockets
    pandas
    numpy
  ];
in

{
  services.xserver = {
    desktopManager = {
      plasma5.enable = true;
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
      wallpaper-engine-kde-plugin
      (python311.withPackages python-packages)
      adw-gtk3
      #mplayer
      libsForQt5.sddm-kcm
      #libsForQt5.akonadi
      #libsForQt5.akonadi-import-wizard
      #libsForQt5.merkuro
      #libsForQt5.plasma-browser-integration
      #kwayland-integration
      #libsForQt5.kwin-tiling
      #libsForQt5.bismuth
      libsForQt5.filelight
      #libsForQt5.kaccounts-integration
      #libsForQt5.kaccounts-providers
      libsForQt5.qt5.qtwebsockets
      #libsForQt5.qt5.qtdeclarative
      #libsForQt5.qt5.qtwebchannel
      libsForQt5.plasma-framework
      gst_all_1.gst-libav
      xorg.xkill
    ];
  };
}
