{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.fediverse.peertube = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable Peertube.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.peertube.enable {
    services.peertube = {
      enable = true;
    };
  };
}
