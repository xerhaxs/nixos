{
  config,
  lib,
  pkgs,
  ...
}:

{
  _module.args.userName = "admin";

  system.autoUpgrade.enable = true;
}
