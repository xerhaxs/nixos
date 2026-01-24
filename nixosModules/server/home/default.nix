{ config, lib, pkgs, ... }:

{ 
  imports = [
    ./glance.nix
    ./homeassistant.nix
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
      glance.enable = true;
      homeassistant.enable = true;
      jellyfin.enable = true;
      ollama.enable = true;
      radicale.enable = true;
    };
  };
}
