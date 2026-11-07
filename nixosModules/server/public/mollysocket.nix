{
  config,
  lib,
  pkgs,
  ...
}:

let
  domain = config.nixos.server.network.nginx.domain;
  hostname = "molly.${domain}";
  port = 8020;
in

{
  options.nixos = {
    server.public.mollysocket = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable MollySocket (UnifiedPush for the Signal client Molly, secret mollysocket/env with MOLLY_VAPID_PRIVKEY).";
      };
    };
  };

  config = lib.mkIf config.nixos.server.public.mollysocket.enable {
    sops.secrets."mollysocket/env".restartUnits = [ "mollysocket.service" ];

    services.mollysocket = {
      enable = true;
      environmentFile = config.sops.secrets."mollysocket/env".path;
      settings = {
        host = "127.0.0.1";
        inherit port;
        allowed_endpoints = [ "https://push.${config.nixos.site.domain}" ];
      };
    };

    services.nginx = {
      virtualHosts = {
        "${hostname}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString port}";
          };
        };
      };
    };
  };
}
