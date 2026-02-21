{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.getty.autologinUser = null;

  nixos.server.network.nginx.enable = true;

  nixos.server.network.ddclient.enable = true;

  nixos.server.game.minecraft.enable = true;

  nixos.system.nasmount.enable = false;
}
