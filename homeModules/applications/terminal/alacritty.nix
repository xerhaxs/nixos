{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.terminal.alacritty = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable alacritty.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.terminal.alacritty.enable {
    # alacritty - a cross-platform, GPU-accelerated terminal emulator
    programs.alacritty = {
      enable = true;
      # custom settings
      settings = {
        env.TERM = "xterm-256color";
        font = {
          size = 12;
          draw_bold_text_with_bright_colors = true;
        };
        scrolling.multiplier = 5;
        selection.save_to_clipboard = true;
      };
    };
  };
}
