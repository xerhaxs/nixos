{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.entertainment.nzbhydra2 = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable NZBHydra2.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.entertainment.nzbhydra2.enable {
    services.nzbhydra2 = {
      enable = true;
      openFirewall = false;
      #dataDir = "/var/lib/nzbhydra2";
      dataDir = "${config.nixos.server.dataDir}/nzbhydra2";
    };

    systemd.services.nzbhydra2.serviceConfig.UMask = "0007";

    services.nginx = {
      virtualHosts = {
        "nzbhydra.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = true;
          locations."/" = {
            proxyPass = "http://localhost:5076";
          };
        };
      };
    };
  };
}
