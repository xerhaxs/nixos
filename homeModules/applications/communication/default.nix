{ config, lib, pkgs, ... }:

{
  imports = [
    ./discord.nix
    ./protonmail-bridge.nix
    ./social.nix
    ./thunderbird.nix
  ];

  options.homeManager = {
    applications.communication = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable communication modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.communication.enable {
    homeManager.applications.communication = {
      discord.enable = true;
      protonmail-bridge.enable = true;
      social.enable = true;
      thunderbird.enable = true;
    };
  };
}