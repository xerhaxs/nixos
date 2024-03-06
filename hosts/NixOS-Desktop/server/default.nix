{ config, pkgs, ... }:

{
  imports = [
    #./adguard.nix
    #./dnsmasq.nix
    #./etesync.nix
    ./firefoxsync.nix
    ./freshrss.nix
    ./gitea.nix
    #./homeassistant.nix
    ./invidious.nix
    ./jellyfin.nix
    ./libreddit.nix
    ./lidarr.nix
    #./mailserver.nix
    #./moneronode.nix
    #./nextcloud.nix
    ./nginx.nix
    ./nitter.nix
    ./nzbget.nix
    ./nzbhydra2.nix
    ./onlyoffice.nix
    ./pufferpanel.nix
    ./radarr.nix
    ./radicale.nix
    ./readarr.nix
    #./samba.nix
    ./searxng.nix
    ./sonarr.nix
    ./uptime-kuma.nix
    #./vaultwarden.nix
    ./webdav.nix
  ];
}
