{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.home.cockpit = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable cockpit.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.home.cockpit.enable {
    services.cockpit = {
      enable = true;
      openFirewall = false;
      port = 9090;
      showBanner = true;
      allowed-origins = [ "127.0.0.1" ];
      settings = { };
      plugins = with pkgs; [
        cockpit-zfs
        cockpit-files
        cockpit-podman
        cockpit-machines
      ];
    };

    services.nginx = {
      virtualHosts = {
        "cockpit.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          proxyWebsockets = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:9090/";
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_http_version 1.1;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";
            '';
          };
        };
      };
    };
  };
}
