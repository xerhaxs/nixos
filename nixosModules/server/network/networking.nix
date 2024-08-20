{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.network.networking = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Networking.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.network.networking.enable {
  };
}
