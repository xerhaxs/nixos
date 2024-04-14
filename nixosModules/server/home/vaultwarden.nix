{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.home.vaultwarden = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Vaultwarden.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.home.vaultwarden.enable {
    services.vaultwarden = {
      enable = true;
      dbBackend = "sqlite";
      config = {
        DOMAIN = "vaultwarden.bitsync.icu";
        SIGNUPS_ALLOWED = true;

        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;

        ROCKET_LOG = "critical";
      };
    };
  };
}
