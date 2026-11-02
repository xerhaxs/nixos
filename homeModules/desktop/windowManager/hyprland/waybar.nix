{
  config,
  lib,
  pkgs,
  ...
}:

let
  glyph = import ./glyphs.nix { inherit lib; };

  vpn = config.homeManager.applications.vpn.enable;

  vpnStatus = pkgs.writeShellScript "vpn-status" ''
    status=$(${pkgs.mullvad}/bin/mullvad status 2>/dev/null | ${pkgs.coreutils}/bin/head -n 2)
    case "$status" in
      Connected*) icon="${glyph "F0565"}" class=connected ;;
      *) icon="${glyph "F099D"}" class=disconnected ;;
    esac
    ${pkgs.jq}/bin/jq -nc --arg text "$icon" --arg class "$class" --arg tooltip "$status" \
      '{text: $text, class: $class, tooltip: $tooltip}'
  '';

  vpnToggle = pkgs.writeShellScript "vpn-toggle" ''
    case "$(${pkgs.mullvad}/bin/mullvad status)" in
      Connected*) ${pkgs.mullvad}/bin/mullvad disconnect ;;
      *) ${pkgs.mullvad}/bin/mullvad connect ;;
    esac
  '';

  button = icon: tooltip: action: {
    format = glyph icon;
    tooltip-format = tooltip;
    on-click = action;
  };

  monitor = "pypr toggle monitor";
