{ config, lib, pkgs, ... }:

{
  options.nixos = {
    game.userEnvironment.gamescope = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable gamescope.";
      };
    };
  };

  config = lib.mkIf config.nixos.game.userEnvironment.gamescope.enable {
    programs.gamescope = {
      enable = true;
    };
  };
}
