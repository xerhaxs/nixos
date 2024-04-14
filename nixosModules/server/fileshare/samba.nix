{ config, lib, pkgs, ... }:

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
      securityType = "user";
      openFirewall = true;
      nsswins = true;
      enableNmbd = true;
      
      extraConfig = ''
        workgroup = WORKGROUP
        server string = smbnix
        netbios name = smbnix
        security = user 
        #use sendfile = yes
        #max protocol = smb2
        # note: localhost is the ipv6 localhost ::1
        hosts allow = 192.168.0. 127.0.0.1 localhost
        hosts deny = 0.0.0.0/0
        guest account = nobody
        map to guest = bad user
      '';
      shares = {
        public = {
          path = "/mnt/shares/public";
          browseable = "yes";
          "read only" = "yes";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "admin";
          "force group" = "admin";
        };
        private = {
          path = "/mnt/shares/private";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "admin";
          "force group" = "admin";
        };
      };
    };

    services.samba-wsdd = {
      enable = true;
      workgroup = "NixOS";
      openFirewall = true;
      discovery = true;
    };
  };
}