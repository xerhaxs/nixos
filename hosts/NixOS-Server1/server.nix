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

  nixos.server.network.nginx.enable = true;

  nixos.virtualisation.podman.enable = true;

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
      cryptpad.enable = true;
      glance.enable = true;
      homeassistant.enable = true;
      jellyfin.enable = true;
      networkingtoolbox.enable = true;
      ollama.enable = true;
      radicale.enable = true;
      stalwart.enable = true;
    };
    network = {
      mullvad-server.enable = true;
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

  nixos.server.fileshare.share.path = "/pool01/shares";

  systemd.services.forgejo = {
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

  systemd.services.linkwarden = {
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
    kiwix.gid = 543;
    ollama.gid = 993;
    nzbhydra2.gid = 994;
    readarr.gid = 989;
    radicale.gid = 990;
    sabnzbd.gid = 986;
    share.gid = 984;
    tmjf.gid = 980;
    api.gid = 998;
    webdav.gid = 322;
    lidarr.gid = 306;
    syncthing.gid = 237;
    sonarr.gid = 274;
    radarr.gid = 275;
    hass.gid = 286;
    forgejo.gid = 976;
  };

  users.users = {
    meli = {
      uid = 994;
    };

    jf = {
      uid = 995;
    };

    admin = {
      uid = 1000;
      extraGroups = [ "share" ];
    };

    jellyfin = {
      uid = 996;
      extraGroups = [
        "share"
        "render"
        "video"
      ];
    };

    kiwix = {
      uid = 543;
      group = "kiwix";
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

    forgejo = {
      uid = 979;
    };
  };
}
