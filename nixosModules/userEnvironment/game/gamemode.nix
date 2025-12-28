{ config, lib, pkgs, ... }:

{
  options.nixos = {
    userEnvironment.game.gamemode = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable gamemode.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.game.gamemode.enable {
    programs.gamemode.enable = true;
  };
}
