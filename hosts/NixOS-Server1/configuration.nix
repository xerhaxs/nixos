{ config, lib, pkgs, ... }:

{
  nixos.hardware = {
    amdcpu.enable = true;
    amdgpu.enable = true;
  };

  nixos.system.user.defaultuser = {
    name = "admin";
    passfile = config.sops.secrets."user/nixos-server1/admin".path;
  };

  services.qemuGuest.enable = true;
}