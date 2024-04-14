{ config, lib, pkgs, ... }:

let
  synology-options = [
    "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s"
    "uid=1000,gid=100"
    "vers=3.0,credentials=${config.sops.secrets."synology-nas/user".path}"
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
    ];

    fileSystems."/run/media/${config.nixos.system.user.defaultuser.name}/music" = {
      device = "//10.75.0.20/music";
      fsType = "cifs";
      options = synology-options;
    };
    fileSystems."/run/media/${config.nixos.system.user.defaultuser.name}/photo" = {
      device = "//10.75.0.20/photo";
      fsType = "cifs";
      options = synology-options;
    };
    fileSystems."/run/media/${config.nixos.system.user.defaultuser.name}/video" = {
      device = "//10.75.0.20/video";
      fsType = "cifs";
      options = synology-options;
    };
    fileSystems."/run/media/${config.nixos.system.user.defaultuser.name}/usbshare1" = {
      device = "//10.75.0.20/usbshare1";
      fsType = "cifs";
      options = synology-options;
    };
    fileSystems."/run/media/${config.nixos.system.user.defaultuser.name}/Software_Treiber" = {
      device = "//10.75.0.20/Software_Treiber";
      fsType = "cifs";
      options = synology-options;
    };
    fileSystems."/run/media/${config.nixos.system.user.defaultuser.name}/backup" = {
      device = "//10.75.0.20/backup";
      fsType = "cifs";
      options = synology-options;
    };

    networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
  };
}
