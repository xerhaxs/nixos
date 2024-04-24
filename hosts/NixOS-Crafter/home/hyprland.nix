{ config, lib, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    settings = {
      monitor = ",1600x900@60,0x0,1,bitdepth,8";
    };
  };
}

