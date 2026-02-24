{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.usenet.nzbhydra2 = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable NZBHydra2.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.usenet.nzbhydra2.enable {
    services.nzbhydra2 = {
      enable = true;
      openFirewall = false;
      #dataDir = "/var/lib/nzbhydra2";
      dataDir = "/pool01/applications/nzbhydra2";
    };

    services.nginx = {
      virtualHosts = {
        "nzbhydra.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:5076";
          };
        };
      };
    };
  };
}
