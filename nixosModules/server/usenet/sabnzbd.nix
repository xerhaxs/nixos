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
      openFirewall = false;
      allowConfigWrite = false;
      secretFiles = [
        config.sops.secrets."sabnzbd".path
      ];
      settings = {
        misc = {
          host = "127.0.0.1";
          port = "8080";
          bandwidth_max = "5M";
          cache_limit = "1G";
          language = "en";
          download_dir = "/mount/truenas/video/SABnzbd/temp";
          complete_dir = "/mount/truenas/video/SABnzbd/done";
          #movie_categories = movies,
          #tv_categories = tv,
          #url_base = /sabnzbd
          host_whitelist = "sabnzbd.${config.nixos.server.network.nginx.domain}";
        };
      };
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
  };
}
