{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.fediverse.pixelfed = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Pixelfed.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.pixelfed.enable {
    services.pixelfed = {
      enable = true;
    };
  };
}
