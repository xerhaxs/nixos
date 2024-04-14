{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.usenet.radarr = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Radarr.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.usenet.radarr.enable {
    services.radarr = {
      enable = true;
      openFirewall = false;
      #dataDir = "";
    };
  };
}
