{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.usenet.nzbget = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable NZBGet.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.usenet.nzbget.enable {
    services.nzbget = {
      enable = true;
      settings = {
        MainDir = "/mount/Data/Datein/Downloads/NZB Download/";
        ControlPort = "6789";
        ControlUsername = "admin";
        ControlPassword = "CHANGEME";
      };
    };
  };
}
