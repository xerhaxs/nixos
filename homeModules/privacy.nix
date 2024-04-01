{ config, pkgs, ... }:

{
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    tor-browser-bundle-bin
    #mullvad-browser
    mullvad-vpn
    #onionshare-gui
    monero-gui
    #protonvpn-gui
  ];
}

