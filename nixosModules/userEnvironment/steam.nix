{ config, lib, pkgs, ... }:

{
  options.nixos = {
    userEnvironment.steam = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable steam.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.steam.enable {
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = false;
    };

    hardware.steam-hardware.enable = true;
  };
}
