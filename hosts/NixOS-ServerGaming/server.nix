{
  config,
  lib,
  pkgs,
  ...
}:

{
  nixos.server.network.nginx.enable = true;

  # The countdown and the other test services are in temp/.
  nixos.server.game.minecraft.enable = true;
}
