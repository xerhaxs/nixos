{ config, lib, pkgs, ... }:

{
  nixos.hardware = {
    amdcpu.enable = true;
    amdgpu.enable = true;
  };

  nixos.system.user.defaultuser = {
    name = "admin";
    pass = "$y$j9T$MXbWf.peSOtvQQtYvZvuZ.$7XUvmCniT4h4o.SFaGqD29F13RWyGW7bNpBcMpHKHH3";
    #passfile = config.sops.secrets."user/nixos-server2/admin".path;
  };

  services.qemuGuest.enable = true;
}