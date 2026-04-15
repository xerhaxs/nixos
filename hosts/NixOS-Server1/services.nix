{
  config,
  lib,
  pkgs,
  ...
}:

{
  systemd.services.forgejo = {
    after = [ "zfs-mounts-ready.service" ];
    requires = [ "zfs-mounts-ready.service" ];
  };

  systemd.services.home-assistant = {
    after = [ "zfs-mounts-ready.service" ];
    requires = [ "zfs-mounts-ready.service" ];
  };

  systemd.services.jellyfin = {
    after = [ "zfs-mounts-ready.service" ];
    requires = [ "zfs-mounts-ready.service" ];
  };

  systemd.services.kiwix-serve = {
    after = [ "zfs-mounts-ready.service" ];
    requires = [ "zfs-mounts-ready.service" ];
  };

  systemd.services.lidarr = {
    after = [ "zfs-mounts-ready.service" ];
    requires = [ "zfs-mounts-ready.service" ];
  };

  systemd.services.linkwarden = {
    after = [ "zfs-mounts-ready.service" ];
    requires = [ "zfs-mounts-ready.service" ];
  };

  systemd.services.nzbhydra2 = {
    after = [ "zfs-mounts-ready.service" ];
    requires = [ "zfs-mounts-ready.service" ];
  };

  systemd.services.ollama = {
    after = [ "zfs-mounts-ready.service" ];
    requires = [ "zfs-mounts-ready.service" ];
  };

  systemd.services.postgresql = {
    after = [ "zfs-mounts-ready.service" ];
    requires = [ "zfs-mounts-ready.service" ];
  };

  systemd.services.radicale = {
    after = [ "zfs-mounts-ready.service" ];
    requires = [ "zfs-mounts-ready.service" ];
  };

  systemd.services.radarr = {
    after = [ "zfs-mounts-ready.service" ];
    requires = [ "zfs-mounts-ready.service" ];
  };

  systemd.services.readarr = {
    after = [ "zfs-mounts-ready.service" ];
    requires = [ "zfs-mounts-ready.service" ];
  };

  systemd.services.sabnzbd = {
    after = [ "zfs-mounts-ready.service" ];
    requires = [ "zfs-mounts-ready.service" ];
  };

  systemd.services.sonarr = {
    after = [ "zfs-mounts-ready.service" ];
    requires = [ "zfs-mounts-ready.service" ];
  };

  systemd.services.syncthing = {
    after = [ "zfs-mounts-ready.service" ];
    requires = [ "zfs-mounts-ready.service" ];
  };

  systemd.services.webdav = {
    after = [ "zfs-mounts-ready.service" ];
    requires = [ "zfs-mounts-ready.service" ];
  };
}