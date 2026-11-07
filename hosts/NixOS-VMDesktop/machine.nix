{
  config,
  lib,
  pkgs,
  ...
}:

{
  system.stateVersion = "25.11";

  # The VM has no age key and cannot decrypt the login hash, it uses initialHashedPasswords from site.nix.
  nixos.system.user.passwordFromSops = lib.mkForce false;

  nixos.hardware.amdcpu.enable = true;

  nixos.userEnvironment.syncthing.enable = false;

  services.qemuGuest.enable = true;
  services.spice-autorandr.enable = true;
  services.spice-vdagentd.enable = true;
  services.spice-webdavd.enable = true;
}
