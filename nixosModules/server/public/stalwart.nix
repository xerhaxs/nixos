{
  config,
  lib,
  pkgs,
  ...
}:

let
  domain = config.nixos.server.network.nginx.domain;
  mailDomain = config.nixos.site.mailDomain;
  hostname = "mail.${mailDomain}";

  mailVhosts = [
    hostname
    "autoconfig.${mailDomain}"
    "autodiscover.${mailDomain}"
    "mta-sts.${mailDomain}"
  ];

  pgpKey = config.nixos.site.pgpPublicKey;

  # Web Key Directory (advanced method): openpgpkey.<mailDomain>/.well-known/openpgpkey/<domain>/hu/<hash>
  wkd = pkgs.runCommand "wkd-${mailDomain}" { nativeBuildInputs = [ pkgs.gnupg ]; } ''
    export GNUPGHOME="$(mktemp -d)"
    mkdir -p $out/.well-known/openpgpkey
    gpg --batch --show-keys --with-colons ${pgpKey} \
      | awk -F: '$1 == "uid" { print $10 }' | grep -oi '[a-z0-9._%+-]*@${lib.escapeRegex mailDomain}' | sort -u \
      | while read -r mbox; do gpg-wks-client --install-key -C $out/.well-known/openpgpkey ${pgpKey} "$mbox"; done
    touch $out/.well-known/openpgpkey/${mailDomain}/policy
  '';
in

{
  options.nixos = {
    server.public.stalwart = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable stalwart.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.public.stalwart.enable {
    sops.secrets."stalwart/admin" = { };

    services.stalwart = {
      enable = true;
      openFirewall = false;
      stateVersion = "26.05";
      dataDir = "${config.nixos.server.dataDir}/stalwart";

      credentials = {
        "admin-pw" = config.sops.secrets."stalwart/admin".path;
        "cert.pem" = "${config.security.acme.certs.${hostname}.directory}/fullchain.pem";
        "key.pem" = "${config.security.acme.certs.${hostname}.directory}/key.pem";
      };

      settings = {
        server = {
          hostname = hostname;
          tls = {
            enable = true;
            implicit = false;
          };
          listener = {
            smtp = {
              bind = [ "[::]:25" ];
              protocol = "smtp";
            };
            submission = {
              bind = [ "[::]:587" ];
              protocol = "smtp";
            };
            submissions = {
              bind = [ "[::]:465" ];
              protocol = "smtp";
              tls.implicit = true;
            };
            imaps = {
              bind = [ "[::]:993" ];
              protocol = "imap";
              tls.implicit = true;
            };
            http = {
              bind = [ "127.0.0.1:8080" ];
              protocol = "http";
            };
          };
        };

        http = {
          url = "'https://${hostname}'";
          use-x-forwarded = true;
        };

        lookup.default = {
          hostname = hostname;
          domain = mailDomain;
        };

        certificate.default = {
          cert = "%{file:/run/credentials/stalwart.service/cert.pem}%";
          private-key = "%{file:/run/credentials/stalwart.service/key.pem}%";
          default = true;
        };

        authentication.fallback-admin = {
          user = "admin";
          secret = "%{file:/run/credentials/stalwart.service/admin-pw}%";
        };
      };
    };

    networking.firewall.allowedTCPPorts = [
      25
      465
      587
      993
    ];

    systemd.services.stalwart = {
      wants = [ "acme-${hostname}.service" ];
      after = [ "acme-${hostname}.service" ];
    };

    services.nginx = {
      virtualHosts =
        let
          stalwartProxy = {
            forceSSL = true;
            enableACME = true;
            kTLS = true;
            http2 = true;
            locations."/" = {
              proxyPass = "http://127.0.0.1:8080";
              proxyWebsockets = true;
            };
          };
        in
        lib.genAttrs mailVhosts (_: stalwartProxy)
        // {
          # webadmin
          "stalwart.${domain}" = stalwartProxy // {
            acmeRoot = null;
          };
        }
        // lib.optionalAttrs (pgpKey != null) {
          "openpgpkey.${mailDomain}" = {
            forceSSL = true;
            enableACME = true;
            root = wkd;
            locations."/.well-known/openpgpkey/".extraConfig = ''
              default_type application/octet-stream;
              add_header Access-Control-Allow-Origin "*" always;
              ${config.nixos.server.network.nginx.securityHeaders}
            '';
          };
        };
    };

    security.acme.certs =
      lib.genAttrs (mailVhosts ++ lib.optional (pgpKey != null) "openpgpkey.${mailDomain}") (_: {
        dnsProvider = null;
      })
      // {
        ${hostname} = {
          dnsProvider = null;
          reloadServices = [ "stalwart.service" ];
        };
      };

    environment.persistence."/persistent" =
      lib.mkIf
        (
          config.nixos.disko.disko-luks-btrfs-tmpfs.enable
          && lib.hasPrefix "/var/lib/" config.services.stalwart.dataDir
        )
        {
          directories = [
            {
              directory = config.services.stalwart.dataDir;
              user = config.services.stalwart.user;
              group = config.services.stalwart.group;
              mode = "0700";
            }
          ];
        };
  };
}
