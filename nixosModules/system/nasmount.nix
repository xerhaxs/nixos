{ config, lib, pkgs, ... }:

let
  truenas-options = [
    "x-systemd.automount,auto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s"
    "gid=500,file_mode=0777,dir_mode=0777"
    "vers=3.0,credentials=${config.sops.secrets."truenas-smb/user".path}"
  ];
  nas-options = [
    "x-systemd.automount,auto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s"
    "gid=501,file_mode=0777,dir_mode=0777"
    "vers=3.0,credentials=${config.sops.secrets."smb-share/user-jf".path}"
  ]
in


{
  options.nixos = {
    system.nasmount = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable mounting of nas drives.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.nasmount.enable {
    environment.systemPackages = with pkgs; [
      cifs-utils
      nfs-utils
      sshfs
    ];

    users.groups.truenas = {
      gid = 500;
    };

    user.groups.nas = {
      gid = 501;
    };

    #fileSystems."/mount/document" = {
    #  device = "10.75.0.20:/document";
    #  fsType = "nfs";
    #  options = truenas-options;
    #};
    fileSystems."/mount/truenas/music" = {
      device = "//10.75.0.20/music";
      fsType = "cifs";
      options = truenas-options;
    };
    fileSystems."/mount/truenas/photo" = {
      device = "//10.75.0.20/photo";
      fsType = "cifs";
      options = truenas-options;
    };
    fileSystems."/mount/truenas/video" = {
      device = "//10.75.0.20/video";
      fsType = "cifs";
      options = truenas-options;
    };
    fileSystems."/mount/truenas/jf" = {
      device = "//10.75.0.20/jf";
      fsType = "cifs";
      options = truenas-options;
    };
    fileSystems."/mount/truenas/document" = {
      device = "//10.75.0.20/document";
      fsType = "cifs";
      options = truenas-options;
    };
    fileSystems."/mount/truenas/backup" = {
      device = "//10.75.0.20/backup";
      fsType = "cifs";
      options = truenas-options;
    };
    fileSystems."/mount/truenas/games" = {
      device = "//10.75.0.20/games";
      fsType = "cifs";
      options = truenas-options;
    };

    fileSystems."/mount/nas/music" = {
      device = "//NixOS-Server1/music";
      fsType = "cifs";
      options = truenas-options;
    };
    fileSystems."/mount/nas/photo" = {
      device = "//NixOS-Server1/photo";
      fsType = "cifs";
      options = nas-options;
    };
    fileSystems."/mount/nas/video" = {
      device = "//NixOS-Server1/video";
      fsType = "cifs";
      options = nas-options;
    };
    fileSystems."/mount/nas/jf" = {
      device = "//NixOS-Server1/jf";
      fsType = "cifs";
      options = nas-options;
    };
    fileSystems."/mount/nas/document" = {
      device = "//NixOS-Server1/document";
      fsType = "cifs";
      options = nas-options;
    };
    fileSystems."/mount/nas/backup" = {
      device = "//NixOS-Server1/backup";
      fsType = "cifs";
      options = nas-options;
    };
    fileSystems."/mount/nas/games" = {
      device = "//NixOS-Server1/games";
      fsType = "cifs";
      options = nas-options;
    };

    fileSystems."/mount/sshfs/jf" = {
      device = "admin@NixOS-Server1:/srv/share/jf";
      fsType = "sshfs";
      options = [
        "nodev"
        "noatime"
        "allow_other"
        "IdentityFile=/root/.ssh/id_ed25519"
      ];
    };

    networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';

    users.users."${config.nixos.system.user.defaultuser.name}" = {
      extraGroups = [
        "truenas"
        "nas"
      ];
    };
  };
}
