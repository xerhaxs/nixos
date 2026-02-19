{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.fediverse.nitter = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Nitter.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.nitter.enable {
    services.nitter = {
      enable = true;
      openFirewall = false;
      
      server = {
        hostname = "nitter.${config.nixos.server.network.nginx.domain}";
        address = "127.0.0.1";
        port = 8970;
        https = false;
      };

      preferences = {
        autoplayGifs = false;
        bidiSupport = true;
        hideBanner = false;
        hidePins = false;
        hideReplies = false;
        hideTweetStats = false;
        hlsPlayback = true;
        infiniteScroll = false;
        mp4Playback = true;
        muteVideos = true;
        replaceReddit = "libreddit.${config.nixos.server.network.nginx.domain}";
        replaceTwitter = "nitter.${config.nixos.server.network.nginx.domain}";
        #replaceYouTube = "invidious.${config.nixos.server.network.nginx.domain}";
        squareAvatars = false;
        stickyProfile = true;
        theme = "Nitter";
      };
    };

    services.nginx = {
      virtualHosts = {
        "nitter.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8970";
          };
        };
      };
    };
  };
}
