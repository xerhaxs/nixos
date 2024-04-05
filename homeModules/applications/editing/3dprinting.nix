{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    blender-hip
    cura
    curaengine
  ];
}


