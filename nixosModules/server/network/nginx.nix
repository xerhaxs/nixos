{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.nixos.server.network.nginx;
  selfSigned = cfg.challenge == "selfsigned";
  certDir = "/var/lib/nginx-selfsigned";
in

{
  # Without ACME (offline, portable host) every vhost uses one self-signed wildcard certificate.
  options.services.nginx.virtualHosts = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        { name, ... }:
        {
          config = lib.mkIf (selfSigned && name != "_") {
            enableACME = lib.mkForce false;
            useACMEHost = lib.mkForce null;
            sslCertificate = lib.mkForce "${certDir}/cert.pem";
            sslCertificateKey = lib.mkForce "${certDir}/key.pem";
          };
        }
      )
    );
  };

  options.nixos = {
    server.network.nginx = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Nginx.";
      };

      domain = lib.mkOption {
        type = lib.types.str;
        default = config.nixos.site.domain;
        defaultText = lib.literalExpression "config.nixos.site.domain";
        example = "example.com";
        description = "Domain for nginx.";
      };

      challenge = lib.mkOption {
        type = lib.types.enum [
          "dns-01"
          "http-01"
          "selfsigned"
        ];
        default = "dns-01";
        example = "http-01";
        description = "Set the default ACME challenge, selfsigned uses a self-signed wildcard certificate without ACME.";
      };

      acmeEmail = lib.mkOption {
        type = lib.types.str;
        default = config.nixos.site.acmeEmail;
        defaultText = lib.literalExpression "config.nixos.site.acmeEmail";
        description = "Contact email for ACME (Let's Encrypt).";
      };

      securityHeaders = lib.mkOption {
        type = lib.types.lines;
        readOnly = true;
        default = ''
          add_header Strict-Transport-Security "max-age=63072000" always;
          add_header X-Content-Type-Options "nosniff" always;
          add_header Referrer-Policy "strict-origin-when-cross-origin" always;
        '';
        description = "Security headers of all vhosts, repeat them in locations with own add_header (nginx drops inherited headers there).";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets."nginx/acme/api_key" = lib.mkIf (cfg.challenge == "dns-01") { };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    services.nginx = {
      enable = true;

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      commonHttpConfig = cfg.securityHeaders;

      virtualHosts."_" = {
        default = true;
        rejectSSL = true;
        locations."/".return = "444";
      };

      #virtualHosts = {
      #"${cfg.domain}" = {
      #  forceSSL = true;
      #  enableACME = true;
      #  acmeRoot = null;
      #  kTLS = true;
      #  http2 = true;
      #  http3 = true;
      #  quic = true;
      #  root = "/mount/Data/Datein/Server/startpage/index.html";
      #};
      #};
    };

    security.acme = lib.mkMerge [
      (lib.mkIf (cfg.challenge == "dns-01") {
        acceptTerms = true;
        defaults = {
          email = cfg.acmeEmail;
          #dnsResolver = "127.0.0.1"; # for usage behind mullvad vpn
          dnsProvider = "cloudflare";
          #dnsPropagationCheck = false; # for usage behind mullvad vpn
          # lego 5 renamed the flag, an unknown flag fails every new order and renewal.
          extraLegoFlags = [
            "--dns.propagation.wait"
            "60s"
          ];
          renewInterval = "daily";
          environmentFile = config.sops.secrets."nginx/acme/api_key".path;
        };
      })
      (lib.mkIf (cfg.challenge == "http-01") {
        acceptTerms = true;
        defaults = {
          email = cfg.acmeEmail;
          renewInterval = "daily";
        };
      })
    ];

    systemd.services.nginx-selfsigned = lib.mkIf selfSigned {
      description = "Create the self-signed wildcard certificate of nginx";
      before = [ "nginx.service" ];
      requiredBy = [ "nginx.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        StateDirectory = "nginx-selfsigned";
        StateDirectoryMode = "0750";
      };
      script = ''
        if [ ! -s ${certDir}/key.pem ]; then
          ${pkgs.openssl}/bin/openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -nodes -days 3650 \
            -subj "/CN=*.${cfg.domain}" -addext "subjectAltName=DNS:*.${cfg.domain},DNS:${cfg.domain}" \
            -keyout ${certDir}/key.pem -out ${certDir}/cert.pem
        fi
        chown -R ${config.services.nginx.user}:${config.services.nginx.group} ${certDir}
        chmod 0600 ${certDir}/key.pem
      '';
    };

    environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        "/var/lib/acme"
      ]
      ++ lib.optional selfSigned certDir;
    };
  };
}
