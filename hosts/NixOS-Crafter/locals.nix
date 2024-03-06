{ config, lib, pkgs, ... }:

{
  console.keyMap = pkgs.lib.mkDefault "sg";

  services.xserver = {
    xkb.layout = pkgs.lib.mkDefault "ch";
  };
}
