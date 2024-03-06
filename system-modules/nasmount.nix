{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

  fileSystems."/run/media/jf/music" = {
      device = "//10.75.0.20/music";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,uid=1000,gid=100";
        credentials = config.sops.secrets."synology-nas/user".path;
      in ["${automount_opts},${credentials}"];
  };
    fileSystems."/run/media/jf/photo" = {
      device = "//10.75.0.20/photo";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=10s,uid=1000,gid=100";
        credentials = config.sops.secrets."synology-nas/user".path;
      in ["${automount_opts},${credentials}"];
  };
    fileSystems."/run/media/jf/video" = {
      device = "//10.75.0.20/video";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,uid=1000,gid=100";
        credentials = config.sops.secrets."synology-nas/user".path;
      in ["${automount_opts},${credentials}"];
  };
    fileSystems."/run/media/jf/usbshare1" = {
      device = "//10.75.0.20/usbshare1";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,uid=1000,gid=100";
        credentials = config.sops.secrets."synology-nas/user".path;
      in ["${automount_opts},${credentials}"];
  };
    fileSystems."/run/media/jf/Software_Treiber" = {
      device = "//10.75.0.20/Software_Treiber";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,uid=1000,gid=100";
        credentials = config.sops.secrets."synology-nas/user".path;

      in ["${automount_opts},${credentials}"];
  };
    fileSystems."/run/media/jf/backup" = {
      device = "//10.75.0.20/backup";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,uid=1000,gid=100";
        credentials = config.sops.secrets."synology-nas/user".path;
      in ["${automount_opts},${credentials}"];
  };

  networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
  
  services.gvfs.enable = true;
}
