{
  config,
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    backintime
    backintime-common
    (writeShellApplication {
      name = "backup-external";
      runtimeInputs = [
        backintime-common
        cryptsetup
        util-linux
      ];
      # usage: sudo backup-external [luks partition], progress: tail -f /root/.local/share/backintime/takesnapshot_.log
      text = ''
        device="''${1:-/dev/sdi1}"
        cryptsetup open "$device" WD2_10TB_BCK
        trap 'umount /mnt/WD2_10TB_BCK || true; cryptsetup close WD2_10TB_BCK' EXIT
        mkdir -p /mnt/WD2_10TB_BCK
        mount /dev/mapper/WD2_10TB_BCK /mnt/WD2_10TB_BCK
        backintime --config /etc/backintime/config backup
      '';
    })
  ];

  environment.etc."backintime/config".text = ''
    config.version=6
    global.use_flock=false

    profile1.name=Server-Backup
    profile1.snapshots.continue_on_errors=true
    profile1.snapshots.preserve_acl=true
    profile1.snapshots.preserve_xattr=true
    profile1.snapshots.mode=local
    profile1.snapshots.path=/mnt/WD2_10TB_BCK
    profile1.snapshots.path.host=NixOS-Server1
    profile1.snapshots.path.profile=1
    profile1.snapshots.path.user=root

    profile1.snapshots.include.1.type=0
    profile1.snapshots.include.1.value=/pool01/applications
    profile1.snapshots.include.2.type=0
    profile1.snapshots.include.2.value=/pool01/shares
    profile1.snapshots.include.size=2

    profile1.snapshots.exclude.1.value=/pool01/shares/video
    profile1.snapshots.exclude.1.type=0
    profile1.snapshots.exclude.2.value=.zfs
    profile1.snapshots.exclude.2.type=2
    profile1.snapshots.exclude.3.value=.Trash-1000
    profile1.snapshots.exclude.3.type=2
    profile1.snapshots.exclude.4.value=.recycle
    profile1.snapshots.exclude.4.type=2
    profile1.snapshots.exclude.5.value=/pool01/shares/*/FreeTube/Cache
    profile1.snapshots.exclude.5.type=0
    profile1.snapshots.exclude.size=5

    # Old Windows streams that Samba stored as xattrs, up to 2 MB each. ext4 cannot hold them, rsync
    # then reports code 23 and skips deleting removed files in the snapshot.
    profile1.snapshots.rsync_options.enabled=true
    profile1.snapshots.rsync_options.value=--filter='-x user.DosStream.*'

    profile1.snapshots.remove_old_snapshots.enabled=false
    profile1.snapshots.smart_remove=false
    profile1.snapshots.min_free_space.enabled=true
    profile1.snapshots.min_free_space.value=10
    profile1.snapshots.min_free_space.unit=20
    profile1.snapshots.min_free_inodes.enabled=true
    profile1.snapshots.min_free_inodes.value=2
    profile1.snapshots.dont_remove_named_snapshots=true

    profile1.snapshots.schedule.mode=0
    profile1.snapshots.log_level=3
    profile1.snapshots.no_on_battery=false
    profile1.snapshots.notify.enabled=false
    profile1.snapshots.bwlimit.enabled=false
    profile1.snapshots.copy_links=false
    profile1.snapshots.one_file_system=false

    profiles=1
    profiles.version=1
  '';

  environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
    directories = [
      "/root/.local/share/backintime"
    ];
  };
}
