{ config, lib, pkgs, ... }:

{ 
  imports = [
    ./minecraft.nix
  ];

  options.nixos = {
    server.game = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable game modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.game.enable {
    nixos.server.game = {
      minecraft.enable = true;
    };
  };
}
