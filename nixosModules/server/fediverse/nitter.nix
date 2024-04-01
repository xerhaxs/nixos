  { config, pkgs, ... }:

{
  services.nitter = {
    enable = true;
    openFirewall = false;
    
    server = {
      hostname = "nitter.bitsync.icu";
      address = "127.0.0.1";
      port = 8970;
      https = true;
    };

    #preferences = {
    #  autoplayGifs = false;
    #  bidiSupport = true;
    #  hideBanner = false;
    #  hlsPlayback = true;
    #  muteVideos = true;
    #  replaceReddit = "libreddit.bitsync.icu";
    #  replaceTwitter = "nitter.bitsync.icu";
    #  replaceYouTube = "invidious.bitsync.icu";
    #};
  };
}
