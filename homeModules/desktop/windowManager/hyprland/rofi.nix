{ config, lib, pkgs, ... }:

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
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      #terminal = pkgs.kitty;

      plugins = with pkgs; [
        rofi-calc
        rofi-bluetooth
        rofi-screenshot
        rofi-power-menu
        rofi-file-browser
      ];

      #settings = {
      #  modi = "run,drun,window";
      #  #icon-theme = "Oranchelo";
      #  show-icons = true;
      #  terminal = "kitty";
      #  drun-display-format = "{icon} {name}";
      #  location = 0;
      #  disable-history = false;
      #  hide-scrollbar = true;
      #  display-drun = "   Apps ";
      #  display-run = "   Run ";
      #  display-window = " 﩯  Window";
      #  display-Network = " 󰤨  Network";
      #  sidebar-mode = true;
      #};
    };

    catppuccin.rofi.enable = lib.mkIf config.homeManager.theme.catppuccin.enable true;
  };
}
