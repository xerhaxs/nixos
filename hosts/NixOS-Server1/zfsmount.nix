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

  fileSystems = {
    "/pool01/applications" = {
      device = "pool01/applications";
      fsType = "zfs";
      options = [ "zfsutil" ];
      depends = [ "zfs-load-key.service" ];
    };
    "/pool01/shares" = {
      device = "pool01/shares";
      fsType = "zfs";
      options = [ "zfsutil" ];
      depends = [ "zfs-load-key.service" ];
    };
    "/pool01/shares/backup" = {
      device = "pool01/shares/backup";
      fsType = "zfs";
      options = [ "zfsutil" ];
      depends = [ "/pool01/shares" ];
    };
    "/pool01/shares/document" = {
      device = "pool01/shares/document";
      fsType = "zfs";
      options = [ "zfsutil" ];
      depends = [ "/pool01/shares" ];
    };
    "/pool01/shares/games" = {
      device = "pool01/shares/games";
      fsType = "zfs";
      options = [ "zfsutil" ];
      depends = [ "/pool01/shares" ];
    };
    "/pool01/shares/jf" = {
      device = "pool01/shares/jf";
      fsType = "zfs";
      options = [ "zfsutil" ];
      depends = [ "/pool01/shares" ];
    };
    "/pool01/shares/meli" = {
      device = "pool01/shares/meli";
      fsType = "zfs";
      options = [ "zfsutil" ];
      depends = [ "/pool01/shares" ];
    };
    "/pool01/shares/music" = {
      device = "pool01/shares/music";
      fsType = "zfs";
      options = [ "zfsutil" ];
      depends = [ "/pool01/shares" ];
    };
    "/pool01/shares/photo" = {
      device = "pool01/shares/photo";
      fsType = "zfs";
      options = [ "zfsutil" ];
      depends = [ "/pool01/shares" ];
    };
    "/pool01/shares/video" = {
      device = "pool01/shares/video";
      fsType = "zfs";
      options = [ "zfsutil" ];
      depends = [ "/pool01/shares" ];
    };
  };

  systemd.services."zfs-load-key" = {
    description = "Load ZFS encryption key for pool01";
    after = [
      "zfs-import.target"
      "sops-nix.service"
    ];
    wants = [ "sops-nix.service" ];
    path = [ pkgs.zfs ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    enable = true;
    # script zum Laden des Keys aus SOPS:
    script = ''
      cat ${config.sops.secrets."zfs/pool01".path} | zfs load-key pool01
    '';
  };
}
