{ config, pkgs, ... }:

{
  services.xserver = {
    defaultDepth = 30;
    xrandrHeads = [
      "DP-1" {
        output = "DP-1";
        primary = true;
      }
    ];
  };

  services.xserver.excludePackages = with pkgs; [
    xterm
  ];
}
