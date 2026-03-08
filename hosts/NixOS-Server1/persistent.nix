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
      #"/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/cache"
      "/var/db/sudo"
      "/var/lib/systemd/coredump"

      "/var/lib/acme"
      #"/var/lib/hass"
      #"/var/lib/jellyfin"
      #"/var/lib/radicale"
      {
        directory = "/var/lib/private/ollama";
        mode = "0700";
      }
      "/var/lib/pihole"
      "/var/lib/syncthing"
      "/var/lib/unbound"
      "/var/lib/sabnzbd"
      "/var/lib/samba"
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

  systemd.tmpfiles.rules = [
    "D /var/lib/private 0700 root root -"
  ];
}
