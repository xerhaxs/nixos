{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    settings = {
      monitor = ",2256x1504@60,0x0,1,bitdepth,8";
    };
  };
}

