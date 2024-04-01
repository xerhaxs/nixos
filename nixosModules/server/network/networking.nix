{ config, lib, pkgs, ... }:

{
  networking = {
    hosts = {
      "127.0.0.1" = lib.mkDefault [
        "adguard.bitsync.icu"
        "dav.bitsync.icu"
        "etesync.bitsync.icu"
        "firefoxsync.bitsync.icu"
        "freshrss.bitsync.icu"
        "gitea.bitsync.icu"
        "homeassistant.bitsync.icu"
        "invidious.bitsync.icu"
        "jellyfin.bitsync.icu"
        "libreddit.bitsync.icu"
        "lidarr.bitsync.icu"
        "monero.bitsync.icu"
        "nextcloud.bitsync.icu"
        "nitter.bitsync.icu"
        "nzbget.bitsync.icu"
        "nzbhydra2.bitsync.icu"
        "onlyoffice.bitsync.icu"
        "pufferpanel-sftp.bitsync.icu"
        "pufferpanel.bitsync.icu"
        "radarr.bitsync.icu"
        "radicale.bitsync.icu"
        "readarr.bitsync.icu"
        "searxng.bitsync.icu"
        "sonarr.bitsync.icu"
        "uptime-kuma.bitsync.icu"
        "vaultwarden.bitsync.icu"
      ];
    };
  };
}
