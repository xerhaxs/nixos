{
  config,
  lib,
  pkgs,
  userName,
  ...
}:

let
  nas-options = [
    "nofail"
    "_netdev"
    "x-systemd.device-timeout=10s"
    "x-systemd.mount-timeout=15s"
    "gid=500,file_mode=0777,dir_mode=0777"
    "vers=3.1.1,credentials=${config.sops.secrets."nas-smb/user".path}"
    "noperm"
    "nounix"
    "serverino"
  ];
in

{
  options.nixos = {
    userEnvironment.networkshares = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable mounting of networkshares.";
      };

      server = lib.mkOption {
        type = lib.types.str;
        default = "NixOS-Server1";
        description = "Hostname of the NAS providing the SMB shares.";
      };

      webdav = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "Mount the WebDAV share of NixOS-Server1 (dav.<homeDomain>) on /mount/dav (secret webdav-share/davfs).";
        };

        url = lib.mkOption {
          type = lib.types.str;
          default = "https://dav.${config.nixos.site.homeDomain}/";
          defaultText = lib.literalExpression ''"https://dav.''${config.nixos.site.homeDomain}/"'';
          description = "URL of the WebDAV share.";
        };
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.networkshares.enable {
    sops.secrets."nas-smb/user" = { };

    # Line format: <url> <user> <password>
    sops.secrets."webdav-share/davfs" =
      lib.mkIf config.nixos.userEnvironment.networkshares.webdav.enable
        {
          path = "/etc/davfs2/secrets";
          mode = "0600";
        };

    services.davfs2 = lib.mkIf config.nixos.userEnvironment.networkshares.webdav.enable {
      enable = true;
      settings.globalSection = {
        use_locks = false;
        cache_size = 512;
      };
    };

    fileSystems."/mount/dav" = lib.mkIf config.nixos.userEnvironment.networkshares.webdav.enable {
      device = config.nixos.userEnvironment.networkshares.webdav.url;
      fsType = "davfs";
      options = [
        "nofail"
        "_netdev"
        "x-systemd.automount"
        "x-systemd.idle-timeout=600"
        "x-systemd.mount-timeout=30s"
        "uid=${userName}"
        "gid=users"
        "file_mode=0640"
        "dir_mode=0750"
      ];
    };

    services.gvfs.enable = true;

    environment.systemPackages = with pkgs; [
      cifs-utils
      nfs-utils
      sshfs
    ];

    users.groups.nas = {
      gid = 500;
    };

    fileSystems."/mount/nas/backup" = {
      device = "//${config.nixos.userEnvironment.networkshares.server}/backup";
      fsType = "cifs";
      options = nas-options;
    };
    fileSystems."/mount/nas/document" = {
      device = "//${config.nixos.userEnvironment.networkshares.server}/document";
      fsType = "cifs";
      options = nas-options;
    };
    fileSystems."/mount/nas/games" = {
      device = "//${config.nixos.userEnvironment.networkshares.server}/games";
      fsType = "cifs";
      options = nas-options ++ [ "nobrl" ];
    };
    fileSystems."/mount/nas/jf" = {
      device = "//${config.nixos.userEnvironment.networkshares.server}/jf";
      fsType = "cifs";
      options = nas-options;
    };
    fileSystems."/mount/nas/music" = {
      device = "//${config.nixos.userEnvironment.networkshares.server}/music";
      fsType = "cifs";
      options = nas-options;
    };
    fileSystems."/mount/nas/photo" = {
      device = "//${config.nixos.userEnvironment.networkshares.server}/photo";
      fsType = "cifs";
      options = nas-options;
    };
    fileSystems."/mount/nas/video" = {
      device = "//${config.nixos.userEnvironment.networkshares.server}/video";
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

    users.users."${userName}" = {
      extraGroups = [
        "nas"
      ];
    };
  };
}
