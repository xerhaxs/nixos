{ config, lib, pkgs, ... }:

let
  sambaDirs = [
    { path = "/srv/samba/public"; owner = "root"; group = "tmjf"; mode = "0775"; }
    { path = "/srv/samba/jf"; owner = "jf"; group = "tmjf"; mode = "0770"; }
    { path = "/srv/samba/meli"; owner = "meli"; group = "tmjf"; mode = "0770"; }
    { path = "/srv/samba/video"; owner = "root"; group = "tmjf"; mode = "0770"; }
    { path = "/srv/samba/photo"; owner = "root"; group = "tmjf"; mode = "0770"; }
    { path = "/srv/samba/music"; owner = "root"; group = "tmjf"; mode = "0770"; }
    { path = "/srv/samba/document"; owner = "root"; group = "tmjf"; mode = "0770"; }
    { path = "/srv/samba/games"; owner = "root"; group = "tmjf"; mode = "0770"; }
    { path = "/srv/samba/backup"; owner = "haos"; group = "tmjf"; mode = "0770"; }
  ];
in

{
  options.nixos = {
    server.fileshare.samba = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Samba file share.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fileshare.samba.enable {
    users.groups = {
      tmjf = {};
      api = {};
    };

    users.users = {
      jf = {
        isNormalUser = false;
        isSystemUser = true;
        group = "tmjf";
        home = "/srv/samba/jf";
      };
      meli = {
        isNormalUser = false;
        isSystemUser = true;
        group = "tmjf";
        home = "/srv/samba/meli";
      };
      haos = {
        isNormalUser = false;
        isSystemUser = true;
        group = "api";
        home = "/srv/samba/backup";
      };
    };

    # Verzeichnisse erstellen und Rechte setzen
    environment.etc."samba-dirs".text = ''
      ${builtins.concatStringsSep "\n" (map (d: ''
        mkdir -p ${d.path}
        chown ${d.owner}:${d.group} ${d.path}
        chmod ${d.mode} ${d.path}
      '') sambaDirs)}
    '';

    services.samba = {
      enable = true;
      nsswins = true;
      smbd.enable = true;
      nmbd.enable = true;
      winbindd.enable = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "serverString" = "NixOS Secure Samba Server";
          "security" = "user";
          "encrypt passwords" = "yes";
          "smb encrypt" = "required";
          "hosts allow" = "10.75.0. 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "map to guest" = "Never";
          "min protocol" = "SMB3";
          "max protocol" = "SMB3";
          "server signing" = "mandatory";
        };

        shares = {
          public = {
            path = "/srv/samba/public";
            "browseable" = "yes";
            "read only" = "no";
            "guest ok" = "yes";
            "create mask" = "0664";
            "directory mask" = "0775";
            # Hinweis: Dateigrößenbegrenzung über Filesystem-Quota
          };

          jf = {
            path = "/srv/samba/jf";
            "browseable" = "yes";
            "read only" = "no";
            "valid users" = "jf";
            "create mask" = "0660";
            "directory mask" = "0770";
          };

          meli = {
            path = "/srv/samba/meli";
            "browseable" = "yes";
            "read only" = "no";
            "valid users" = "meli";
            "create mask" = "0660";
            "directory mask" = "0770";
          };

          video = {
            path = "/srv/samba/video";
            "browseable" = "yes";
            "read only" = "no";
            "valid users" = "@tmjf";
            "create mask" = "0660";
            "directory mask" = "0770";
          };

          photo = {
            path = "/srv/samba/photo";
            "browseable" = "yes";
            "read only" = "no";
            "valid users" = "@tmjf";
            "create mask" = "0660";
            "directory mask" = "0770";
          };

          music = {
            path = "/srv/samba/music";
            "browseable" = "yes";
            "read only" = "no";
            "valid users" = "@tmjf";
            "create mask" = "0660";
            "directory mask" = "0770";
          };

          document = {
            path = "/srv/samba/document";
            "browseable" = "yes";
            "read only" = "no";
            "valid users" = "@tmjf";
            "create mask" = "0660";
            "directory mask" = "0770";
          };

          games = {
            path = "/srv/samba/games";
            "browseable" = "yes";
            "read only" = "no";
            "valid users" = "@tmjf";
            "create mask" = "0660";
            "directory mask" = "0770";
          };

          backup = {
            path = "/srv/samba/backup";
            "browseable" = "yes";
            "read only" = "no";
            "validUsers" = "haos, @tmjf";
            "create mask" = "0660";
            "directory mask" = "0770";
          };
        };
      };
    };

    services.samba-wsdd = {
      enable = true;
      workgroup = "TMJF";
      openFirewall = true;
      discovery = true;
    };

    networking.firewall.enable = true;
    networking.firewall.allowPing = true;
  };
}