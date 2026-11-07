{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  services.getty.autologinUser = null;

  nixos.virtualisation.podman.enable = true;

  nixos.server.network.nginx.domain = config.nixos.site.homeDomain;

  nixos.server = {
    entertainment = {
      jellyfin.enable = true;
      lidarr.enable = true;
      nzbhydra2.enable = true;
      radarr.enable = true;
      readarr.enable = true;
      sabnzbd.enable = true;
      sonarr.enable = true;
    };
    fileshare = {
      samba.enable = true;
      share.enable = true;
      webdav.enable = true;
    };
    management = {
      cockpit.enable = true;
      glance.enable = true;
      homeassistant.enable = true;
      update-check.enable = true;
      homebox = {
        enable = true;
        allowRegistration = true;
      };
      monitoring.enable = true;
    };
    network = {
      mullvad-server.enable = true;
      nginx.enable = true;
      pihole.enable = true;
      unbound.enable = true;
    };
    public = {
      #cryptpad.enable = true;
      #matrix.enable = true;
      #stalwart.enable = true;
    };
    sync = {
      forgejo.enable = true;
      linkwarden.enable = true;
      radicale.enable = true;
    };
    tools = {
      comfyui.enable = true;
      invidious.enable = true;
      kiwix.enable = true;
      languagetool.enable = true;
      libreddit.enable = true;
      libretranslate.enable = true;
      moneronode.enable = true;
      networkingtoolbox.enable = true;
      ollama = {
        enable = true;
        gpu = "intel";
      };
      searxng.enable = true;
    };
  };
}
