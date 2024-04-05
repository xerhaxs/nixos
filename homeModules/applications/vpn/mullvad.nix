{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    mullvad-browser
    mullvad-vpn
  ];
}

