{ config, pkgs, ... }:

{
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    #helix
    #pulsar
    okteta
    libsForQt5.kompare
    diffutils
    jetbrains.pycharm-community
    jetbrains.idea-community
    rpi-imager # raspberry pi imaging utility
  ];
}
