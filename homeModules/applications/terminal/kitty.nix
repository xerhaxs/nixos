{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.terminal.kitty = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable kitty.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.terminal.kitty.enable {
    programs.kitty = {
      enable = true;
      shellIntegration.enableBashIntegration = true;
      settings = {
        confirm_os_window_close = false;
      };
    };

    catppuccin.kitty.enable = lib.mkIf config.homeManager.theme.catppuccin.enable true;
  };
}
