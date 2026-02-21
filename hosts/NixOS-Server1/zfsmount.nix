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

  networking.hostId = "d7b23b42";

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
