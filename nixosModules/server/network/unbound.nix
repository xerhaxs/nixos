{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.network.unbound = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable unbound.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.network.unbound.enable {
    services.unbound = {
    };
  };
}
