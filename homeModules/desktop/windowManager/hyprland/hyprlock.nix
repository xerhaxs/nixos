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
    catppuccin.hyprlock.useDefaultConfig = false;

    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          hide_cursor = true;
          ignore_empty_input = true;
        };
        auth."fingerprint:enabled" = true;

        background = [
          {
            monitor = "";
            path = "screenshot";
            blur_passes = 3;
            blur_size = 8;
            brightness = 0.6;
            vibrancy = 0.17;
          }
        ];

        label = [
          {
            monitor = "";
            text = "$TIME";
            color = "$text";
            font_size = 120;
            font_family = "JetBrainsMono Nerd Font Propo ExtraBold";
            position = "0, 170";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "";
            text = ''cmd[update:60000] LC_ALL=en_US.UTF-8 date +"%A, %B %d"'';
            color = "$subtext1";
            font_size = 22;
            font_family = "JetBrainsMono Nerd Font Propo";
            position = "0, 60";
            halign = "center";
            valign = "center";
          }
        ];

        input-field = [
          {
            monitor = "";
            size = "340, 56";
            outline_thickness = 2;
            dots_size = 0.22;
            dots_spacing = 0.3;
            outer_color = "$accent";
            inner_color = "$surface0";
            font_color = "$text";
            check_color = "$green";
            fail_color = "$red";
            capslock_color = "$yellow";
            fade_on_empty = false;
            placeholder_text = "Password";
            fail_text = "$FAIL";
            rounding = -1;
            position = "0, -40";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };
  };
}
