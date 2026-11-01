{
  config,
  lib,
  pkgs,
  ...
}:

{
  nixos.system.wireguard.enable = true;
}
