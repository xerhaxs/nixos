{ config, lib, nixos-hardware, pkgs, ... }:

{
  imports = [
    nixos-hardware.nixosModules.framework-13-7040-amd
  ];
}