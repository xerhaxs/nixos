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
      pihole.enable = false; # UNTIL A FIX IS OUT
      unbound.enable = false; # UNTIL A FIX IS OUT
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
    };
  */

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

  systemd.services.ollama = {
    after = [ "zfs-mounts-ready.service" ];
    requires = [ "zfs-mounts-ready.service" ];
  };

  systemd.services.syncthing = {
    after = [ "zfs-mounts-ready.service" ];
    requires = [ "zfs-mounts-ready.service" ];
  };

  users.groups = {
    jellyfin.gid = 996;
    ollama.gid = 993;
    nzbhydra2.gid = 994;
    readarr.gid = 989;
    radicale.gid = 990;
    sabnzbd.gid = 986;
    share.gid = 984;
    tmjf.gid = 980;
    webdav.gid = 322;
    lidarr.gid = 306;
    syncthing.gid = 237;
    sonarr.gid = 274;
    radarr.gid = 275;
    hass.gid = 286;
  };

  users.users = {
    meli = {
      uid = 994;
    };

    jf = {
      uid = 995;
    };

    jellyfin = {
      uid = 996;
      extraGroups = [
        "share"
        "render"
        "video"
      ];
    };

    haos = {
      uid = 997;
    };

    readarr = {
      uid = 988;
      extraGroups = [ "share" ];
    };

    radicale = {
      uid = 989;
    };

    ollama = {
      uid = 990;
      extraGroups = [
        "render"
        "video"
      ];
    };

    nzbhydra2 = {
      uid = 991;
      extraGroups = [ "share" ];
    };

    sabnzbd = {
      uid = 986;
      extraGroups = [ "share" ];
    };

    syncthing = {
      uid = 237;
      extraGroups = [ "share" ];
    };

    sonarr = {
      uid = 274;
      extraGroups = [ "share" ];
    };

    radarr = {
      uid = 275;
      extraGroups = [ "share" ];
    };

    hass = {
      uid = 286;
    };

    lidarr = {
      uid = 306;
      extraGroups = [ "share" ];
    };

    webdav = {
      uid = 322;
    };
  };
}