in

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
          "custom/favorites"
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [
          "clock"
          "custom/weather"
          "mpris"
        ];
        modules-right = [
          "group/stats"
          "group/audio"
          "group/connections"
          "group/tools"
          "tray"
          "custom/notification"
          "group/session"
        ];

        "group/stats" = {
          orientation = "horizontal";
          modules = [
            "cpu"
            "memory"
            "temperature"
            "disk"
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
          ]
          ++ lib.optional vpn "custom/vpn"
          ++ [
            "power-profiles-daemon"
            "idle_inhibitor"
          ];
        };

        "group/tools" = {
          orientation = "horizontal";
          drawer = {
            transition-duration = 150;
            transition-left-to-right = false;
          };
          modules = [
            "custom/tools"
            "custom/screenshot"
            "custom/clipboard"
            "custom/colorpicker"
            "custom/wallpaper"
            "custom/nightlight"
            "custom/widgets"
          ];
        };

        "group/session" = {
          orientation = "horizontal";
          drawer = {
            transition-duration = 150;
            transition-left-to-right = false;
          };
          modules = [
            "custom/power"
            "custom/lock"
            "custom/logout"
            "custom/reboot"
            "custom/shutdown"
          ];
        };

        "custom/launcher" = {
          format = "󱄅";
          tooltip = false;
          on-click = "quick-menu";
          on-click-middle = "rofi -show window -show-icons";
          on-click-right = "rofi -show drun -show-icons";
        };

        "custom/favorites" = button "F04CE" "Favorites" "rofi -show favorites -show-icons";

        "custom/weather" = {
          exec = "desktop-weather --bar";
          return-type = "json";
          interval = 900;
          on-click-right = "desktop-weather --bar";
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
          locale = "en_US.UTF-8";
          format = "󰅐  {:%H:%M}";
          format-alt = "󰃭  {:%A, %B %d %Y}";
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
          on-scroll-up = "playerctl next";
          on-scroll-down = "playerctl previous";
          on-click-right = "playerctl next";
          format = "{player_icon}  {title}";
          format-paused = "{status_icon}  <i>{title}</i>";
          max-length = 40;
          player-icons.default = "󰝚";
          status-icons.paused = "󰏤";
        };

        cpu = {
          on-click = monitor;
          format = "󰻠  {usage}%";
          interval = 5;
        };

        memory = {
          on-click = monitor;
          format = "󰍛  {percentage}%";
          interval = 10;
        };

        disk = {
          path = "/nix";
          interval = 60;
          format = "${glyph "F02CA"}  {percentage_used}%";
          tooltip-format = "{used} of {total} used on {path}";
          on-click = monitor;
        };

        temperature = {
          on-click = monitor;
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
          on-click-middle = "quick-menu audio";
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
          on-click = "quick-menu network";
          on-click-right = "kitty --class nmtui -e nmtui";
        };

        bluetooth = {
          format = "󰂯";
          format-connected = "󰂱  {num_connections}";
          format-disabled = "󰂲";
          on-click = "rofi-bluetooth";
        };

        power-profiles-daemon = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}";
          format-icons = {
            default = glyph "F05D1";
            performance = glyph "F04C5";
            balanced = glyph "F05D1";
            power-saver = glyph "F032A";
          };
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
          format = glyph "F0425";
          tooltip = false;
          on-click = "power-menu";
        };

        "custom/lock" = button "F033E" "Lock" "loginctl lock-session";
        "custom/logout" = button "F0343" "Log out" "hyprctl dispatch 'hl.dsp.exit()'";
        "custom/reboot" = button "F0709" "Reboot" "systemctl reboot";
        "custom/shutdown" = button "F0425" "Shut down" "systemctl poweroff";

        "custom/tools" = {
          format = glyph "F1064";
          tooltip = false;
          on-click = "quick-menu";
        };

        "custom/screenshot" = button "F0100" "Screenshot" "flameshot gui";
        "custom/clipboard" = button "F0147" "Clipboard history" "quick-menu clipboard";
        "custom/colorpicker" = button "F020A" "Pick a color" "hyprpicker --autocopy";
        "custom/wallpaper" =
          button "F02E9" "Random wallpaper"
            "systemctl --user start wallpaper-random.service";
        "custom/nightlight" = button "F0594" "Toggle night light" "quick-menu nightlight";
        "custom/widgets" = button "F072C" "Toggle desktop widgets" "desktop-widgets toggle";
      }
      // lib.optionalAttrs vpn {
        "custom/vpn" = {
          exec = "${vpnStatus}";
          return-type = "json";
          interval = 15;
          on-click = "${vpnToggle}";
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
        #custom-favorites,
        #custom-weather,
        #tools,
        #workspaces,
        #window,
        #clock,
        #mpris,
        #stats,
        #audio,
        #connections,
        #tray,
        #custom-notification,
        #session {
          background: alpha(@crust, 0.78);
          border: 1px solid alpha(@surface2, 0.35);
          border-radius: 14px;
          padding: 0 14px;
        }

        #custom-launcher {
          color: @accent;
          font-size: 20px;
          padding: 0 15px 0 12px;
        }

        #custom-favorites {
          color: @yellow;
          font-size: 17px;
        }

        #custom-weather {
          color: @sky;
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

        #disk,
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

        #disk {
          color: @mauve;
        }

        #custom-vpn,
        #power-profiles-daemon {
          padding: 0 7px;
          color: @lavender;
        }

        #custom-vpn.disconnected {
          color: @overlay1;
        }

        #custom-vpn.connected {
          color: @green;
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

        #custom-tools,
        #custom-screenshot,
        #custom-clipboard,
        #custom-colorpicker,
        #custom-wallpaper,
        #custom-nightlight,
        #custom-widgets {
          color: @teal;
          font-size: 16px;
          padding: 0 7px;
        }

        #custom-power,
        #custom-lock,
        #custom-logout,
        #custom-reboot,
        #custom-shutdown {
          color: @red;
          font-size: 16px;
          padding: 0 7px;
        }

        #custom-lock {
          color: @blue;
        }

        #custom-logout {
          color: @yellow;
        }

        #custom-reboot {
          color: @peach;
        }

        #custom-tools:hover,
        #custom-screenshot:hover,
        #custom-clipboard:hover,
        #custom-colorpicker:hover,
        #custom-wallpaper:hover,
        #custom-nightlight:hover,
        #custom-widgets:hover,
        #custom-lock:hover,
        #custom-logout:hover,
        #custom-reboot:hover,
        #custom-shutdown:hover {
          color: @text;
        }
      '';
    };
  };
}
