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
    matrix.bridges = {
      discord.enable = true;
      signal.enable = true;
      telegram.enable = true;
      whatsapp.enable = true;
    };
  };

  nixos.server.tools.codeserver.enable = true;
}
