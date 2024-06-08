{ config, lib, pkgs, ... }:

{
  nixos.server.enable = lib.mkForce false;

  nixos.server = {
    
  };
}