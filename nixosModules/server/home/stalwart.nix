{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.home.stalwart = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable stalwart.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.home.stalwart.enable {
    environment.etc = {
      "stalwart/mail-pw1".text = "foobar";
      "stalwart/mail-pw2".text = "foobar";
      "stalwart/admin-pw".text = "foobar";
      "stalwart/acme-secret".text = "secret123";
    };

    services.stalwart = {
      enable = true;
      openFirewall = true;
      stateVersion = "25.11";
      credentials = {
        mail-pw1 = /etc/stalwart/mail-pw1;
        mail-pw2 = /etc/stalwart/mail-pw2;
        acme-secret = /etc/stalwart/acme-secret;
      };
      settings = {
        server = {
          hostname = "mx1.example.org";
          tls = {
            enable = true;
            implicit = true;
          };
          listener = {
            smtp = {
              protocol = "smtp";
              bind = "[::]:25";
            };
            submissions = {
              bind = "[::]:465";
              protocol = "smtp";
              tls.implicit = true;
            };
            imaps = {
              bind = "[::]:993";
              protocol = "imap";
              tls.implicit = true;
            };
            jmap = {
              bind = "[::]:8080";
              url = "https://mail.example.org";
              protocol = "http";
            };
            management = {
              bind = [ "127.0.0.1:8080" ];
              protocol = "http";
            };
          };
        };
        lookup.default = {
          hostname = "mx1.example.org";
          domain = "example.org";
        };
        acme."letsencrypt" = {
          directory = "https://acme-v02.api.letsencrypt.org/directory";
          challenge = "dns-01";
          contact = "user1@example.org";
          domains = [ "example.org" "mx1.example.org" ];
          provider = "cloudflare";
          secret = "%{file:/run/credentials/stalwart.service/acme-secret}%";
        };
        session.auth = {
          mechanisms = "[plain]";
          directory = "'in-memory'";
        };
        storage.directory = "in-memory";
        session.rcpt.directory = "'in-memory'";
        directory."imap".lookup.domains = [ "example.org" ];
        directory."in-memory" = {
          type = "memory";
          principals = [
            {
              class = "individual";
              name = "User 1";
              secret = "%{file:/run/credentials/stalwart.service/mail-pw1}%";
              email = [ "user1@example.org" ];
            }
            {
              class = "individual";
              name = "postmaster";
              secret = "%{file:/run/credentials/stalwart.service/mail-pw1}%";
              email = [ "postmaster@example.org" ];
            }
          ];
        };
        authentication.fallback-admin = {
          user = "admin";
          secret = "%{file:/run/credentials/stalwart.service/admin-pw}%";
        };
      };
    };

    services.nginx = {
      virtualHosts = {
        "stalwart.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:9090/";
            proxyWebsockets = true;
          };
        };
      };
    };
  };
}
