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
        height = 40;
        margin-top = 10;
        margin-left = 14;
        margin-right = 14;
        spacing = 8;

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
          "group/stats"
          "group/audio"
          "group/connections"
          "tray"
          "custom/notification"
          "custom/power"
        ];

        "group/stats" = {
          orientation = "horizontal";
          modules = [
            "cpu"
            "memory"
            "temperature"
            "battery"
          ];
        };

        "group/audio" = {
          orientation = "horizontal";
          modules = [
            "pulseaudio"
            "pulseaudio#microphone"
            "backlight"
          ];
        };

        "group/connections" = {
          orientation = "horizontal";
          modules = [
            "network"
            "bluetooth"
            "idle_inhibitor"
          ];
        };

        "custom/launcher" = {
          format = "󱄅";
          tooltip = false;
          on-click = "rofi -show drun -show-icons";
          on-click-right = "waypaper";
        };

        "hyprland/workspaces" = {
          format = "{name}";
          on-scroll-up = "hyprctl dispatch 'hl.dsp.focus({ workspace = \"e-1\" })'";
          on-scroll-down = "hyprctl dispatch 'hl.dsp.focus({ workspace = \"e+1\" })'";
          persistent-workspaces."*" = 5;
        };

        "hyprland/window" = {
          max-length = 48;
          separate-outputs = true;
          icon = true;
          icon-size = 18;
        };

        clock = {
          format = "󰅐  {:%H:%M}";
          format-alt = "󰃭  {:L%A, %d. %B %Y}";
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
          format = "{player_icon}  {title}";
          format-paused = "{status_icon}  <i>{title}</i>";
          max-length = 40;
          player-icons.default = "󰝚";
          status-icons.paused = "󰏤";
        };

        cpu = {
          format = "󰻠  {usage}%";
          interval = 5;
        };

        memory = {
          format = "󰍛  {percentage}%";
          interval = 10;
        };

        temperature = {
          critical-threshold = 85;
          format = "󰔏  {temperatureC}°";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}  {capacity}%";
          format-charging = "󰂄  {capacity}%";
          format-plugged = "󰚥  {capacity}%";
          format-icons = [
            "󰁺"
            "󰁼"
            "󰁾"
            "󰂀"
            "󰁹"
          ];
        };

        pulseaudio = {
          format = "{icon}  {volume}%";
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
          format-source = "󰍬";
          format-source-muted = "󰍭";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        };

        backlight = {
          format = "{icon}  {percent}%";
          format-icons = [
            "󰃞"
            "󰃟"
            "󰃠"
          ];
          on-scroll-up = "brightnessctl -e4 -n2 set 5%+";
          on-scroll-down = "brightnessctl -e4 -n2 set 5%-";
        };

        network = {
          format-wifi = "{icon}";
          format-icons = [
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format-ethernet = "󰈀";
          format-disconnected = "󰖪";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}\n{essid}";
          on-click = "kitty --class nmtui -e nmtui";
        };

        bluetooth = {
          format = "󰂯";
          format-connected = "󰂱  {num_connections}";
          format-disabled = "󰂲";
          on-click = "rofi-bluetooth";
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰅶";
            deactivated = "󰛊";
          };
        };

        tray = {
          icon-size = 18;
          spacing = 10;
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "󰂞";
            none = "󰂜";
            dnd-notification = "󰂛";
            dnd-none = "󰂛";
          };
          return-type = "json";
          exec = "swaync-client --subscribe-waybar";
          on-click = "swaync-client --toggle-panel --skip-wait";
          on-click-right = "swaync-client --toggle-dnd --skip-wait";
          escape = true;
        };

        "custom/power" = {
          format = "󰐥";
          tooltip = false;
          on-click = "power-menu";
        };
      };

      style = ''
        * {
          font-family: "JetBrainsMono Nerd Font Propo", "Noto Sans", sans-serif;
          font-size: 14px;
          font-weight: 600;
          min-height: 0;
          border: none;
          box-shadow: none;
        }

        window#waybar {
          background: transparent;
          color: @text;
        }

        tooltip {
          background: alpha(@crust, 0.95);
          border: 1px solid alpha(@accent, 0.6);
          border-radius: 12px;
        }

        tooltip label {
          color: @text;
        }

        #custom-launcher,
        #workspaces,
        #window,
        #clock,
        #mpris,
        #stats,
        #audio,
        #connections,
        #tray,
        #custom-notification,
        #custom-power {
          background: alpha(@crust, 0.78);
          border: 1px solid alpha(@surface2, 0.35);
          border-radius: 14px;
          padding: 0 14px;
        }

        #custom-launcher {
          color: @accent;
          font-size: 20px;
          padding: 0 15px 0 12px;
          transition: color 200ms ease;
        }

        #custom-launcher:hover {
          color: @lavender;
        }

        #workspaces {
          padding: 0 5px;
        }

        #workspaces button {
          color: @overlay1;
          background: transparent;
          padding: 0 9px;
          margin: 5px 1px;
          border-radius: 10px;
          transition: all 200ms ease;
        }

        #workspaces button:hover {
          color: @text;
          background: alpha(@surface1, 0.7);
        }

        #workspaces button.empty {
          color: @surface2;
        }

        #workspaces button.active {
          color: @crust;
          background: @accent;
          padding: 0 15px;
        }

        #workspaces button.urgent {
          color: @crust;
          background: @red;
        }

        #window {
          color: @subtext1;
        }

        window#waybar.empty #window {
          background: transparent;
          border-color: transparent;
        }

        #clock {
          color: @accent;
          font-weight: 700;
        }

        #mpris {
          color: @green;
        }

        #mpris.paused {
          color: @overlay1;
        }

        #cpu,
        #memory,
        #temperature,
        #battery,
        #pulseaudio,
        #backlight,
        #network,
        #bluetooth,
        #idle_inhibitor {
          padding: 0 7px;
        }

        #cpu {
          color: @blue;
        }

        #memory {
          color: @green;
        }

        #temperature {
          color: @peach;
        }

        #temperature.critical {
          color: @red;
        }

        #battery {
          color: @teal;
        }

        #battery.warning {
          color: @yellow;
        }

        #battery.critical:not(.charging) {
          color: @red;
        }

        #pulseaudio {
          color: @accent;
        }

        #pulseaudio.microphone {
          color: @pink;
        }

        #pulseaudio.muted,
        #pulseaudio.microphone.source-muted {
          color: @red;
        }

        #backlight {
          color: @yellow;
        }

        #network {
          color: @teal;
        }

        #network.disconnected {
          color: @red;
        }

        #bluetooth {
          color: @blue;
        }

        #bluetooth.disabled {
          color: @overlay1;
        }

        #idle_inhibitor {
          color: @overlay1;
        }

        #idle_inhibitor.activated {
          color: @yellow;
        }

        #custom-notification {
          color: @yellow;
          font-size: 16px;
        }

        #custom-power {
          color: @red;
          font-size: 16px;
          padding: 0 15px 0 13px;
        }

        #custom-power:hover {
          color: @crust;
          background: @red;
        }
      '';
    };
  };
}
