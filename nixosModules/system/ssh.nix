{
  config,
  lib,
  pkgs,
  userName,
  ...
}:

{
  options.nixos = {
    system.ssh = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable ssh with sshguard.";
      };

      authorizedKeys = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBhC1nqSGZvIStHkFIrnYIeYP/hB+1QXKO+QW8KwuDtw jf@NixOS-Convertible"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGyndaaCmTLHdA5+sLBbxgSZNC6KXKtZkKiMK6AAY8Rt jf@NixOS-Desktop"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILuM9ISlzKCQNkkaPhGKCLeUdgko5uoVWGyqJUU6A/hi jf@NixOS-Framework"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICBrcia27OjgMhJs2jpbm5zFHUp/EMLpGTRUz7Pp9iRW jf@NixOS-Portable"
        ];
        description = "Public keys allowed to login as the system user.";
      };

      whitelist = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "10.75.0.40"
          "10.75.0.80"
        ];
        description = "Addresses or networks never blocked by sshguard.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.ssh.enable {
    services.openssh = {
      enable = true;
      startWhenNeeded = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        X11Forwarding = false;
        AllowUsers = [ userName ];
        LoginGraceTime = 30;
        MaxAuthTries = 3;
        LogLevel = "VERBOSE";
        ClientAliveInterval = 300;
        ClientAliveCountMax = 2;
        KexAlgorithms = [
          "mlkem768x25519-sha256"
          "sntrup761x25519-sha512"
          "sntrup761x25519-sha512@openssh.com"
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
        ];
        Ciphers = [
          "chacha20-poly1305@openssh.com"
          "aes256-gcm@openssh.com"
          "aes128-gcm@openssh.com"
        ];
        Macs = [
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha2-256-etm@openssh.com"
          "umac-128-etm@openssh.com"
        ];
      };
    };

    users.users.${userName}.openssh.authorizedKeys.keys = config.nixos.system.ssh.authorizedKeys;

    services.sshguard = {
      enable = true;
      services = [ "sshd" ];
      whitelist = config.nixos.system.ssh.whitelist;
      blocktime = 3600;
      detection_time = 30758400;
      blacklist_threshold = 60;
      attack_threshold = 10;
    };

    services.sshd.enable = true;

    # Host keys directly in /persistent: a persisted /etc/ssh is mounted after the activation and
    # hides sshd_config and authorized_keys.d on a fresh installation.
    services.openssh.hostKeys = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable [
      {
        path = "/persistent/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/persistent/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
    ];

    environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [ "/var/lib/sshguard" ];
    };
  };
}
