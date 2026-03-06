{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.fediverse.forgejo = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable forgejo.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.forgejo.enable {
    # https://forgejo.org/docs/latest/admin/config-cheat-sheet/
    # https://forgejo.org/docs/latest/user/repo-mirror/
    services.forgejo = {
      enable = true;
      user = "forgejo";
      group = "forgejo";
      #stateDir = "/var/lib/forgejo";
      stateDir = "/pool01/applications/forgejo";

      database = {
        type = "sqlite3";
      };

      useWizard = false;
      lfs.enable = true;

      settings = {
        server = {
          DOMAIN = "127.0.0.1";
          ROOT_URL = "https://forgejo.${config.nixos.server.network.nginx.domain}"; 
          HTTP_PORT = 3005;
          DISABLE_SSH = true;
          LANDING_PAGE = "explore"; # home, explore, organizations, login, custom
          LFS_START_SERVER = true;
        };

        session = {
          COOKIE_SECURE = true;
          SAME_SITE = "strict";
        };

        service = {
          DISABLE_REGISTRATION = true;
          REQUIRE_SIGNIN_VIEW = false;
          REGISTER_EMAIL_CONFIRM = false;
          ENABLE_NOTIFY_MAIL = false;
          DEFAULT_KEEP_EMAIL_PRIVATE = true;
          DEFAULT_ALLOW_CREATE_ORGANIZATION = true;
          DEFAULT_ENABLE_TIMETRACKING = true;
          #NO_REPLY_ADDRESS = "noreply@${config.nixos.server.fediverse.forgejo.domain}";
        };

        actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "https://github.com";
        };

        ui = {
          DEFAULT_THEME = "forgejo-auto";
          THEMES = "auto,forgejo-light,forgejo-dark,arc-green";
        };

        repository = {
          DEFAULT_BRANCH = "master";
          ENABLE_PUSH_CREATE_USER = true;
          ENABLE_PUSH_CREATE_ORG = true;
          DEFAULT_PRIVATE = "private";
        };

        "repository.pull-request" = {
          DEFAULT_MERGE_STYLE = "merge";
          CLOSE_KEYWORDS = "close,closes,closed,fix,fixes,fixed,resolve,resolves,resolved";
        };

        indexer = {
          REPO_INDEXER_ENABLED = true;
        };

        other = {
          SHOW_FOOTER_VERSION = true;
          SHOW_FOOTER_TEMPLATE_LOAD_TIME = true;
        };

        log = {
          LEVEL = "Info";
        };

        attachment = {
          ENABLED = true;
          MAX_SIZE = 2048;
          MAX_FILES = 10;
        };
      };

      dump = {
        enable = true;
        type = "tar.gz";
        interval = "daily";
        age = "14d";
      };
    };

    services.nginx = {
      virtualHosts = {
        "forgejo.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://127.0.0.1:3005";
          };
        };
      };
    };
  };
}
