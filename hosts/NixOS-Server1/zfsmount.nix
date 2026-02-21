{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot.supportedFilesystems = [ "zfs" ];

  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "weekly";
    };
    autoSnapshot = {
      enable = false;
      frequent = 4;
      hourly = 24;
      daily = 7;
      weekly = 4;
      monthly = 12;
    };
    trim = {
      enable = true;
      interval = "weekly";
    };
  };

  fileSystems = {
    #"/pool01/applications" = {
    #  device = "pool01/applications";
    #  fsType = "zfs";
    #  options = [ "zfsutil" ];
    #  depends = [ "zfs-load-key.service" ];
    #};
    "/pool01/share" = {
      device = "pool01/share";
      fsType = "zfs";
      options = [ "zfsutil" ];
      depends = [ "zfs-load-key.service" ];
    };
    #"/pool01/share/jf" = {
    #  device = "pool01/share/jf";
    #  fsType = "zfs";
    #  options = [ "zfsutil" ];
    #  depends = [ "/pool01/share" ];
    #};
    "/pool01/share/music" = {
      device = "pool01/share/music";
      fsType = "zfs";
      options = [ "zfsutil" ];
      depends = [ "/pool01/share" ];
    };
    "/pool01/share/photo" = {
      device = "pool01/share/photo";
      fsType = "zfs";
      options = [ "zfsutil" ];
      depends = [ "/pool01/share" ];
    };
    "/pool01/share/video" = {
      device = "pool01/share/video";
      fsType = "zfs";
      options = [ "zfsutil" ];
      depends = [ "/pool01/share" ];
    };
  };

  systemd.services."zfs-load-key" = {
    description = "Load ZFS encryption key for pool01/share";
    before = [ "pool01-share.mount" ];
    after = [
      "zfs-import.target"
      "sops-nix.service"
    ];
    requires = [ "sops-nix.service" ];
    wantedBy = [ "zfs-mount.target" ];
    path = [ pkgs.zfs ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      cat ${config.sops.secrets."zfs/pool01".path} | \
      zfs load-key pool01/share
    '';
  };
}
