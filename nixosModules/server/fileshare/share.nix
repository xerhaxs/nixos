{ config, lib, pkgs, ... }:

let
  shareDirs = [
    { path = "${config.nixos.server.fileshare.share.path}/jf"; owner = "root"; group = "share"; mode = "0770"; }
    { path = "${config.nixos.server.fileshare.share.path}/meli"; owner = "root"; group = "share"; mode = "0770"; }
    { path = "${config.nixos.server.fileshare.share.path}/video"; owner = "root"; group = "share"; mode = "0770"; }
    { path = "${config.nixos.server.fileshare.share.path}/photo"; owner = "root"; group = "share"; mode = "0770"; }
    { path = "${config.nixos.server.fileshare.share.path}/music"; owner = "root"; group = "share"; mode = "0770"; }
    { path = "${config.nixos.server.fileshare.share.path}/document"; owner = "root"; group = "share"; mode = "0770"; }
    { path = "${config.nixos.server.fileshare.share.path}/games"; owner = "root"; group = "share"; mode = "0770"; }
    { path = "${config.nixos.server.fileshare.share.path}/backup"; owner = "root"; group = "share"; mode = "0770"; }
  ];
in

{
  options.nixos = {
    server.fileshare.share = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable file sharing systems.";
      };
      path = lib.mkOption {
        type = lib.types.str;
        example = "/srv/share/";
        description = "Set share path.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fileshare.share.enable {
    nixos.server.fileshare.share.path = "/srv/share";
    
    systemd.tmpfiles.rules = map (d:
      "d ${d.path} ${d.mode} ${d.owner} ${d.group} -"
    ) shareDirs;

    users.groups = {
      share = { };
      tmjf = { };
      api = { };
    };

    users.users = {
      jf = {
        isSystemUser = true;
        group = "share";
        extraGroups = [ "tmjf" ];
      };
      meli = {
        isSystemUser = true;
        group = "share";
        extraGroups = [ "tmjf" ];
      };
      haos = {
        isSystemUser = true;
        group = "share";
        extraGroups = [ "api" ];
      };
      webdav = {
        extraGroups = [ "share" ];
      }
    };
  };
}