{ config, lib, pkgs, ... }:

let
  truenas-options = [
    "x-systemd.automount,auto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s"
    "uid=1000,gid=500"
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

    users.groups.truenas = {
      gid = 500;
    };

    #fileSystems."/mount/document" = {
    #  device = "10.75.0.186:/document";
    #  fsType = "nfs";
    #  options = truenas-options;
    #};
    fileSystems."/mount/truenas/music" = {
      device = "//10.75.0.186/music";
      fsType = "cifs";
      options = truenas-options;
    };
    fileSystems."/mount/truenas/photo" = {
      device = "//10.75.0.186/photo";
      fsType = "cifs";
      options = truenas-options;
    };
    fileSystems."/mount/truenas/video" = {
      device = "//10.75.0.186/video";
      fsType = "cifs";
      options = truenas-options;
    };
    fileSystems."/mount/truenas/jf" = {
      device = "//10.75.0.186/jf";
      fsType = "cifs";
      options = truenas-options;
    };
    fileSystems."/mount/truenas/document" = {
      device = "//10.75.0.186/document";
      fsType = "cifs";
      options = truenas-options;
    };
    fileSystems."/mount/truenas/backup" = {
      device = "//10.75.0.186/backup";
      fsType = "cifs";
      options = truenas-options;
    };

    networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
  };
}
