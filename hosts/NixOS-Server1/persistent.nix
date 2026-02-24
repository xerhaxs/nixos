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
      #"/root/.secrets"
      "/etc/nixos"
      "/etc/ssh"
      "/etc/zfs"
      "/var/log"
      #"/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/cache"
      "/var/db/sudo"
      "/var/lib/systemd/coredump"

      "/var/lib/acme"
      #"/var/lib/hass"
      #"/var/lib/jellyfin"
      #"/var/lib/radicale"
      { directory = "/var/lib/private/ollama"; mode = "0700" }
      "/var/lib/pihole"
      "/var/lib/syncthing"
      "/var/lib/unbound"
      #"/var/lib/private/invidious"
      #"/var/lib/private/nitter"
      #"/var/lib/redis-nitter"
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
}
