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
    after = [ "zfs-load-keys.service" ];
    requires = [ "zfs-load-keys.service" ];
    serviceConfig.ExecStartPre = "${pkgs.bash}/bin/bash -c 'for mp in /pool01/applications /pool01/shares; do until mountpoint -q $mp; do sleep 1; done; done'";
  };

  systemd.services.home-assistant = {
    after = [ "zfs-load-keys.service" ];
    requires = [ "zfs-load-keys.service" ];
    serviceConfig.ExecStartPre = "${pkgs.bash}/bin/bash -c 'for mp in /pool01/applications /pool01/shares; do until mountpoint -q $mp; do sleep 1; done; done'";
  };

  systemd.services.ollama = {
    after = [ "zfs-load-keys.service" ];
    requires = [ "zfs-load-keys.service" ];
    serviceConfig.ExecStartPre = "${pkgs.bash}/bin/bash -c 'for mp in /pool01/applications /pool01/shares; do until mountpoint -q $mp; do sleep 1; done; done'";
  };

  systemd.services.radicale = {
    after = [ "zfs-load-keys.service" ];
    requires = [ "zfs-load-keys.service" ];
    serviceConfig.ExecStartPre = "${pkgs.bash}/bin/bash -c 'for mp in /pool01/applications /pool01/shares; do until mountpoint -q $mp; do sleep 1; done; done'";
  };

  systemd.services.webdav = {
    after = [ "zfs-load-keys.service" ];
    requires = [ "zfs-load-keys.service" ];
    serviceConfig.ExecStartPre = "${pkgs.bash}/bin/bash -c 'for mp in /pool01/applications /pool01/shares; do until mountpoint -q $mp; do sleep 1; done; done'";
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
