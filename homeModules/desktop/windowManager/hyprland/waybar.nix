{
  config,
  lib,
  pkgs,
  ...
}:

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
      systemd.enable = true;

      settings.mainBar = {
        layer = "top";
        position = "top";
        height = 34;
        margin-top = 6;
        margin-left = 10;
        margin-right = 10;
        spacing = 6;

        modules-left = [
          "custom/launcher"
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [
          "clock"
          "mpris"
        ];
        modules-right = [
          "idle_inhibitor"
          "cpu"
          "memory"
          "temperature"
          "backlight"
          "pulseaudio"
          "pulseaudio#microphone"
          "network"
          "bluetooth"
          "battery"
          "tray"
          "custom/notification"
          "custom/power"
        ];

        "custom/launcher" = {
          format = "";
          tooltip = false;
          on-click = "rofi -show drun -show-icons";
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          on-scroll-up = "hyprctl dispatch 'hl.dsp.focus({ workspace = \"e-1\" })'";
          on-scroll-down = "hyprctl dispatch 'hl.dsp.focus({ workspace = \"e+1\" })'";
          format-icons = {
            active = "";
            default = "";
            urgent = "";
          };
          persistent-workspaces."*" = 5;
        };

        "hyprland/window" = {
          max-length = 40;
          separate-outputs = true;
        };

        clock = {
          format = "  {:%H:%M}";
          format-alt = "  {:%A, %d. %B %Y}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            weeks-pos = "left";
            on-scroll = 1;
            format = {
              today = "<span color='#f38ba8'><b><u>{}</u></b></span>";
              weeks = "<span color='#94e2d5'><b>W{}</b></span>";
            };
          };
        };

        mpris = {
          format = "{player_icon} {title}";
          format-paused = "{status_icon} <i>{title}</i>";
          max-length = 40;
          player-icons.default = "";
          status-icons.paused = "";
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        cpu = {
          format = "  {usage}%";
          interval = 5;
        };

        memory = {
          format = "  {percentage}%";
          interval = 10;
        };

        temperature = {
          critical-threshold = 85;
          format = " {temperatureC}°C";
        };

        backlight = {
          format = "{icon} {percent}%";
          format-icons = [
            "󰃞"
            "󰃟"
            "󰃠"
          ];
          on-scroll-up = "brightnessctl -e4 -n2 set 5%+";
          on-scroll-down = "brightnessctl -e4 -n2 set 5%-";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟";
          format-icons.default = [
            "󰕿"
            "󰖀"
            "󰕾"
          ];
          on-click = "pypr toggle volume";
          on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };

        "pulseaudio#microphone" = {
          format = "{format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        };

        network = {
          format-wifi = "  {signalStrength}%";
          format-ethernet = "󰈀";
          format-disconnected = "󰖪";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}\n{essid}";
          on-click = "kitty --class nmtui -e nmtui";
        };

        bluetooth = {
          format = "";
          format-connected = " {num_connections}";
          format-disabled = "󰂲";
          on-click = "rofi-bluetooth";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = " {capacity}%";
          format-icons = [
            "󰁺"
            "󰁼"
            "󰁾"
            "󰂀"
            "󰁹"
          ];
        };

        tray = {
          icon-size = 18;
          spacing = 8;
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
          };
          return-type = "json";
          exec = "swaync-client --subscribe-waybar";
          on-click = "swaync-client --toggle-panel --skip-wait";
          on-click-right = "swaync-client --toggle-dnd --skip-wait";
          escape = true;
        };

        "custom/power" = {
          format = "⏻";
          tooltip = false;
          on-click = "wlogout --protocol layer-shell";
        };
      };

      style = ''
        * {
          font-family: "JetBrainsMono Nerd Font", "Noto Sans", sans-serif;
          font-size: 13px;
          min-height: 0;
        }

        window#waybar {
          background: alpha(@base, 0.80);
          border: 2px solid alpha(@accent, 0.6);
          border-radius: 14px;
          color: @text;
        }

        tooltip {
          background: @base;
          border: 1px solid @accent;
          border-radius: 10px;
        }

        #workspaces button {
          color: @overlay1;
          padding: 0 6px;
          border-radius: 10px;
        }

        #workspaces button.active {
          color: @accent;
        }

        #workspaces button.urgent {
          color: @red;
        }

        #custom-launcher,
        #window,
        #clock,
        #mpris,
        #idle_inhibitor,
        #cpu,
        #memory,
        #temperature,
        #backlight,
        #pulseaudio,
        #network,
        #bluetooth,
        #battery,
        #tray,
        #custom-notification,
        #custom-power {
          padding: 0 10px;
          margin: 4px 0;
          border-radius: 10px;
          background: alpha(@surface0, 0.6);
        }

        #custom-launcher {
          color: @accent;
          font-size: 16px;
        }

        #clock {
          color: @accent;
          font-weight: bold;
        }

        #battery.warning {
          color: @yellow;
        }

        #battery.critical:not(.charging),
        #temperature.critical,
        #pulseaudio.muted,
        #pulseaudio.microphone.source-muted {
          color: @red;
        }

        #custom-power {
          color: @red;
        }
      '';
    };
  };
}
