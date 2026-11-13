{
  config,
  lib,
  pkgs,
  private,
  ...
}:

{
  system.stateVersion = "26.05";

  nixos.system.user.passwordFromSops = lib.mkForce false;

  nixos.hardware.amdcpu.enable = true;

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
}
