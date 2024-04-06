{ config, lib, pkgs, ... }:

{
  {
  options.homeManager = {
    applications.communication.social = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable social communication apps.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.communication.social.enable {
    home.packages = with pkgs; [
      element-desktop
      signal-desktop
      telegram-desktop
    ];
  };
}
