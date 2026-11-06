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

  nixos.server.tools.codeserver.listenAddress = "127.0.0.1";

  nixos.hardware.amdcpu.enable = true;

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
}
