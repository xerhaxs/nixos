{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.sync.syncthing = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable syncthing sync.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.sync.syncthing.enable {
    services.syncthing = {
      enable = true;
      tray.enable = false;
      extraOptions = [
        "--gui-theme=black"
      ];
    };
  };
}
