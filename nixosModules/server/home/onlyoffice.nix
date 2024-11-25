{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.home.onlyoffice = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Onlyoffice.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.home.onlyoffice.enable {
    services.onlyoffice = {
      enable = true;
      hostname = "onlyoffice.${config.nixos.server.network.nginx.domain}";
      enableExampleServer = true;
      jwtSecretFile = null;
      examplePort = 8000;
      port = 8000;
    };

    networking.enableIPv6 = lib.mkForce true;

    services.nginx = {
      virtualHosts = {
        "onlyoffice.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          #listen = [ { addr = "127.0.0.1"; port = 8000; } ];
          #locations."/" = {
          #  proxyPass = "http://localhost:8000";
          #};
        };
      };
    };

    services.ddclient.domains = [
      "onlyoffice.${config.nixos.server.network.nginx.domain}"
    ];
  };
}
