{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.fediverse.matrix = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable matrix server.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.matrix.enable {
    services.matrix-synapse = {
      enable = true;
    };

    services.nginx = {
      virtualHosts = {
        "matrix.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:64738";
          };
        };
      };
    };
  };
}
