{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    desktop.windowManager.hyprland.waybar = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable waybar.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.windowManager.hyprland.waybar.enable {
    programs.waybar = {
      enable = true;
      settings = [
        {
          "layer" = "top"; # Waybar at top layer
          "position" = "top"; # Waybar position (top|bottom|left|right)
          # "width" = 1280; # Waybar width
          # Choose the order of the modules
          "modules-left" = ["wlr/workspaces"];
          "modules-center" = ["custom/music"];
          "modules-right" = [ "pulseaudio" "backlight" "battery" "clock" "tray" "custom/lock" "custom/power" ];
          "wlr/workspaces" = {
              "disable-scroll" = true;
              "sort-by-name" = true;
              "format" = " {icon} ";
              "format-icons" = {
                  "default" = "";
              };
          };
          "tray" = {
              "icon-size" = 21;
              "spacing" = 10;
          };
          "custom/music" = {
              "format" = "  {}";
              "escape" = true;
              "interval" = 5;
              "tooltip" = false;
              "exec" = "playerctl metadata --format='{{ title }}'";
              "on-click" = "playerctl play-pause";
              "max-length" = 50;
          };
          "clock" = {
              "timezone" = "Asia/Dubai";
              "tooltip-format" = "<big>{ =%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
              "format-alt" = " { =%d/%m/%Y}";
              "format" = " { =%H =%M}";
          };
          "backlight" = {
              "device" = "intel_backlight";
              "format" = "{icon}";
              "format-icons" = [ "" "" "" "" "" "" "" "" "" ];
          };
          "battery" = {
              "states" = {
                  "warning" = 30;
                  "critical" = 15;
              };
              "format" = "{icon}";
              "format-charging" = "";
              "format-plugged" = "";
              "format-alt" = "{icon}";
              "format-icons" = [ "" "" "" "" "" "" "" "" "" "" "" "" ];
          };
          "pulseaudio" = {
              # "scroll-step" = 1; # %, can be a float
              "format" = "{icon} {volume}%";
              "format-muted" = "";
              "format-icons" = {
                  "default" = [ "" "" "" ];
              };
              "on-click" = "pavucontrol";
          };
          "custom/lock" = {
              "tooltip" = false;
              "on-click" = "sh -c '(sleep 0.5s; swaylock --grace 0)' & disown";
              "format" = "";
          };
          "custom/power" = {
              "tooltip" = false;
              "on-click" = "wlogout &";
              "format" = "襤";
          };
        }
      ];
    };

    catppuccin.waybar.enable = lib.mkIf config.homeManager.theme.catppuccin.enable true;
  };
}
