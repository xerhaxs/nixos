{
  config,
  lib,
  impermanence,
  pkgs,
  ...
}:

{
  environment.persistence."/persistent" = {
    enable = true;
    hideMounts = true;
    allowTrash = true;

    directories = [
      "/root/.cache"
      "/etc/mullvad-vpn"
      "/etc/nixos"
      "/etc/ssh"
      "/etc/zfs"
      "/var/log"
      "/var/lib/sbctl"
      "/var/lib/nixos"
      "/var/cache"
      "/var/db/sudo"
      "/var/lib/systemd/coredump"
      
      "/var/lib/NetworkManager"
      "/var/lib/bluetooth"
      "/var/lib/bluetooth"
      "/var/lib/sshguard"

      #"/etc/NetworkManager/system-connections"
      #{ directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
    ];
    #files = [
    #  "/etc/machine-id"
    #  { file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
    #];
    files = [
      "/root/.bash_history"
    ];
  };
}
