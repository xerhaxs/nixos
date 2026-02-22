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
    serviceConfig.ExecStartPre = "/bin/sleep 60";
  };

  systemd.services.home-assistant = {
    after = [ "zfs-load-keys.service" ];
    requires = [ "zfs-load-keys.service" ];
    serviceConfig.ExecStartPre = "/bin/sleep 60";
  };

  systemd.services.ollama = {
    after = [ "zfs-load-keys.service" ];
    requires = [ "zfs-load-keys.service" ];
    serviceConfig.ExecStartPre = "/bin/sleep 60";
  };

  systemd.services.radicale = {
    after = [ "zfs-load-keys.service" ];
    requires = [ "zfs-load-keys.service" ];
    serviceConfig.ExecStartPre = "/bin/sleep 60";
  };

  systemd.services.webdav = {
    after = [ "zfs-load-keys.service" ];
    requires = [ "zfs-load-keys.service" ];
    serviceConfig.ExecStartPre = "/bin/sleep 60";
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
