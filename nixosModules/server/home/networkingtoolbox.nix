{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.home.networkingtoolbox = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable networking-toolbox.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.home.networkingtoolbox.enable {
    virtualisation.oci-containers.containers = {
      networking-toolbox = {
        image = "lissy93/networking-toolbox:latest";

        ports = [
          "3872:3000"
        ];

        environment = {
          NODE_ENV = "production";
          PORT = "3000";
          HOST = "0.0.0.0";
          #NTB_HOMEPAGE_LAYOUT = "categories";
          #NTB_DEFAULT_THEME = "catppuccin";
          #NTB_FONT_SCALE = "2";
        };

        extraOptions = [
          "--pull=always"
          "--health-cmd=wget -qO- http://127.0.0.1:3000/health || exit 1"
          "--health-interval=30s"
          "--health-timeout=10s"
          "--health-retries=3"
          "--health-start-period=40s"
        ];
      };
    };

    systemd.services."${config.virtualisation.oci-containers.backend}-networking-toolbox" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
      };
    };

    networking.firewall.allowedTCPPorts = [ 3872 ];

    services.nginx = {
      virtualHosts = {
        "networkingtoolbox.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = { 
            proxyPass = "http://127.0.0.1:3872";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };
        };
      };
    };
  };
}