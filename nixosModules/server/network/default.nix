{ config, lib, pkgs, ... }:

{ 
  imports = [
    ./ddclient.nix
    ./networking.nix
    ./nginx.nix
    ./pihole.nix
  ];

  options.nixos = {
    server.network = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable network modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.network.enable {
    nixos.server.network = {
      ddclient.enable = true;
      networking.enable = true;
      nginx.enable = true;
      pihole.enable = true;
    };
  };
}
