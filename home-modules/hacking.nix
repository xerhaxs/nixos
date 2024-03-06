{ config, pkgs, ... }:

{
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    tor-browser-bundle-bin
    mullvad-vpn
    rarcrack
  ];
}
