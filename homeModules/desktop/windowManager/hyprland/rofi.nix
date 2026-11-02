{
  config,
  lib,
  pkgs,
  ...
}:

let
  palette =
    (lib.importJSON "${config.catppuccin.sources.palette}/palette.json")
    .${config.catppuccin.flavor}.colors;
  accent = palette.${config.catppuccin.accent}.hex;

  theme = pkgs.writeText "catppuccin-launcher.rasi" ''
    * {
      font: "JetBrainsMono Nerd Font Propo 12";
      background-color: transparent;
      text-color: ${palette.text.hex};
    }

    window {
      location: center;
      anchor: center;
      width: 760px;
      background-color: ${palette.crust.hex}d9;
      border: 2px solid;
      border-color: ${accent}b3;
      border-radius: 20px;
    }

    mainbox {
      padding: 20px;
      spacing: 16px;
      children: [ inputbar, listview ];
    }

    inputbar {
      padding: 12px 18px;
      spacing: 14px;
      background-color: ${palette.surface0.hex}b3;
      border-radius: 14px;
      children: [ textbox-search, entry ];
    }

    textbox-search {
      expand: false;
      str: "󰍉";
      text-color: ${accent};
      font: "JetBrainsMono Nerd Font Propo 15";
      vertical-align: 0.5;
    }

    entry {
      placeholder: "Suchen";
      placeholder-color: ${palette.overlay1.hex};
      cursor-color: ${accent};
      vertical-align: 0.5;
    }

    listview {
      columns: 2;
      lines: 7;
      fixed-columns: true;
      fixed-height: true;
      scrollbar: false;
      spacing: 6px;
    }

    element {
      padding: 9px 12px;
      spacing: 14px;
      border-radius: 12px;
    }

    element normal.normal,
    element alternate.normal {
      background-color: transparent;
    }

    element selected.normal {
      background-color: ${accent};
      text-color: ${palette.crust.hex};
    }

    element-icon {
      size: 30px;
      vertical-align: 0.5;
    }

    element-text {
      vertical-align: 0.5;
      text-color: inherit;
    }

    message {
      padding: 10px 14px;
      background-color: ${palette.surface0.hex}b3;
      border-radius: 12px;
    }

    textbox {
      text-color: ${palette.subtext1.hex};
    }
  '';
in

{
  options.homeManager = {
    desktop.windowManager.hyprland.rofi = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable rofi.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.windowManager.hyprland.rofi.enable {
    catppuccin.rofi.enable = false;

    programs.rofi = {
      enable = true;
      package = pkgs.rofi;
      theme = "${theme}";

      plugins = with pkgs; [
        rofi-calc
        rofi-bluetooth
        rofi-screenshot
        rofi-power-menu
      ];

      settings = {
        terminal = "kitty";
        location = 0;
        modi = "drun,run,window,calc";
        show-icons = true;
        icon-theme = config.gtk.iconTheme.name;
        drun-display-format = "{name}";
        display-drun = "Apps";
        display-run = "Run";
        display-window = "Windows";
        display-calc = "Calc";
      };
    };
  };
}
