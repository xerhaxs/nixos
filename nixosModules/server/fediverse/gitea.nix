{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.fediverse.gitea = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Gitea.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.gitea.enable {
    environment.systemPackages = with pkgs; [
      gitea
    ];

    # setup admin account: "gitea admin user change-password -u <username> -p <password>"

    services.gitea = {
      enable = true;
      stateDir = "/var/lib/gitea";
      useWizard = false;

      database = {
        type = "sqlite3";
      };

      dump = {
        enable = true;
        type = "zip";
        interval = "hourly";
      };

      lfs.enable = true;

      settings = {
        session.COOKIE_SECURE = true;
        server = {
          PROTOCOL = "http";
          HTTP_PORT = 3005;
          HTTP_ADDR = "127.0.0.1";
          DOMAIN = "gitea.${config.nixos.server.network.nginx.domain}";

          DISABLE_SSH = false;
          SSH_PORT = 22;
          START_SSH_SERVER = false;

          LANDING_PAGE = "explore";
          LFS_START_SERVER = true;
        };

        session = {
          COOKIE_SECURE = true;
          COOKIE_NAME = "gitea_cookie";
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
          NO_REPLY_ADDRESS = "noreply@${config.nixos.server.fediverse.gitea.domain}";
        };

        security = {
          INSTALL_LOCK = true;
          SECRET_KEY_URI = "file:/var/lib/gitea/custom/secret_key";
          INTERNAL_TOKEN_URI = "file:/var/lib/gitea/custom/internal_token";
        };

        actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "https://github.com";
        };

        ui = {
          DEFAULT_THEME = "auto";
          THEMES = "auto,gitea,arc-green";
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
          ROOT_PATH = "/var/lib/gitea/log";
        };

        attachment = {
          ENABLED = true;
          MAX_SIZE = 50;
          MAX_FILES = 10;
        };
      };
    };

    services.nginx = {
      virtualHosts = {
        "gitea.${config.nixos.server.network.nginx.domain}" = {
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
