{ config, lib, pkgs, ... }:

{
  console.keyMap = lib.mkForce "sg";
  
  nixos.system.locals.consolekbd = lib.mkForce "ch";
}
