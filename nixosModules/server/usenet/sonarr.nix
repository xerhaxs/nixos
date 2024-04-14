{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.usenet.sonarr = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Sonarr.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.usenet.sonarr.enable {
    services.sonarr = {
      enable = true;
      openFirewall = false;
      #dataDir = "";
    };
  };
}
