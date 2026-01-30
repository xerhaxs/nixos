{ config, pkgs, ... }:

{
  # ZFS-Module aktivieren
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelPackages = config.boot.zfs.package.latestCompatible;
  boot.zfs.extraPools = [ "pool01" ];

  # ZFS-Tools und Dienste
  services.zfs = {
    enable = true;
    autoScrub.enable = true;
    autoSnapshot = {
      enable = true;
      frequent = 4;
      hourly = 24;
      daily = 7;
      weekly = 4;
      monthly = 12;
    };
  };

  # Mountpoints für Datasets definieren
  systemd.mounts = [
    # Unverschlüsseltes Dataset (pool01)
    {
      what = "pool01";
      where = "/mnt/pool01";
      type = "zfs";
      options = "defaults,zfsutil,noatime";
      neededForBoot = false;
    }
    # Verschlüsseltes Dataset (shares)
    {
      what = "pool01/shares";
      where = "/mnt/pool01/shares";
      type = "zfs";
      options = "defaults,zfsutil,noatime,x-systemd.requires=zfs-load-key@pool01/shares.service";
      neededForBoot = false;
    }
    # Untergeordnete Datasets von shares (automatisch eingebunden, da "by parent")
    # Beispiel für ein explizites Dataset (falls nötig)
    {
      what = "pool01/shares/backup";
      where = "/mnt/pool01/shares/backup";
      type = "zfs";
      options = "defaults,zfsutil,noatime,x-systemd.requires=zfs-load-key@pool01/shares.service";
      neededForBoot = false;
    }
    # Gesondert verschlüsseltes Dataset (jf)
    {
      what = "pool01/jf";
      where = "/mnt/pool01/jf";
      type = "zfs";
      options = "defaults,zfsutil,noatime,x-systemd.requires=zfs-load-key@pool01/jf.service";
      neededForBoot = false;
    }
  ];

  # Systemd-Service zum Laden der Verschlüsselungsschlüssel
  systemd.services.zfs-load-key = {
    description = "Load ZFS encryption keys";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.zfs}/bin/zfs load-key pool01/shares
        ${pkgs.zfs}/bin/zfs load-key pool01/jf
      '';
      RemainAfterExit = true;
    };
  };
}
