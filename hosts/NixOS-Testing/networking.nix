{ config, lib, pkgs, ... }:

{
  networking = {
    hostName = "NixOS-Testing";
    useDHCP = lib.mkForce true;
  };
}
