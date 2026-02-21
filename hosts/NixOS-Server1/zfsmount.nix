{
  config,
  lib,
  pkgs,
  ...
}:

{
  # ZFS aktivieren
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.enable = true;

  # Optional aber empfohlen
  services.zfs.trim.enable = true;
  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;

  # Keyfile für Auto-Unlock
  # gespeichert unter /etc/zfs/keys/pool01-share.key
  environment.etc."zfs/keys/pool01-share.key".source = /persist/keys/pool01-share.key; # Pfad anpassen

  # Rechte sichern
  systemd.tmpfiles.rules = [
    "d /etc/zfs 0750 root root -"
    "d /etc/zfs/keys 0700 root root -"
  ];

  # ZFS Pool / Datasets deklarativ importieren und automatisch mounten
  fileSystems."/pool01/share" = {
    device = "pool01/share";
    fsType = "zfs";
  };

  # ZFS spezifische Settings
  boot.zfs.extraPools = [ "pool01" ];

  # Auto-Unlock durch Keyfile
  # dataset wird beim Booten über die Keyfile entschlüsselt
  boot.zfs.forceImportRoot = false;

  # systemd service zum Unlock
  systemd.services."zfs-load-key-pool01-share" = {
    description = "Load ZFS key for pool01/share";
    wantedBy = [ "zfs-mount.service" ];
    before = [ "zfs-mount.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        /run/current-system/sw/bin/zfs load-key -L file:///etc/zfs/keys/pool01-share.key pool01/share
      '';
    };
  };
  # ZFS Keys laden vor dem Mounten
  systemd.services.zfs-load-key-share = {
    description = "Load ZFS encryption key for pool01/share";
    before = [ "pool01-share.mount" ];
    after = [
      "zfs-import.target"
      "sops-nix.service"
    ];
    requires = [ "sops-nix.service" ];
    wantedBy = [ "zfs-mount.service" ];
    path = [ pkgs.zfs ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      cat ${config.sops.secrets."zfs/share-password".path} | \
      ${pkgs.zfs}/bin/zfs load-key pool01/share || true
    '';
  };
  systemd.services.zfs-load-key-applications = {
    description = "Load ZFS encryption key for pool01/applications";
    before = [ "pool01-applications.mount" ];
    after = [
      "zfs-import.target"
      "sops-nix.service"
    ];
    requires = [ "sops-nix.service" ];
    wantedBy = [ "zfs-mount.service" ];
    path = [ pkgs.zfs ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      cat ${config.sops.secrets."zfs/applications-password".path} | \
      ${pkgs.zfs}/bin/zfs load-key pool01/applications || true
    '';
  };
}
