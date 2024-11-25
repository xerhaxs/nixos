{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.fediverse.invidious = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Invidious.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.invidious.enable {
    services.invidious = {
      enable = true;
      port = 3000;
  #    external_port = 443;
  #    host_binding = "127.0.0.1";
  #    nginx.enable = true;
      domain = "invidious.${config.nixos.server.network.nginx.domain}";
      settings = {
        https_only = true;
        hsts = true;
        popular_enabled = true;
        statistics_enabled = true;
        registration_enabled = false;
        login_enabled = false;
        captcha_enabled = false;
        enable_user_notifications = false;
        channel_threads = 2;
        full_refresh = false;
        cache_annotations = true;
        playlist_length_limit = 500;
        default_user_preferences = {
          locale = "en-US";
          region = "DE";
          captions = [
            "German"
            "English"
            "English (auto-generated)"
          ];
          dark_mode = "dark";
          thin_mode = false;
          feed_menu = [
            "Popular"
            "Trending"
            "Subscriptions"
            "Playlists"
          ];
          default_home = "Popular";
          max_results = 60;
          annotations = false;
          annotations_subscribed = false;
          comments = [
            "youtube"
            "reddit"
          ];
          player_style = "invidious";
          related_videos = true;
          autoplay = false;
          continue = false;
          continue_autoplay = true;
          listen = false;
          video_loop = false;
          quality = "dash";
          quality_dash = "best";
          speed = 1.25;
          volume = 100;
          vr_mode = true;
          save_player_pos = true;
          latest_only = false;
          notifications_only = false;
          unseen_only = false;
          sort = "published";
        };
      };
    };

    services.nginx = {
      virtualHosts = {
        "invidious.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:3000";
          };
        };
      };
    };

    services.ddclient.domains = [
      "invidious.${config.nixos.server.network.nginx.domain}"
    ];
  };
}
