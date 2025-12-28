{ config, lib, pkgs, ... }:

{
  imports = [
    ./gamemode.nix
    ./gamescope.nix
    ./steam.nix
  ];

  options.nixos = {
    userEnvironment.game = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable game modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.game.enable {
    nixos.userEnvironment.game = {
      gamemode.enable = true;
      gamescope.enable = true;
      steam.enable = true;
    };
  };
}
