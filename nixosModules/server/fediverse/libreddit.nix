{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.fediverse.libreddit = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Libreddit.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.libreddit.enable {
    services.redlib = {
      enable = true;
      address = "127.0.0.1";
      port = 8975;
      openFirewall = false;
      
      settings = {
        SFW_ONLY = "off"; # ["on", "off"]
        ROBOTS_DISABLE_INDEXING = "on"; # ["on", "off"]
        ENABLE_RSS = "on"; # ["on", "off"]
        THEME = "system"; # ["system", "light", "dark", "black", "dracula", "nord", "laserwave", "violet", "gold", "rosebox", "gruvboxdark", "gruvboxlight", "tokyoNight", "icebergDark", "doomone", "libredditBlack", "libredditDark", "libredditLight"]
        FRONT_PAGE = "default"; # ["default", "popular", "all"]
        LAYOUT = "card"; # ["card", "clean", "compact"]
        WIDE = "on"; # ["on", "off"]
        POST_SORT = "hot"; # ["hot", "new", "top", "rising", "controversial"]
        COMMENT_SORT = "confidence"; # ["confidence", "top", "new", "controversial", "old"]
        BLUR_SPOILER = "off"; # ["on", "off"]
        SHOW_NSFW = "on"; # ["on", "off"]
        BLUR_NSFW = "off"; # ["on", "off"]
        USE_HLS = "on"; # ["on", "off"]
        HIDE_HLS_NOTIFICATION = "off"; # ["on", "off"]
        AUTOPLAY_VIDEOS = "off"; # ["on", "off"]
        HIDE_AWARDS = "off"; # ["on", "off"]
        DISABLE_VISIT_REDDIT_CONFIRMATION = "off"; # ["on", "off"]
        HIDE_SCORE = "off"; # ["on", "off"]
        HIDE_SIDEBAR_AND_SUMMARY = "off"; # ["on", "off"]
        FIXED_NAVBAR = "on"; # ["on", "off"]
        REMOVE_DEFAULT_FEEDS = "off"; # ["on", "off"]
      };
    };

    services.nginx = {
      virtualHosts = {
        "libreddit.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8975";
          };
        };
      };
    };

    services.ddclient.domains = [
      "libreddit.${config.nixos.server.network.nginx.domain}"
    ];
  };
}
