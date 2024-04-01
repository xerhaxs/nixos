{ config, pkgs, ... }:

{
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # Gaming
    mangohud
    antimicrox
    #lutris
    #heroic
    #steam
    wine

    # Customizations
    #fanctl
    openrgb-with-all-plugins
    #piper
  ];
}


