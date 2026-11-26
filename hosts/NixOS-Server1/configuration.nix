{
  config,
  lib,
  pkgs,
  ...
}:

{
  _module.args.userName = "admin";

  nixos.system.sops.file = "nixos-server1";
  nixos.system.user.passwordFromSops = true;

  # Every failed ssh login scores 10: block after the third one, not the first (clients in the LAN
  # without a fixed address, a locked KeePassXC).
  services.sshguard.attack_threshold = lib.mkForce 30;

  # Off until the rework is merged, it would switch back to the old configuration of main.
}
