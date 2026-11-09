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
    # The domain comes from the private site.nix, the key itself is public.
    cryptpad.adminKeys = [
      "[admin@cryptpad.${config.nixos.server.network.nginx.domain}/EXIyX3ovFiUkMiG5Ma8ZLYo+7DNNf4+U1lP04lwn4jc=]"
    ];
    # Only for testing on NixOS-ServerGaming (hosts/NixOS-ServerGaming/temp).
    collabora.enable = false;
    nextcloud.enable = false;
    matrix.bridges = {
      doublePuppet = true;
      discord.enable = true;
      signal.enable = true;
      telegram.enable = true;
      whatsapp.enable = true;
    };
  };
}
