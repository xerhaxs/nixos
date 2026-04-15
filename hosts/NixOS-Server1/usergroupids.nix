{
  config,
  lib,
  pkgs,
  ...
}:

{
  users.groups = {
    api.gid = 998;
    forgejo.gid = 976;
    hass.gid = 286;
    jellyfin.gid = 996;
    kiwix.gid = 543;
    lidarr.gid = 306;
    linkwarden.gid = 970;
    nzbhydra2.gid = 994;
    ollama.gid = 993;
    postgres.gid = 71;
    radarr.gid = 275;
    radicale.gid = 990;
    readarr.gid = 989;
    sabnzbd.gid = 986;
    share.gid = 984;
    sonarr.gid = 274;
    syncthing.gid = 237;
    tmjf.gid = 980;
    webdav.gid = 322;
  };

  users.users = {
    admin = {
      uid = 1000;
      extraGroups = [ "share" ];
    };

    forgejo.uid = 979;

    hass.uid = 286;

    jellyfin = {
      uid = 996;
      extraGroups = [
        "share"
        "render"
        "video"
      ];
    };

    jf.uid = 995;

    kiwix = {
      uid = 543;
      group = "kiwix";
    };

    lidarr = {
      uid = 306;
      extraGroups = [ "share" ];
    };

    linkwarden.uid = 970;

    meli.uid = 994;

    nzbhydra2 = {
      uid = 991;
      extraGroups = [ "share" ];
    };

    ollama = {
      uid = 990;
      extraGroups = [
        "render"
        "video"
      ];
    };

    postgres.uid = 71;

    radarr = {
      uid = 275;
      extraGroups = [ "share" ];
    };

    radicale.uid = 989;

    readarr = {
      uid = 988;
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

    webdav.uid = 322;
  };
}