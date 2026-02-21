{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    settings = {
      monitor = ",1920x1280@60,0x0,1,bitdepth,8";
    };
  };
}
