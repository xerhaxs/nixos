{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    desktop.windowManager.hyprland.wofi = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable wofi.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.windowManager.hyprland.wofi.enable {  
    programs.wofi = {
      enable = true;
      catppuccin.enable = lib.mkIf config.homeManager.theme.catppuccin.enable true;

      settings = {
        modi = "run,drun,window";
        #icon-theme = "Oranchelo";
        show-icons = true;
        terminal = "kitty";
        drun-display-format = "{icon} {name}";
        location = 0;
        disable-history = false;
        hide-scrollbar = true;
        display-drun = "   Apps ";
        display-run = "   Run ";
        display-window = " 﩯  Window";
        display-Network = " 󰤨  Network";
        sidebar-mode = true;
      };
    };
  };
}
