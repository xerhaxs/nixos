{ config, lib, pkgs, ... }:

{
options.homeManager = {
    userEnvironment.sessionVariables = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable session variabels.";
      };
    };
  };

  config = lib.mkIf config.homeManager.userEnvironment.sessionVariables.enable {
    desktop.sessionVariables = {
      MOZ_USE_XINPUT2 = "1";
      MOZ_ENABLE_WAYLAND = "1";
      GTK_USE_PORTAL = "1";
    };
  };
}