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

  # Off until the rework is merged, it would switch back to the old configuration of main (TODO phase 17).
  system.autoUpgrade.enable = false;
}
