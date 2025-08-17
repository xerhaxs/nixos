{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.usenet.sabnzbd = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable SABnzbd.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.usenet.sabnzbd.enable {
    services.sabnzbd = {
      enable = true;
      openFirewall = true;
      configFile = "/var/lib/sabnzbd/sabnzbd.ini";
    };

    services.nginx = {
      virtualHosts = {
        "sabnzbd.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8080";
          };
        };
      };
    };

    #services.ddclient.domains = [
    #  "sabnzbd.${config.nixos.server.network.nginx.domain}"
    #];
  };
}
