{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.home.jellyfin = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Jellyfin.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.home.jellyfin.enable {
    #environment.systemPackages = with pkgs; [
    #  jellyfin
    #  jellyfin-web
    #  jellyfin-ffmpeg
    #];

    services.jellyfin = {
      enable = true;
      openFirewall = false;
    };
  };
}
