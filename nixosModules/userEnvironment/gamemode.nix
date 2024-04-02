{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    userEnvironment.gamemode = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Enable gamemode.";
      };
    };
  };

  config = mkIf config.nixos.userEnvironment.gamemode.enable {
    programs.gamemode.enable = true;
  };
}
