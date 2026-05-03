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
  system.activationScripts.zfs-cache-key = {
    text = ''
      cp /run/secrets/zfs/pool01 /secrets/zfs-cache.key
      chmod 0400 /secrets/zfs-cache.key
    '';
  };

  environment.etc."crypttab".text = ''
    zfs-cache /dev/nvme0n1p1 /secrets/zfs-cache.key luks
  '';

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
    restartIfChanged = false;

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

      zfs mount pool01/applications 2>/dev/null || true
      zfs mount -R pool01/shares 2>/dev/null || true
      zfs mount -R pool01/shares/jf 2>/dev/null || true
    '';
  };

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

  environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
    directories = [
      "/etc/zfs"
    ];
  };
}
