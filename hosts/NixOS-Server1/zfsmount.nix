{
  config,
  lib,
  pkgs,
  ...
}:
let
  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in
{
  boot.kernelPackages = lib.mkForce latestKernelPackage;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.requestEncryptionCredentials = false;
  boot.zfs.forceImportRoot = false;
  boot.zfs.forceImportAll = false;

  environment.systemPackages = with pkgs; [
    zfs
  ];

  networking.hostId = "d7b23b42";

  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "weekly";
    };
    /*
      autoSnapshot = {
        enable = false;
        frequent = 4;
        hourly = 24;
        daily = 7;
        weekly = 4;
        monthly = 12;
      };
    */
    trim = {
      enable = true;
      interval = "weekly";
    };
  };

  systemd.services.zfs-load-keys = {
    description = "Load ZFS encryption keys from SOPS";
    after = [ "zfs-import.target" ];
    before = [ "zfs-mount.target" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.zfs ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      if ! zpool list pool01 > /dev/null 2>&1; then
        if [ -f /etc/zfs/zpool.cache ]; then
          zpool import -c /etc/zfs/zpool.cache pool01
        else
          zpool import -d /dev/disk/by-id pool01
        fi
      fi

      for dataset in pool01/applications pool01/shares pool01/shares/jf; do
        if [ "$(zfs get -H -o value keystatus $dataset)" = "unavailable" ]; then
          zfs load-key $dataset < ${config.sops.secrets."zfs/pool01".path}
        fi
      done

      zfs mount pool01/applications
      zfs mount -R pool01/shares
      zfs mount -R pool01/shares/jf
    '';
  };
}
