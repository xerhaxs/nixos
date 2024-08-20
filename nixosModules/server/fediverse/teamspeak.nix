{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.fediverse.teamspeak = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable TeamSpeak.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.teamspeak.enable {
    services.teamspeak3 = {
      enable = true;
      queryIP = "127.0.0.1";
      queryPort = 10011;
      openFirewall = false;
    };

    services.nginx = {
      virtualHosts = {
        "teamspeak.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:10011";
          };
        };
      };
    };
  };
}
