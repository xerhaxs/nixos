{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.network.uptime-kuma = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Uptime Kuma.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.network.uptime-kuma.enable {
    services.uptime-kuma = {
      enable = true;
      appriseSupport = true;
      settings = {
        HOST = "uptime-kuma.bitsync.icu";
        PORT = "8765";
      };
    };
  };
}
