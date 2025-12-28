{ config, lib, pkgs, ... }:

{
  imports = [
    ./gamemode.nix
    ./gamescope.nix
    ./steam.nix
  ];

  options.nixos = {
    game.userEnvironment = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable userEnvironment modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.game.userEnvironment.enable {
    nixos.game.userEnvironment = {
      gamemode.enable = true;
      gamescope.enable = true;
      steam.enable = true;
    };
  };
}
