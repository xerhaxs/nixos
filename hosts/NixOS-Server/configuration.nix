{ config, lib, pkgs, ... }:

{
  nixos.base.tools.syncthing.enable = lib.mkForce true;

  nixos.hardware = {
    intelcpu.enable = true;
    intelgpu.enable = true;
  };

  nixos.server.enable = lib.mkForce true;

  nixos.system.powermanagement.profiles.performance = lib.mkForce true;

  nixos.system.user.defaultuser = {
    name = "admin";
    pass = "$y$j9T$MXbWf.peSOtvQQtYvZvuZ.$7XUvmCniT4h4o.SFaGqD29F13RWyGW7bNpBcMpHKHH3";
  };
}