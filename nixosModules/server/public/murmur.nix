{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.public.murmur = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Murmur Mumble server.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.public.murmur.enable {
    services.murmur = {
      enable = true;
      openFirewall = false;
    };

    services.botamusique.settings.server = {
      host = "localhost";
      port = "64738";
    };

    services.nginx = {
      virtualHosts = {
        "murmur.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = true;
          locations."/" = {
            proxyPass = "http://localhost:64738";
          };
        };
      };
    };
  };
}
