{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.fediverse.murmur = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Murmur Mumble server.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.murmur.enable {
    services.murmur = {
      enable = true;
      openFirewall = false;
    };
    services.botamusique.settings.server = {
      host = "localhost";
      port = "64738";
    };
  };
}
