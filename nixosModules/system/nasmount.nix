{ config, lib, pkgs, ... }:

let
  synology-options = [
    "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s"
    "uid=1000,gid=100"
    "vers=3.0,credentials=${config.sops.secrets."synologynas-smb/user".path}"
  ];

  truenas-options = [
    "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s"
    "uid=1000,gid=100"
    "vers=3.0,credentials=${config.sops.secrets."truenas-smb/user".path}"
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
      nfs-utils
      cifs-utils
    ];

    #fileSystems."/run/media/${config.nixos.system.user.defaultuser.name}/document" = {
    #  device = "10.75.0.186:/document";
    #  fsType = "nfs";
    #  options = truenas-options;
    #};
    fileSystems."/run/media/${config.nixos.system.user.defaultuser.name}/truenas/music" = {
      device = "//10.75.0.186/music";
      fsType = "cifs";
      options = truenas-options;
    };
    fileSystems."/run/media/${config.nixos.system.user.defaultuser.name}/truenas/photo" = {
      device = "//10.75.0.186/photo";
      fsType = "cifs";
      options = truenas-options;
    };
    fileSystems."/run/media/${config.nixos.system.user.defaultuser.name}/truenas/video" = {
      device = "//10.75.0.186/video";
      fsType = "cifs";
      options = truenas-options;
    };
    fileSystems."/run/media/${config.nixos.system.user.defaultuser.name}/truenas/jf" = {
      device = "//10.75.0.186/jf";
      fsType = "cifs";
      options = truenas-options;
    };
    fileSystems."/run/media/${config.nixos.system.user.defaultuser.name}/truenas/document" = {
      device = "//10.75.0.186/document";
      fsType = "cifs";
      options = truenas-options;
    };
    fileSystems."/run/media/${config.nixos.system.user.defaultuser.name}/truenas/backup" = {
      device = "//10.75.0.186/backup";
      fsType = "cifs";
      options = truenas-options;
    };

    fileSystems."/run/media/${config.nixos.system.user.defaultuser.name}/synology/music" = {
      device = "//10.75.0.20/music";
      fsType = "cifs";
      options = synology-options;
    };
    fileSystems."/run/media/${config.nixos.system.user.defaultuser.name}/synology/photo" = {
      device = "//10.75.0.20/photo";
      fsType = "cifs";
      options = synology-options;
    };
    fileSystems."/run/media/${config.nixos.system.user.defaultuser.name}/synology/video" = {
      device = "//10.75.0.20/video";
      fsType = "cifs";
      options = synology-options;
    };
    fileSystems."/run/media/${config.nixos.system.user.defaultuser.name}/synology/usbshare1" = {
      device = "//10.75.0.20/usbshare1";
      fsType = "cifs";
      options = synology-options;
    };
    fileSystems."/run/media/${config.nixos.system.user.defaultuser.name}/synology/Software_Treiber" = {
      device = "//10.75.0.20/Software_Treiber";
      fsType = "cifs";
      options = synology-options;
    };
    fileSystems."/run/media/${config.nixos.system.user.defaultuser.name}/synology/backup" = {
      device = "//10.75.0.20/backup";
      fsType = "cifs";
      options = synology-options;
    };

    networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
  };
}
