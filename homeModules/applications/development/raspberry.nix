{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    rpi-imager
  ];
}
