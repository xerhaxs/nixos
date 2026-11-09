{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.nixos.system.restic;
  impermanence = config.nixos.disko.disko-luks-btrfs-tmpfs.enable;

  zfs = "${config.boot.zfs.package}/bin/zfs";
  btrfs = "${pkgs.btrfs-progs}/bin/btrfs";

  mode =
    if cfg.zfsDatasets != [ ] then
      "zfs"
    else if impermanence then
      "btrfs"
    else
      "paths";

  snapshotName = name: "restic-${name}";
  snapshotDir =
    name: subvolume:
    "/persistent/.snapshots/restic-${name}${lib.replaceStrings [ "/" ] [ "-" ] subvolume}";
  rcloneConfig = name: "/var/lib/restic-rclone/${name}.conf";

  prepareSnapshots =
    name:
    if mode == "zfs" then
      lib.concatMapStringsSep "\n" (dataset: ''
        ${zfs} destroy ${dataset}@${snapshotName name} 2>/dev/null || true
        ${zfs} snapshot ${dataset}@${snapshotName name}
      '') cfg.zfsDatasets
    else if mode == "btrfs" then
      "mkdir -p /persistent/.snapshots\n"
      + lib.concatMapStringsSep "\n" (subvolume: ''
        ${btrfs} subvolume delete ${snapshotDir name subvolume} 2>/dev/null || true
        ${btrfs} subvolume snapshot -r ${subvolume} ${snapshotDir name subvolume}
      '') cfg.subvolumes
    else
      "";

  cleanupSnapshots =
    name:
    if mode == "zfs" then
      lib.concatMapStringsSep "\n" (dataset: ''
        ${zfs} destroy ${dataset}@${snapshotName name} || true
      '') cfg.zfsDatasets
    else if mode == "btrfs" then
      lib.concatMapStringsSep "\n" (subvolume: ''
        ${btrfs} subvolume delete ${snapshotDir name subvolume} || true
      '') cfg.subvolumes
    else
      "";

  prepareRclone =
    name: repo:
    lib.optionalString (repo.rcloneConfigSecret != null) ''
      if [ ! -s ${rcloneConfig name} ]; then
        install -D -m 0600 ${repo.rcloneConfigSecret} ${rcloneConfig name}
      fi
    '';

  mkBackup = name: repo: {
    inherit (repo) repository passwordFile environmentFile;
    initialize = true;
    paths =
      if mode == "btrfs" then
        map (snapshotDir name) cfg.subvolumes
      else if mode == "paths" then
        cfg.paths
      else
        [ ];
    # With zfsSubdirs only the listed directories of the dataset are backed up.
    dynamicFilesFrom = lib.mkIf (mode == "zfs") (
      lib.concatMapStringsSep "\n" (
        dataset:
        let
          root = "$(${zfs} get -H -o value mountpoint ${dataset})/.zfs/snapshot/${snapshotName name}";
          subdirs = cfg.zfsSubdirs.${dataset} or [ ];
        in
        if subdirs == [ ] then
          "echo \"${root}\""
        else
          lib.concatMapStringsSep "\n" (dir: "echo \"${root}/\"${lib.escapeShellArg dir}") subdirs
      ) cfg.zfsDatasets
    );
    exclude = cfg.exclude;
    extraOptions =
      repo.extraOptions
      ++ lib.optional (repo.rcloneConfigSecret != null) "rclone.program=${pkgs.rclone}/bin/rclone";
    rcloneConfigFile = lib.mkIf (repo.rcloneConfigSecret != null) (rcloneConfig name);
    timerConfig = {
      OnCalendar = cfg.time;
      RandomizedDelaySec = "30m";
      Persistent = true;
    };
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 12"
    ];
    runCheck = true;
    checkOpts = [ "--read-data-subset=2%" ];

    backupPrepareCommand = prepareRclone name repo + prepareSnapshots name;
    backupCleanupCommand = cleanupSnapshots name;
  };

in

