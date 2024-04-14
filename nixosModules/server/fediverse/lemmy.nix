{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.fediverse.lemmy = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Lemmy.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.lemmy.enable {
    services.lemmy = {
      enable = true;
    };
  };
}
