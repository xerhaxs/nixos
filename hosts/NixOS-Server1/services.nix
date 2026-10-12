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

  systemd.services.matter-thread-dirs = {
    description = "Create Matter and Thread state directories on ZFS";
    after = [ "zfs-mounts-ready.service" ];
    requires = [ "zfs-mounts-ready.service" ];
    restartIfChanged = false;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      install -d -m 0700 -o matter-server -g matter-server /pool01/applications/matterjs
      install -d -m 0755 -o root -g otbr /pool01/applications/thread
    '';
  };

  systemd.mounts = [
    {
      what = "/pool01/applications/matterjs";
      where = "/var/lib/matterjs-server";
      type = "none";
      options = "bind";
      requires = [ "matter-thread-dirs.service" ];
      after = [ "matter-thread-dirs.service" ];
      unitConfig.DefaultDependencies = false;
    }
    {
      what = "/pool01/applications/thread";
      where = "/var/lib/thread";
      type = "none";
      options = "bind";
      requires = [ "matter-thread-dirs.service" ];
      after = [ "matter-thread-dirs.service" ];
      unitConfig.DefaultDependencies = false;
    }
  ];

  systemd.services.matterjs-server.unitConfig.RequiresMountsFor = "/var/lib/matterjs-server";
  systemd.services.otbr-agent.unitConfig.RequiresMountsFor = "/var/lib/thread";
}
