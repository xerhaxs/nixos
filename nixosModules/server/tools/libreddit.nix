{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.tools.libreddit = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Libreddit.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.tools.libreddit.enable {
    services.redlib = {
      enable = true;
      address = "127.0.0.1";
      port = 8975;
      openFirewall = false;

      settings = {
        SFW_ONLY = "off";
        ROBOTS_DISABLE_INDEXING = "on";
        ENABLE_RSS = "on";
        THEME = "system";
        FRONT_PAGE = "default";
        LAYOUT = "card";
        WIDE = "on";
        POST_SORT = "hot";
        COMMENT_SORT = "confidence";
        BLUR_SPOILER = "off";
        SHOW_NSFW = "on";
        BLUR_NSFW = "off";
        USE_HLS = "on";
        HIDE_HLS_NOTIFICATION = "off";
        AUTOPLAY_VIDEOS = "off";
        HIDE_AWARDS = "off";
        DISABLE_VISIT_REDDIT_CONFIRMATION = "off";
        HIDE_SCORE = "off";
        HIDE_SIDEBAR_AND_SUMMARY = "off";
        FIXED_NAVBAR = "on";
        REMOVE_DEFAULT_FEEDS = "off";
      };
    };

    # Redlib exits when it cannot reach Reddit at start (e.g. while Mullvad connects after a boot).
    systemd.services.redlib = {
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      unitConfig.StartLimitIntervalSec = 0;
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 30;
      };
    };

    services.nginx = {
      virtualHosts = {
        "libreddit.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:8975";
          };
        };
      };
    };
  };
}
