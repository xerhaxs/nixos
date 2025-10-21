{ config, lib, pkgs, ... }:

{ 
  imports = [
    ./jellyfin.nix
    ./ollama.nix
    ./radicale.nix
  ];

  options.nixos = {
    server.home = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable home modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.home.enable {
    nixos.server.home = {
      jellyfin.enable = true;
      ollama.enable = false;
      radicale.enable = true;
    };
  };
}
