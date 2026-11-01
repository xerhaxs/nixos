{
  config,
  lib,
  pkgs,
  ...
}:

{
  system.stateVersion = "25.11";

  nixos.hardware.amdcpu.enable = true;

  nixos.userEnvironment.syncthing.enable = false;

  services.qemuGuest.enable = true;
  services.spice-autorandr.enable = true;
  services.spice-vdagentd.enable = true;
  services.spice-webdavd.enable = true;
}
