{
  config,
  lib,
  pkgs,
  private,
  ...
}:

{
  system.stateVersion = "26.05";

  sops.defaultSopsFile = lib.mkForce "${private}/secrets/nixos-servergaming.yaml";
  nixos.system.user.passwordFromSops = lib.mkForce false;

  nixos.hardware.amdcpu.enable = true;

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
}
