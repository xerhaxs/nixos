{ config, lib, pkgs, ... }:

{
  options.nixos = {
    userEnvironment.gamescope = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable gamescope.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.gamescope.enable {
    programs.gamescope = {
      enable = true;
    };
  };
}
