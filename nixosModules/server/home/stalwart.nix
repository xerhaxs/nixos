{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.home.stalwart = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable stalwart.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.home.stalwart.enable {
    services.stalwart = {
    };

    services.nginx = {
      virtualHosts = {
        "stalwart.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:9090/";
            proxyWebsockets = true;
          };
        };
      };
    };
  };
}
