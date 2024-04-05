{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    #gst_all_1.gst-libav
    handbrake
  ];
}