{ config, pkgs, ... }:

{
  programs.corectrl = {
    enable = true;
    gpuOverclock.enable = true;
    gpuOverclock.ppfeaturemask = "0xfff7ffff";
  };
}
