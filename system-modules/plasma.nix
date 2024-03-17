{ config, pkgs, ... }:

let
    #Wallpaper Engine Plugin
    wallpaper-engine-kde-plugin = pkgs.plasma5Packages.callPackage ./wallpaper-engine-kde-plugin.nix {
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
  imports = [
    ./wallpaper-engine-kde-plugin.nix
  ];

  services.xserver = {
    desktopManager = {
      plasma5.enable = true;
      #plasma6.enable = true;
      #plasma6.enableQt5Integration = true;
    };
  };

  qt.platformTheme = "kde";

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
    ];

    plasma6.excludePackages = with pkgs; with kdePackages; [
      elisa
      spectacle
      kwalletmanager
      breeze
      breeze-icons
      breeze-gtk
      plasma-workspace-wallpapers
      oxygen
      oxygen-icons5
    ];

    systemPackages = with pkgs; with libsForQt5; [
      #wallpaper-engine-kde-plugin
      #(python3.withPackages (python-pkgs: [ python-pkgs.websockets ]))
      #qt5.qtwebsockets

      adw-gtk3
      #mplayer
      sddm-kcm
      #libsForQt5.akonadi
      #libsForQt5.akonadi-import-wizard
      #libsForQt5.merkuro
      #libsForQt5.plasma-browser-integration
      #kwayland-integration
      #libsForQt5.kwin-tiling
      #libsForQt5.bismuth
      filelight
      #libsForQt5.kaccounts-integration
      #libsForQt5.kaccounts-providers
      #libsForQt5.qt5.qtdeclarative
      #libsForQt5.qt5.qtwebchannel
      plasma-framework
      gst_all_1.gst-libav
      xorg.xkill
    ];
  };
}
