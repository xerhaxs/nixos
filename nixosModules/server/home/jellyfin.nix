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

    services.nginx = {
      virtualHosts = {
        "jellyfin.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = { 
            proxyPass = "http://localhost:8096";
          };
        };
      };
    };
  };
}
