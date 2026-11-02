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
        # Not --all: the user manager outlives the session and Plasma inherits what is imported here.
        # NIXOS_OZONE_WL alone gives Electron applications in Plasma their own title bar.
        variables = [
          "DISPLAY"
          "HYPRLAND_INSTANCE_SIGNATURE"
          "PATH"
          "WAYLAND_DISPLAY"
          "XDG_CURRENT_DESKTOP"
          "XDG_DATA_DIRS"
          "XDG_SESSION_TYPE"
        ];
      };

      plugins = with pkgs.hyprlandPlugins; [
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
