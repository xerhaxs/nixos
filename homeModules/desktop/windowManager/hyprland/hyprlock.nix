{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    desktop.windowManager.hyprland.hyprlock = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable hyprlock.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.windowManager.hyprland.hyprlock.enable {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          hide_cursor = true;
          ignore_empty_input = true;
        };
        auth."fingerprint:enabled" = true;
      };
    };
  };
}
