{
  config,
  lib,
  pkgs,
  ...
}:

let
  hostname = "turn.${config.nixos.server.network.nginx.domain}";
  minPort = 49152;
  maxPort = 49999;
in

{
  options.nixos = {
    server.public.coturn = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable coturn TURN server.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.public.coturn.enable {
    sops.secrets."coturn/secret" = {
      owner = "turnserver";
      group = "turnserver";
      mode = "0400";
    };

    services.coturn = {
      enable = true;
      realm = hostname;
      use-auth-secret = true;
      static-auth-secret-file = config.sops.secrets."coturn/secret".path;
      listening-port = 3478;
      tls-listening-port = 5349;
      min-port = minPort;
      max-port = maxPort;
      no-cli = true;
      cert = "/run/credentials/coturn.service/cert.pem";
      pkey = "/run/credentials/coturn.service/key.pem";
      extraConfig = ''
        fingerprint
        no-multicast-peers
        no-tlsv1
        no-tlsv1_1
        # never relay into private networks (LAN, WireGuard, localhost)
        denied-peer-ip=0.0.0.0-0.255.255.255
        denied-peer-ip=10.0.0.0-10.255.255.255
        denied-peer-ip=100.64.0.0-100.127.255.255
        denied-peer-ip=127.0.0.0-127.255.255.255
        denied-peer-ip=169.254.0.0-169.254.255.255
        denied-peer-ip=172.16.0.0-172.31.255.255
        denied-peer-ip=192.0.0.0-192.0.0.255
        denied-peer-ip=192.0.2.0-192.0.2.255
        denied-peer-ip=192.88.99.0-192.88.99.255
        denied-peer-ip=192.168.0.0-192.168.255.255
        denied-peer-ip=198.18.0.0-198.19.255.255
        denied-peer-ip=198.51.100.0-198.51.100.255
        denied-peer-ip=203.0.113.0-203.0.113.255
        denied-peer-ip=240.0.0.0-255.255.255.255
        denied-peer-ip=::1
        denied-peer-ip=64:ff9b::-64:ff9b::ffff:ffff
        denied-peer-ip=::ffff:0.0.0.0-::ffff:255.255.255.255
        denied-peer-ip=100::-100::ffff:ffff:ffff:ffff
        denied-peer-ip=2001::-2001:1ff:ffff:ffff:ffff:ffff:ffff:ffff
        denied-peer-ip=2002::-2002:ffff:ffff:ffff:ffff:ffff:ffff:ffff
        denied-peer-ip=fc00::-fdff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
        denied-peer-ip=fe80::-febf:ffff:ffff:ffff:ffff:ffff:ffff:ffff
        user-quota=12
        total-quota=1200
      '';
    };

    systemd.services.coturn = {
      wants = [ "acme-${hostname}.service" ];
      after = [ "acme-${hostname}.service" ];
      serviceConfig.LoadCredential = [
        "cert.pem:${config.security.acme.certs.${hostname}.directory}/fullchain.pem"
        "key.pem:${config.security.acme.certs.${hostname}.directory}/key.pem"
      ];
    };

    security.acme.certs.${hostname}.reloadServices = [ "coturn.service" ];

    networking.firewall = {
      allowedTCPPorts = [
        3478
        5349
      ];
      allowedUDPPorts = [
        3478
        5349
      ];
      allowedUDPPortRanges = [
        {
          from = minPort;
          to = maxPort;
        }
      ];
    };

    services.nginx = {
      virtualHosts = {
        "${hostname}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = true;
          locations."/".return = "404";
        };
      };
    };
  };
}
