{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    desktop.windowManager.hyprland.hyprland = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable hyprland.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.windowManager.hyprland.hyprland.enable {
    # Bind the helper services (waybar, swaync, hypridle, ...) to the Hyprland session only, not to Plasma.
    wayland.systemd.target = "hyprland-session.target";

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      xwayland.enable = true;
      systemd = {
        enable = true;
        variables = [ "--all" ];
      };

      plugins = with pkgs.hyprlandPlugins; [
        hypr-dynamic-cursors
        hyprtasking
      ];

      settings.monitor = {
        output = "";
        mode = "preferred";
        position = "auto";
        scale = "auto";
      };

      extraLuaFiles.config = {
        content = ./config/hyprland.lua;
        autoLoad = true;
      };
    };
  };
}
