{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.media.clients = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable media clients.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.media.clients.enable {
    home.packages = with pkgs; [
      fluent-reader
      freetube
      mediathekview
      #nuclear
      qbittorrent
      #jellyfin-media-player
    ];
  };
}


