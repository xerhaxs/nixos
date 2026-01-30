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
        image = "docker://lissy93/networking-toolbox:latest";

        ports = [
          { hostPort = 3872; containerPort = 3872; }
        ];

        environment = {
          NODE_ENV = "production";
          PORT = "3872";
          HOST = "0.0.0.0";
        };

        restartPolicy = "unless-stopped";

        #healthCheck = {
        #  test = ["wget" "-qO-" "http://127.0.0.1:3872/health"];
        #  interval = "30s";
        #  timeout = "10s";
        #  retries = 3;
        #  startPeriod = "40s";
        #};
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
