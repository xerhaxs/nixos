{
  config,
  lib,
  pkgs,
  ...
}:

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
    services.samba = {
      enable = true;
      openFirewall = true;
      nsswins = true;
      smbd.enable = true;
      nmbd.enable = false;
      winbindd.enable = true;

      settings = {
        global = {
          "workgroup" = "TMJF";
          "serverString" = "NixOS-Server1";
          "security" = "user";
          "encrypt passwords" = "yes";
          "smb encrypt" = "required";
          "hosts allow" = "10.75.0. 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "map to guest" = "Never";
          "min protocol" = "SMB3";
          "max protocol" = "SMB3";
          "server signing" = "mandatory";

          "vfs objects" = "recycle";
          "recycle:repository" = ".recycle/%U";
          "recycle:keeptree" = "yes";
          "recycle:versions" = "yes";
          "recycle:touch" = "yes";
          "recycle:exclude" = "*.tmp *.temp *.o *.obj ~*";
          "recycle:exclude_dir" = ".recycle";
        };

        jf = {
          path = "${config.nixos.server.fileshare.share.path}/jf";
          "browseable" = "yes";
          "read only" = "no";
          "valid users" = "jf";
          "create mask" = "0660";
          "directory mask" = "0770";
        };

        meli = {
          path = "${config.nixos.server.fileshare.share.path}/meli";
          "browseable" = "yes";
          "read only" = "no";
          "valid users" = "meli";
          "create mask" = "0660";
          "directory mask" = "0770";
        };

        video = {
          path = "${config.nixos.server.fileshare.share.path}/video";
          "browseable" = "yes";
          "read only" = "no";
          "valid users" = "@tmjf";
          "create mask" = "0660";
          "directory mask" = "0770";
        };

        photo = {
          path = "${config.nixos.server.fileshare.share.path}/photo";
          "browseable" = "yes";
          "read only" = "no";
          "valid users" = "@tmjf";
          "create mask" = "0660";
          "directory mask" = "0770";
        };

        music = {
          path = "${config.nixos.server.fileshare.share.path}/music";
          "browseable" = "yes";
          "read only" = "no";
          "valid users" = "@tmjf";
          "create mask" = "0660";
          "directory mask" = "0770";
        };

        document = {
          path = "${config.nixos.server.fileshare.share.path}/document";
          "browseable" = "yes";
          "read only" = "no";
          "valid users" = "@tmjf";
          "create mask" = "0660";
          "directory mask" = "0770";
        };

        games = {
          path = "${config.nixos.server.fileshare.share.path}/games";
          "browseable" = "yes";
          "read only" = "no";
          "valid users" = "@tmjf";
          "create mask" = "0660";
          "directory mask" = "0770";
        };

        backup = {
          path = "${config.nixos.server.fileshare.share.path}/backup";
          "browseable" = "yes";
          "read only" = "no";
          "valid users" = "haos, @tmjf";
          "create mask" = "0660";
          "directory mask" = "0770";
        };
      };
    };

    system.activationScripts.sambaUsers.text = ''
      echo -e "$(cat ${config.sops.secrets."smb-share/user-jf".path})\n$(cat ${
        config.sops.secrets."smb-share/user-jf".path
      })" | ${pkgs.samba}/bin/smbpasswd -s -a jf || true
      echo -e "$(cat ${config.sops.secrets."smb-share/user-meli".path})\n$(cat ${
        config.sops.secrets."smb-share/user-meli".path
      })" | ${pkgs.samba}/bin/smbpasswd -s -a meli || true
      echo -e "$(cat ${config.sops.secrets."smb-share/user-haos".path})\n$(cat ${
        config.sops.secrets."smb-share/user-haos".path
      })" | ${pkgs.samba}/bin/smbpasswd -s -a haos || true
    '';

    systemd.services.smb-recycle-clean = {
      script = ''
        find ${config.nixos.server.fileshare.share.path} -type d -name ".recycle" -exec rm -rf {}/\* \;
      '';
      serviceConfig.Type = "oneshot";
    };

    systemd.timers.smb-recycle-clean = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "weekly";
        Persistent = true;
      };
    };

    services.samba-wsdd = {
      enable = true;
      workgroup = "TMJF";
      openFirewall = true;
      discovery = true;
    };
  };
}