{
  options.nixos = {
    system.restic = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable restic backups.";
      };

      time = lib.mkOption {
        type = lib.types.str;
        default = "03:00";
        description = "systemd OnCalendar expression for the backups.";
      };

      zfsDatasets = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "pool01/applications" ];
        description = "ZFS datasets which are snapshotted and backed up (instead of the btrfs subvolumes or paths).";
      };

      zfsSubdirs = lib.mkOption {
        type = lib.types.attrsOf (lib.types.listOf lib.types.str);
        default = { };
        example = {
          "pool01/shares/jf" = [ "Dokumente" ];
        };
        description = "Only back up these directories of a dataset in zfsDatasets (relative to its mountpoint); datasets without entry are backed up completely.";
      };

      subvolumes = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "/persistent"
          "/persistent/home"
        ];
        description = "btrfs subvolumes which are snapshotted and backed up (impermanence hosts).";
      };

      paths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "/etc"
          "/home"
          "/srv"
          "/var/lib"
          "/var/backup"
        ];
        description = "Paths to back up on hosts without impermanence.";
      };

      exclude = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          ".snapshots"
          "**/.cache"
          "var/cache"
          "var/log"
          "**/.local/share/Trash"
          "var/lib/clamav"
          "var/lib/postgresql"
        ];
        description = "Exclude patterns.";
      };

      repositories = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              repository = lib.mkOption {
                type = lib.types.str;
                example = "rest:http://10.100.0.2:8000/myhost/";
                description = "restic repository URL.";
              };
              passwordFile = lib.mkOption {
                type = lib.types.str;
                description = "File with the repository password.";
              };
              environmentFile = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "Environment file (e.g. RESTIC_REST_USERNAME/RESTIC_REST_PASSWORD).";
              };
              rcloneConfigSecret = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "rclone config (secret) for rclone: repositories, copied once to a writable location.";
              };
              sizeLimit = lib.mkOption {
                type = lib.types.nullOr lib.types.int;
                default = null;
                example = 1900000000000;
                description = "Size limit in bytes: after every backup the oldest versions are forgotten (monthly, weekly, then daily) until the repository fits, the alert ResticRepositoryFull fires if it still does not.";
              };
              extraOptions = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                example = [ "sftp.command='ssh u123@u123.your-storagebox.de -p 23 -i /run/secrets/key -s sftp'" ];
                description = "Extra restic options (-o).";
              };
            };
          }
        );
        default = { };
        description = "Repositories every backup is written to.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.restic.backups = lib.mapAttrs mkBackup cfg.repositories;

    # Size of the repository for Prometheus (textfile collector), measured after each backup with the
    # wrapper restic-<name> that the restic module installs. Above sizeLimit the oldest versions are
    # forgotten step by step (monthly first, then weekly, then daily) until it fits, the latest stays.
    systemd.services = lib.mapAttrs' (
      name: repo:
      lib.nameValuePair "restic-size-${name}" {
        description = "Measure the restic repository ${name} and thin it out above its size limit";
        after = [ "restic-backups-${name}.service" ];
        wantedBy = [ "restic-backups-${name}.service" ];
        path = [ pkgs.jq ];
        serviceConfig = {
          Type = "oneshot";
          IOSchedulingClass = "idle";
        };
        script = ''
          restic=/run/current-system/sw/bin/restic-${name}
          limit=${toString repo.sizeLimit}
          size() { $restic stats --json --mode raw-data | jq .total_size; }
          current=$(size)
          for keep in \
            "--keep-daily 7 --keep-weekly 4 --keep-monthly 9" \
            "--keep-daily 7 --keep-weekly 4 --keep-monthly 6" \
            "--keep-daily 7 --keep-weekly 4 --keep-monthly 3" \
            "--keep-daily 7 --keep-weekly 4" \
            "--keep-daily 7 --keep-weekly 2" \
            "--keep-daily 7" \
            "--keep-daily 3" \
            "--keep-last 1"; do
            [ "$current" -le "$limit" ] && break
            echo "repository has $current bytes, limit $limit: forget $keep"
            # shellcheck disable=SC2086
            $restic forget $keep --prune
            current=$(size)
          done
          dir=/var/lib/prometheus-node-exporter
          mkdir -p $dir
          {
            echo "restic_repository_size_bytes{repository=\"${name}\"} $current"
            echo "restic_repository_size_limit_bytes{repository=\"${name}\"} $limit"
          } > $dir/restic-${name}.prom.tmp
          mv $dir/restic-${name}.prom.tmp $dir/restic-${name}.prom
        '';
      }
    ) (lib.filterAttrs (_: repo: repo.sizeLimit != null) cfg.repositories);

    services.postgresqlBackup = lib.mkIf config.services.postgresql.enable {
      enable = true;
      backupAll = true;
      compression = "zstd";
      location =
        if mode == "zfs" then
          "${config.nixos.server.dataDir}/backup/postgresql"
        else
          "/var/backup/postgresql";
      startAt = "02:30";
    };

    environment.persistence."/persistent" = lib.mkIf impermanence {
      directories = [
        "/var/backup"
        "/var/cache/restic-backups"
      ];
    };
  };
}
