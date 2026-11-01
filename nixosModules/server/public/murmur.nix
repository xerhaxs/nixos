{
  config,
  lib,
  pkgs,
  ...
}:

let
  hostname = "murmur.${config.nixos.server.network.nginx.domain}";
in

{
  options.nixos = {
    server.public.murmur = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Murmur Mumble server.";
      };

      passwordProtected = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Require the server password from sops (murmur/env, MURMURD_PASSWORD) to join.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.public.murmur.enable {
    sops.secrets."murmur/env" = lib.mkIf config.nixos.server.public.murmur.passwordProtected { };

    services.murmur = {
      enable = true;
      openFirewall = true;
      port = 64738;
      registerHostname = hostname;
      welcometext = "Welcome to ${hostname}";
      bandwidth = 130000;
      autobanAttempts = 10;
      autobanTimeframe = 120;
      autobanTime = 300;
      tls = {
        certPath = "/run/credentials/murmur.service/cert.pem";
        keyPath = "/run/credentials/murmur.service/key.pem";
      };
      password = lib.mkIf config.nixos.server.public.murmur.passwordProtected "$MURMURD_PASSWORD";
      environmentFile =
        lib.mkIf config.nixos.server.public.murmur.passwordProtected
          config.sops.secrets."murmur/env".path;
    };

    systemd.services.murmur = {
      wants = [ "acme-${hostname}.service" ];
      after = [ "acme-${hostname}.service" ];
      serviceConfig.LoadCredential = [
        "cert.pem:${config.security.acme.certs.${hostname}.directory}/fullchain.pem"
        "key.pem:${config.security.acme.certs.${hostname}.directory}/key.pem"
      ];
    };

    security.acme.certs.${hostname}.reloadServices = [ "murmur.service" ];

    services.nginx = {
      virtualHosts = {
        "${hostname}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = true;
          locations."/".return = "200 'Mumble server: ${hostname}:64738\\n'";
          extraConfig = ''
            default_type text/plain;
          '';
        };
      };
    };

    environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        {
          directory = "/var/lib/murmur";
          user = "murmur";
          group = "murmur";
          mode = "0700";
        }
      ];
    };
  };
}
