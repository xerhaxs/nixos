{ config, pkgs, ... }:

{
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # Internet
    brave
    tor-browser-bundle-bin
    mullvad-vpn
    protonvpn-gui
    thunderbird

    # Programms & Utilities
    kmymoney
    backintime
    #grsync
    gnome.gnome-disk-utility
    gnome.file-roller
    #goxlr-utility
    libsForQt5.kate
    yt-dlp # A command-line video downloader
    woeusb-ng # A windows image writer for linux

    # Social
    element-desktop
    signal-desktop
  ];
}
