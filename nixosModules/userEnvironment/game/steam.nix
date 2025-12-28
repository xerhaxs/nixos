{ config, lib, pkgs, ... }:

{
  options.nixos = {
    userEnvironment.game.steam = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable steam.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.game.steam.enable {
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = false;
      dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
    };

    hardware.steam-hardware.enable = true;
  };
}
