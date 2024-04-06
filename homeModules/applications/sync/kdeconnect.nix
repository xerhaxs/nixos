{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.sync.kdeconnect = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable kdeconnect sync.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.sync.kdeconnect.enable {
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
}
