{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.home.networking-toolbox = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable networking-toolbox.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.home.networking-toolbox.enable {
    virtualisation.oci-containers.containers = {
        networking-toolbox = {
          image = "docker.io/lissy93/networking-toolbox:latest";

          ports = [
            "3872:3872"
          ];

          environment = {
            NODE_ENV = "production";
            PORT = "3872";
            HOST = "0.0.0.0";
          };

          healthcheck = {
            test = [ "CMD" "wget" "-qO-" "http://127.0.0.1:3872/health" ];
            interval = "30s";
            timeout = "10s";
            retries = 3;
            startPeriod = "40s";
          };

          restart = "unless-stopped";
        };
      };

    services.nginx = {
      virtualHosts = {
        "networkingtoolbox.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = { 
            proxyPass = "http://localhost:3872";
          };
        };
      };
    };
  };
}
