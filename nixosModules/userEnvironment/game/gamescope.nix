{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    userEnvironment.game.gamescope = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable gamescope.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.game.gamescope.enable {
    programs.gamescope = {
      enable = true;
    };
  };
}
