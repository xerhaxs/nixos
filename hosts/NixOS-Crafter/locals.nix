{ config, lib, pkgs, ... }:

{
  console.keyMap = lib.mkDefault "sg";
  
  nixos.system.locals.consolekbd = lib.mkDefault "ch";
}
