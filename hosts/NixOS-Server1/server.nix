{ config, lib, pkgs, ... }:

{
  services.xserver.displayManager.startx.enable = true;

  #nixos.server.network.nginx.enable = true;

  #nixos.server.network.ddclient.enable = true;

  #nixos.server = {
  #  home = {
  #    radicale.enable = true;
  #    collabora.enable = true;
  #    firefoxsync.enable = true;
  #    jellyfin.enable = true;
  #    nextcloud.enable = true;
      #mailserver.enable = lib.mkForce false;
      #etesync.enable = lib.mkForce false;
      #haos.enable = lib.mkForce false;
      #homeassistant.enable = lib.mkForce false;
  #  };
    #network = {
    #  #adguard.enable = lib.mkForce false;
    #};
  #  fediverse = {
  #    freshrss.enable = true;
  #    gitea.enable = true;
  #    invidious.enable = true;
  #    lemmy.enable = true;
  #    libreddit.enable = true;
      #mastodon.enable = true;
  #    moneronode.enable = true;
  #    murmur.enable = true;
  #    nitter.enable = true;
  #    peertube.enable = true;
  #    pixelfed.enable = true;
  #    searxng.enable = true;
  #    teamspeak.enable = true;
  #  };
  #};
}