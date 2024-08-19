{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.game.minecraft = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Minecraft Server.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.game.minecraft.enable {
    services.minecraft-server = {
      enable = true;
      eula = true;
      openFirewall = true;
    };
  };
}
