{ config, lib, pkgs, ... }:

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
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      sourceFirst = true;
      systemd.enable = true;

      settings = {
        # Please note not all available settings / options are set here.
        # For a full list, see the wiki
        # See https://wiki.hyprland.org/Configuring/Keywords/ for more
        # Source a file (multi-file configs)
        # source = ~/.config/hypr/myColors.conf
        # For all categories, see https://wiki.hyprland.org/Configuring/Variables/

        # See https://wiki.hyprland.org/Configuring/Monitors/
        #monitor = ",preferred,auto,auto";
        #monitor = "name,resolution,position,scale";
        #monitor = "DP-1,3840x1600@144,0x0,1,bitdepth,10";
        #monitor = ",1920x1200@60,0x0,1,bitdepth,8";

        # Execute your favorite apps at launch
        #exec-once=swaybg -i $NIXOS_CONFIG_DIR/pics/wallpaper.png
        #exec-once=foot --server
        #exec-once=wlsunset -l -23 -L -46
        exec-once = [
          "waybar"
          "dunst"
          #"rofi -show run"
          "keepassxc %f"
          "protonmail-bridge --noninteractive"
          "flameshot"
        ];

        # Example windowrule v1
        # windowrule = float, ^(kitty)$
        # Example windowrule v2
        # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
        # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
          
        general = {
          layout = "dwindle";
          
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          #col.active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          #col.inactive_border = "rgba(595959aa)";

          # env variable for qt theming on hyprland
          env = "QT_QPA_PLATFORM,wayland";
        };

        animations = {
          enabled = "yes";

          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };
          
        #decoration = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

      #    blur_enabled = true;
      #    rounding = 10;
      #    blur = "yes";
      #    blur_size = 3;
      #    blur_passes = 1;
      #    blur_new_optimizations = true;

      #    drop_shadow = "yes";
      #    shadow_range = 4;
      #    shadow_render_power = 3;
      #    col.shadow = "rgba(1a1a1aee)";
        #};

        dwindle = {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile = "yes"; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = "yes"; # you probably want this
        };

        master = {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          new_status = "master";
        };

        gestures = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = "on";
        };

        # Example per-device config
        # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
        #device:epic-mouse-v1 = {
      #    sensitivity = -0.5;
        #};

        input = {
          kb_layout = "de";
          #kb_variant =
          #kb_model =
          #kb_options =
          #kb_rules =

          follow_mouse = 1;

          touchpad = {
              natural_scroll = "yes";
          };

          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
        };

        # Some default env vars.
        env = "XCURSOR_SIZE,24";
      
        "$mainMod" = "SUPER";

        bind = [
          # See https://wiki.hyprland.org/Configuring/Keywords/ for more

          # Application binds
          ", PRINT, exec, flameshot gui"

          # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
          "$mainMod, RETURN, exec, kitty"
          "$mainMod, Q, killactive,"
          "$mainMod SHIFT, Q, exit,"
          "$mainMod, E, exec, dolphin"
          "$mainMod, F, togglefloating,"
          "$mainMod, R, exec, rofi -show drun"
          "$mainMod, P, pseudo," # dwindle
          "$mainMod, J, togglesplit," # dwindle

          "$mainMod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy" # rofi clipboard"

          # Move focus with mainMod + arrow keys
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          # Switch workspaces with mainMod + [0-9]
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"
        ];

        bindm = [
          # Scroll through existing workspaces with mainMod + scroll
          #"$mainMod, mouse_down, workspace, e+1"
          #"$mainMod, mouse_up, workspace, e-1"

          # Move/resize windows with mainMod + LMB/RMB and dragging
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

              
        bindl = [
          # Audio Controll
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          #, XF86AudioNext, exec
          #, XF86AudioPause, exec,
          #, XF86AudioPlay, exec,
          #, XF86AudioPrev, exec,
          #, XF86AudioStop, exec, 
          ", XF86Calculator, exec, qalculate-gtk"
          ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
          ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
          #", XF86BrightnessAdjust, exec,"

          "$mainMod SUPERALT, -, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          "$mainMod, /, exec, wpctl set-default 44"
          "$mainMod, *, exec, wpctl set-default 45"
          "$mainMod, +, exec, wpctl set-default 47"
        ];
      };

      plugins = with pkgs; [
        hyprlandPlugins.hyprgrass
      ];
    };

    catppuccin.hyprland.enable = lib.mkIf config.homeManager.theme.catppuccin.enable true;
  };
}

