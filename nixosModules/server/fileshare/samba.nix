{ config, lib, pkgs, ... }:

let
  sambaDirs = [
    { path = "/srv/samba/public"; owner = "root"; group = "tmjf"; mode = "0775"; }
    { path = "/srv/samba/jf"; owner = "jf"; group = "tmjf"; mode = ""0770""; }
    { path = "/srv/samba/meli"; owner = "meli"; group = "tmjf"; mode = ""0770""; }
    { path = "/srv/samba/video"; owner = "root"; group = "tmjf"; mode = ""0770""; }
    { path = "/srv/samba/photo"; owner = "root"; group = "tmjf"; mode = ""0770""; }
    { path = "/srv/samba/music"; owner = "root"; group = "tmjf"; mode = ""0770""; }
    { path = "/srv/samba/document"; owner = "root"; group = "tmjf"; mode = ""0770""; }
    { path = "/srv/samba/games"; owner = "root"; group = "tmjf"; mode = ""0770""; }
    { path = "/srv/samba/backup"; owner = "haos"; group = "tmjf"; mode = ""0770""; }
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
        group = "tmjf";
        home = "/srv/samba/jf";
        shell = pkgs.nologin;
      };
      meli = {
        isNormalUser = false;
        group = "tmjf";
        home = "/srv/samba/meli";
        shell = pkgs.nologin;
      };
      haos = {
        isNormalUser = false;
        group = "api";
        home = "/srv/samba/backup";
        shell = pkgs.nologin;
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
        workgroup = "WORKGROUP";
        serverString = "NixOS Secure Samba Server";
        security = "user";
        mapToGuest = "Never";
        "encrypt passwords" = "true";
        "smb encrypt" = "required";
        "min protocol" = "SMB3";
        "max protocol" = "SMB3";
        "server signing" = "mandatory";

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
            validUsers = [ "jf" ];
            "create mask" = "0660";
            "directory mask" = "0770";
          };

          meli = {
            path = "/srv/samba/meli";
            "browseable" = "yes";
            "read only" = "no";
            validUsers = [ "meli" ];
            "create mask" = "0660";
            "directory mask" = "0770";
          };

          video = {
            path = "/srv/samba/video";
            "browseable" = "yes";
            "read only" = "no";
            validGroups = [ "tmjf" ];
            "create mask" = "0660";
            "directory mask" = "0770";
          };

          photo = {
            path = "/srv/samba/photo";
            "browseable" = "yes";
            "read only" = "no";
            validGroups = [ "tmjf" ];
            "create mask" = "0660";
            "directory mask" = "0770";
          };

          music = {
            path = "/srv/samba/music";
            "browseable" = "yes";
            "read only" = "no";
            validGroups = [ "tmjf" ];
            "create mask" = "0660";
            "directory mask" = "0770";
          };

          document = {
            path = "/srv/samba/document";
            "browseable" = "yes";
            "read only" = "no";
            validGroups = [ "tmjf" ];
            "create mask" = "0660";
            "directory mask" = "0770";
          };

          games = {
            path = "/srv/samba/games";
            "browseable" = "yes";
            "read only" = "no";
            validGroups = [ "tmjf" ];
            "create mask" = "0660";
            "directory mask" = "0770";
          };

          backup = {
            path = "/srv/samba/backup";
            "browseable" = "yes";
            "read only" = "no";
            validUsers = [ "haos" ];
            validGroups = [ "tmjf" ];
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