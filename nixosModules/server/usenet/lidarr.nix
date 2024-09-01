{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.usenet.lidarr = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
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

    #services.nginx = {
    #  virtualHosts = {
    #    "lidarr.${config.nixos.server.network.nginx.domain}" = {
    #      forceSSL = true;
    #      enableACME = true;
    #      acmeRoot = null;
    #      kTLS = true;
    #      http2 = false;
    #      locations."/" = {
    #        proxyPass = "http://localhost:8686";
    #      };
    #    };
    #  };
    #};
  };
}
