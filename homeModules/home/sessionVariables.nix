{ config, lib, pkgs, ... }:

{
options.homeManager = {
    home.sessionVariables = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable session variabels.";
      };
    };
  };

  config = lib.mkIf config.homeManager.home.sessionVariables.enable {
    home.sessionVariables = {
      MOZ_USE_XINPUT2 = "1";
      MOZ_ENABLE_WAYLAND = "1";
      GTK_USE_PORTAL = "1";
    };
  };
}