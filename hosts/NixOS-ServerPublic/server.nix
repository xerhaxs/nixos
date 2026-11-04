{
  config,
  lib,
  pkgs,
  ...
}:

{
  nixos.server.network.nginx.enable = true;

  nixos.server.public = {
    enable = true;
    # Only for testing on NixOS-ServerGaming (hosts/NixOS-ServerGaming/temp).
    collabora.enable = false;
    murmur.enable = false;
    nextcloud.enable = false;
    matrix.bridges = {
      discord.enable = true;
      signal.enable = true;
      telegram.enable = true;
      whatsapp.enable = true;
    };
  };
}
