{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.usenet.lidarr = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable Lidarr.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.usenet.lidarr.enable {
    services.lidarr = {
      enable = true;
      openFirewall = false;
      #dataDir = "";
    };
  };
}
