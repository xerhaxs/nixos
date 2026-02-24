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
    usenet = {
      lidarr.enable = true;
      nzbhydra2.enable = true;
      radarr.enable = true;
      readarr.enable = true;
      sabnzbd.enable = true;
      sonarr.enable = true;
    };
  };

  services.mullvad-vpn = {
    enable = true;
    enableExcludeWrapper = true;
  };
/* 
  systemd.services.mullvad-setup = {
    description = "Initial Mullvad configuration";
    after = [ "mullvad-daemon.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "mullvad-setup" ''
        ${pkgs.mullvad}/bin/mullvad lan set allow
        ${pkgs.mullvad}/bin/mullvad lockdown-mode set on
        ${pkgs.mullvad}/bin/mullvad auto-connect set on
        ${pkgs.mullvad}/bin/mullvad connect
      '';
    };
  }; */

  nixos.server.fileshare.share.path = "/pool01/shares";

  systemd.services.zfs-mounts-ready = {
    description = "Wait for ZFS mounts to be ready";
    after = [ "zfs-load-keys.service" ];
    requires = [ "zfs-load-keys.service" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.util-linux ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    restartIfChanged = false;
    script = ''
      until mountpoint -q /pool01/shares && mountpoint -q /pool01/applications; do
        sleep 1
      done
    '';
  };

  systemd.services.jellyfin = {
    after = [ "zfs-mounts-ready.service" ];
    requires = [ "zfs-mounts-ready.service" ];
  };

  systemd.services.radicale = {
    after = [ "zfs-mounts-ready.service" ];
    requires = [ "zfs-mounts-ready.service" ];
  };

  systemd.services.webdav = {
    after = [ "zfs-mounts-ready.service" ];
    requires = [ "zfs-mounts-ready.service" ];
  };

  systemd.services.home-assistant = {
    after = [ "zfs-mounts-ready.service" ];
    requires = [ "zfs-mounts-ready.service" ];
  };

  systemd.services.nzbhydra2 = {
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

  systemd.services.sonarr = {
    after = [ "zfs-mounts-ready.service" ];
    requires = [ "zfs-mounts-ready.service" ];
  };

  systemd.services.lidarr = {
    after = [ "zfs-mounts-ready.service" ];
    requires = [ "zfs-mounts-ready.service" ];
  };

  systemd.services.sabnzbd = {
    after = [ "zfs-mounts-ready.service" ];
    requires = [ "zfs-mounts-ready.service" ];
  };

  users.users.jellyfin.extraGroups = [
    "share"
    "render"
    "video"
  ];

  users.users.lidarr.extraGroups = [
    "share"
  ];

  users.users.radarr.extraGroups = [
    "share"
  ];

  users.users.readarr.extraGroups = [
    "share"
  ];

  users.users.sabnzbd.extraGroups = [
    "share"
  ];

  users.users.sonarr.extraGroups = [
    "share"
  ];

  users.users.nzbhydra2.extraGroups = [
    "share"
  ];
}
