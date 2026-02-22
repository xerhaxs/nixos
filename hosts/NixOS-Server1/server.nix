{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.getty.autologinUser = null;

  nixos.server.network.nginx.enable = true;

  nixos.virtualisation.podman.enable = true;

  nixos.server.fileshare.share.path = "/pool01/shares";

  systemd.services.jellyfin = {
    after = [ "zfs-mount.service" ];
    requires = [ "zfs-mount.service" ];
  };

  systemd.services.home-assistant = {
    after = [ "zfs-mount.service" ];
    requires = [ "zfs-mount.service" ];
  };

  systemd.services.ollama = {
    after = [ "zfs-mount.service" ];
    requires = [ "zfs-mount.service" ];
  };

  systemd.services.radicale = {
    after = [ "zfs-mount.service" ];
    requires = [ "zfs-mount.service" ];
  };

  systemd.services.webdav = {
    after = [ "zfs-mount.service" ];
    requires = [ "zfs-mount.service" ];
  };

  nixos.server = {
    fediverse = {
      #gitea.enable = true;
      invidious.enable = true;
      languagetool.enable = true;
      libreddit.enable = true;
      #matrix.ebale = true;
      nitter.enable = true;
      searxng.enable = true;
    };
    fileshare = {
      samba.enable = true;
      share.enable = true;
      #sshfs.enable = true;
      webdav.enable = true;
    };
    home = {
      glance.enable = true;
      homeassistant.enable = true;
      jellyfin.enable = true;
      networkingtoolbox.enable = true;
      ollama.enable = true;
      radicale.enable = true;
    };
    network = {
      pihole.enable = true;
      unbound.enable = true;
    };
  };
}
