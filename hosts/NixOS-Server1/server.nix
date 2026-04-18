{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  services.pihole-ftl = {
    package = inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.pihole-ftl;
    piholePackage = inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.pihole;
  };

  services.pihole-web = {
    package = inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.pihole-web;
  };

  services.getty.autologinUser = null;

  nixos.virtualisation.podman.enable = true;

  nixos.server.fileshare.share.path = "/pool01/shares";

  nixos.server = {
    fediverse = {
      forgejo.enable = true;
      invidious.enable = true;
      kiwix.enable = true;
      languagetool.enable = true;
      libreddit.enable = true;
      libretranslate.enable = true;
      linkwarden.enable = true;
      #matrix.ebale = true;
      searxng.enable = true;
    };
    fileshare = {
      samba.enable = true;
      share.enable = true;
      #sshfs.enable = true;
      webdav.enable = true;
    };
    home = {
      cockpit.enable = true;
      #cryptpad.enable = true;
      glance.enable = true;
      homeassistant.enable = true;
      jellyfin.enable = true;
      networkingtoolbox.enable = true;
      ollama.enable = true;
      radicale.enable = true;
      #stalwart.enable = true;
    };
    network = {
      mullvad-server.enable = true;
      nginx.enable = true;
      pihole.enable = true;
      unbound.enable = true;
    };
    usenet = {
      lidarr.enable = true;
      nzbhydra2.enable = true;
      radarr.enable = true;
      readarr.enable = true;
      sabnzbd.enable = true;
      sonarr.enable = true;
    };
  };
}
