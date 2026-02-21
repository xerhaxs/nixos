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
  boot.zfs.forceImportAll = true;

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

/*   systemd.services.zfs-load-keys = {
    description = "Load ZFS encryption keys from SOPS";
    after = [
      "zfs-import.target"
      "sops-nix.service"
    ];
    before = [ "zfs-mount.target" ];
    wantedBy = [ "zfs-mount.target" ];
    path = [ pkgs.zfs ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      zfs load-key pool01/applications < ${config.sops.secrets."zfs/pool01".path}
      zfs load-key pool01/shares < ${config.sops.secrets."zfs/pool01".path}
      zfs load-key pool01/shares/jf < ${config.sops.secrets."zfs/pool01".path}
    '';
  }; */
}
