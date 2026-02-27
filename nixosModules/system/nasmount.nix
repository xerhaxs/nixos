{
  config,
  lib,
  pkgs,
  ...
}:

let
  nas-options = [
    "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s"
    "gid=500,file_mode=0777,dir_mode=0777"
    "vers=3.1.1,credentials=${config.sops.secrets."nas-smb/user".path}"
    "noperm"
    "nounix"
    "serverino"
  ];
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

    users.groups.nas = {
      gid = 500;
    };

    fileSystems."/mount/nas/backup" = {
      device = "//NixOS-Server1/backup";
      fsType = "cifs";
      options = nas-options;
    };
    fileSystems."/mount/nas/document" = {
      device = "//NixOS-Server1/document";
      fsType = "cifs";
      options = nas-options;
    };
    fileSystems."/mount/nas/games" = {
      device = "//NixOS-Server1/games";
      fsType = "cifs";
      options = nas-options;
    };
    fileSystems."/mount/nas/jf" = {
      device = "//NixOS-Server1/jf";
      fsType = "cifs";
      options = nas-options;
    };
    fileSystems."/mount/nas/music" = {
      device = "//NixOS-Server1/music";
      fsType = "cifs";
      options = nas-options;
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

    #fileSystems."/mount/document" = {
    #  device = "10.75.0.20:/document";
    #  fsType = "nfs";
    #  options = truenas-options;
    #};

    #fileSystems."/mount/sshfs/jf" = {
    #  device = "admin@NixOS-Server1:/srv/share/jf";
    #  fsType = "sshfs";
    #  options = [
    #    "nodev"
    #    "noatime"
    #    "allow_other"
    #    "IdentityFile=/root/.ssh/id_ed25519"
    #  ];
    #};

    networking.firewall.extraCommands = "iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns";

    users.users."${config.nixos.system.user.defaultuser.name}" = {
      extraGroups = [
        "nas"
      ];
    };
  };
}
