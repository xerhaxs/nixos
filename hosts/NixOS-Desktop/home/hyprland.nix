{
  config,
  lib,
  pkgs,
  ...
}:

{
  wayland.windowManager.hyprland = {
    settings = {
      monitor = "DP-1,3840x1600@144,0x0,1,bitdepth,10";
    };
  };
}
