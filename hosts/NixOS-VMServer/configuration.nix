{ config, lib, pkgs, ... }:

{
  nixos.hardware = {
    amdcpu.enable = true;
    amdgpu.enable = true;
  };

  nixos.system.user.defaultuser = {
    name = "admin";
    pass = "$y$j9T$ZEmmQ3X2ZJ2SjdORzgtXH1$n7.HG3CbcKpKv1gZjrAhbFJzqsjNNUsh7mCxxzoEPbB";
  };

  services.getty.autologinUser = null;

  services.qemuGuest.enable = true;
  services.spice-autorandr.enable = true;
  services.spice-vdagentd.enable = true;
  services.spice-webdavd.enable = true;
}