{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.communication.social = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable social communication apps.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.communication.social.enable {
    home.packages = with pkgs; [
      element-desktop
      signal-desktop-bin
      briar-desktop
      telegram-desktop
      wasistlos
      mumble
      teamspeak6-client
    ];
  };
}
