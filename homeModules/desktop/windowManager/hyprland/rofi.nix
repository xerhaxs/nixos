{
  config,
  lib,
  pkgs,
  ...
}:

let
  glyph = import ./glyphs.nix { inherit lib; };

  rofi = config.programs.rofi.finalPackage;

  palette =
    (lib.importJSON "${config.catppuccin.sources.palette}/palette.json")
    .${config.catppuccin.flavor}.colors;
  accent = palette.${config.catppuccin.accent}.hex;

  # Prints id, name and icon of the favorites, entries of uninstalled applications are skipped.
  favoritesList = pkgs.writeShellApplication {
    name = "favorites-list";
    runtimeInputs = [ pkgs.jq ];
    text = ''
      ids=(${lib.escapeShellArgs config.homeManager.desktop.favorites})
      IFS=: read -ra dirs <<< "''${XDG_DATA_HOME:-$HOME/.local/share}:''${XDG_DATA_DIRS:-/run/current-system/sw/share}"

      list() {
        for id in "''${ids[@]}"; do
          for dir in "''${dirs[@]}"; do
            file="$dir/applications/$id.desktop"
            [ -f "$file" ] || continue
            name=""
            icon=""
            while IFS='=' read -r key value; do
              case "$key" in
                Name) [ -n "$name" ] || name=$value ;;
                Icon) [ -n "$icon" ] || icon=$value ;;
              esac
            done < "$file"
            printf '%s\t%s\t%s\n' "$id" "$name" "$icon"
            break
          done
        done
      }

      # Some icons only exist in large sizes and GTK ignores the requested size, so the dock uses files.
      icon_file() {
        case "$1" in
          /*)
            printf '%s\n' "$1"
            return
            ;;
        esac
        for dir in "''${dirs[@]}"; do
          [ -d "$dir/icons" ] || continue
          for theme in ${lib.escapeShellArg config.gtk.iconTheme.name} Papirus-Dark Papirus breeze-dark breeze hicolor; do
            [ -d "$dir/icons/$theme" ] || continue
            for size in 48x48/apps 64x64/apps apps/48 scalable/apps 128x128/apps 256x256/apps 512x512/apps 1024x1024/apps; do
              for extension in svg png; do
                if [ -f "$dir/icons/$theme/$size/$1.$extension" ]; then
                  printf '%s\n' "$dir/icons/$theme/$size/$1.$extension"
                  return
                fi
              done
            done
          done
        done
      }

      if [ "''${1:-}" = "--json" ]; then
        list | while IFS=$'\t' read -r id name icon; do
          printf '%s\t%s\t%s\n' "$id" "$name" "$(icon_file "$icon")"
        done | jq -Rsc 'split("\n") | map(select(length > 0) | split("\t") | select((.[2] // "") != "") | {id: .[0], name: .[1], path: .[2]})'
      else
        list
      fi
    '';
  };

  # rofi script mode, rofi calls it again with the selected entry in ROFI_INFO.
  favoritesMode = pkgs.writeShellApplication {
    name = "favorites-mode";
    runtimeInputs = [
      favoritesList
      pkgs.gtk3
      pkgs.util-linux
    ];
    text = ''
      if [ -n "''${ROFI_INFO:-}" ]; then
        setsid -f gtk-launch "$ROFI_INFO" > /dev/null 2>&1 < /dev/null
        exit 0
      fi
      favorites-list | while IFS=$'\t' read -r id name icon; do
        printf '%s\0icon\x1f%s\x1finfo\x1f%s\n' "$name" "$icon" "$id"
      done
    '';
  };

  entry = icon: label: "${glyph icon}  ${label}";

  # One bash function per menu, an action is a line of bash.
  menu =
    {
      name,
      title,
      items,
      back ? true,
    }:
    let
      labels = lib.optional back (entry "F004D" "Back") ++ map (item: entry item.icon item.label) items;
    in
    ''
      ${name}() {
        choice=$(printf '%s\n' ${lib.escapeShellArgs labels} | pick ${lib.escapeShellArg title} ${toString (builtins.length labels)}) || exit 0
        case "$choice" in
          ${lib.optionalString back "${lib.escapeShellArg (entry "F004D" "Back")}) main ;;"}
          ${lib.concatMapStringsSep "\n    " (
            item: "${lib.escapeShellArg (entry item.icon item.label)}) ${item.action} ;;"
          ) items}
        esac
      }
    '';

  menus = [
    {
      name = "main";
      title = "Quick menu";
      back = false;
      items = [
        {
          icon = "F04CE";
          label = "Favorites";
          action = "open_rofi -show favorites";
        }
        {
          icon = "F003B";
          label = "Applications";
          action = "open_rofi -show drun";
        }
        {
          icon = "F0306";
          label = "KeePassXC";
          action = "run keepassxc";
        }
        {
          icon = "F05B3";
          label = "Open windows";
          action = "open_rofi -show window";
        }
        {
          icon = "F0147";
          label = "Clipboard history";
          action = "clipboard";
        }
        {
          icon = "F00EC";
          label = "Calculator";
          action = "open_rofi -show calc -modi calc -no-show-match -no-sort";
        }
        {
          icon = "F0100";
          label = "Screenshot";
          action = "screenshot";
        }
        {
          icon = "F057E";
          label = "Audio";
          action = "audio";
        }
        {
          icon = "F0318";
          label = "Network";
          action = "network";
        }
        {
          icon = "F00AF";
          label = "Bluetooth";
          action = "run rofi-bluetooth";
        }
        {
          icon = "F03D8";
          label = "Appearance";
          action = "appearance";
        }
        {
          icon = "F0493";
          label = "System";
          action = "system";
        }
        {
          icon = "F05D1";
          label = "Power profile";
          action = "profile";
        }
        {
          icon = "F033E";
          label = "Toggle auto lock";
          action = "autolock";
        }
        {
          icon = "F0425";
          label = "Session";
          action = "run power-menu";
        }
      ];
    }
    {
      name = "screenshot";
      title = "Screenshot";
      items = [
        {
          icon = "F0100";
          label = "Select region";
          action = "run flameshot gui";
        }
        {
          icon = "F0379";
          label = "Current screen to clipboard";
          action = "run flameshot screen --clipboard";
        }
        {
          icon = "F0379";
          label = "All screens to clipboard";
          action = "run flameshot full --clipboard";
        }
        {
          icon = "F051F";
          label = "Select region in 5 seconds";
          action = "run flameshot gui --delay 5000";
        }
      ];
    }
    {
      name = "appearance";
      title = "Appearance";
      items = [
        {
          icon = "F02E9";
          label = "Choose wallpaper";
          action = "run waypaper";
        }
        {
          icon = "F049D";
          label = "Random wallpaper";
          action = "systemctl --user start wallpaper-random.service";
        }
        {
          icon = "F0594";
          label = "Toggle night light";
          action = "nightlight";
        }
        {
          icon = "F072C";
          label = "Toggle desktop widgets";
          action = "run desktop-widgets toggle";
        }
        {
          icon = "F020A";
          label = "Pick a color";
          action = "run hyprpicker --autocopy";
        }
      ];
    }
    {
      name = "system";
      title = "System";
      items = [
        {
          icon = "F04C5";
          label = "System monitor";
          action = "run pypr toggle monitor";
        }
        {
          icon = "F009A";
          label = "Notifications";
          action = "run swaync-client --toggle-panel --skip-wait";
        }
        {
          icon = "F030C";
          label = "Keybindings";
          action = "keybindings";
        }
      ];
    }
    {
      name = "profile";
      title = "Power profile";
      items = [
        {
          icon = "F04C5";
          label = "Performance";
          action = "powerprofilesctl set performance";
        }
        {
          icon = "F05D1";
          label = "Balanced";
          action = "powerprofilesctl set balanced";
        }
        {
          icon = "F032A";
          label = "Power saver";
          action = "powerprofilesctl set power-saver";
        }
      ];
    }
  ];

  # Lua binds report no readable name through hyprctl binds.
  keybindingList = pkgs.writeText "keybindings" ''
    Super + Return|Terminal
    Super + E|File manager
    Super + R / Space|Applications
    Super + D|Favorites
    Super + X|Quick menu
    Super + V|Clipboard history
    Super + .|Calculator
    Super + C|Pick a color
    Super + N|Notifications
    Super + W|Choose wallpaper
    Super + Shift + W|Random wallpaper
    Super + B|System monitor
    Super + Shift + B|Toggle desktop widgets
    Super + L|Lock
    Super + Shift + E|Power menu
    Super + Shift + Q|Log out
    Super + `|Dropdown terminal
    Super + A|Volume mixer
    Super + Z|Zoom
    Super + Tab|Workspace overview
    Print|Screenshot of a region
    Shift + Print|Current screen to clipboard
    Super + Print|All screens to clipboard
    Super + Q|Close window
    Super + F|Toggle floating
    Super + Shift + F|Fullscreen
    Super + M|Maximize
    Super + P|Pseudo tile
    Super + J|Toggle split
    Super + K|Pin window
    Super + Arrow keys|Move focus
    Super + Shift + Arrow keys|Move window
    Super + 1 to 0|Go to workspace
    Super + Shift + 1 to 0|Move window to workspace
    Super + S|Toggle scratch workspace
    Super + Shift + S|Move window to scratch workspace
    Super + Shift + M|Mute microphone
  '';

  quickMenu = pkgs.writeShellApplication {
    name = "quick-menu";
    runtimeInputs = [
      pkgs.cliphist
      pkgs.libnotify
      pkgs.jq
      pkgs.networkmanagerapplet
      pkgs.pulseaudio
      pkgs.util-linux
      pkgs.wl-clipboard
      rofi
    ];
    text = ''
      list_theme='window { width: 460px; } listview { columns: 1; lines: 12; fixed-height: false; }'

      run() { setsid -f "$@" > /dev/null 2>&1 < /dev/null; }
      open_rofi() { run rofi "$@" -show-icons; }
      pick() { rofi -dmenu -i -no-custom -p "$1" -l "$2" -theme-str "$list_theme"; }
      nightlight() { toggle_unit hyprsunset.service; }

      autolock() {
        toggle_unit hypridle.service
        if systemctl --user is-active --quiet hypridle.service; then
          notify-send "Auto lock on" "Lock after 5 minutes, standby after 30 minutes"
        else
          notify-send "Auto lock off" "No lock and no standby until it is turned on again"
        fi
      }

      toggle_unit() {
        if systemctl --user is-active --quiet "$1"; then
          systemctl --user stop "$1"
        else
          systemctl --user start "$1"
        fi
      }

      clipboard() {
        selection=$(cliphist list | rofi -dmenu -i -p Clipboard) || exit 0
        printf '%s' "$selection" | cliphist decode | wl-copy
      }

      audio() {
        back=${lib.escapeShellArg (entry "F004D" "Back")}
        mixer=${lib.escapeShellArg (entry "F07A2" "Open mixer")}
        mute=${lib.escapeShellArg (entry "F036D" "Toggle microphone mute")}
        current=$(pactl get-default-sink)
        sinks=$(pactl -f json list sinks | jq -r --arg current "$current" \
          '.[] | "\(if .name == $current then "${glyph "F0133"}" else "${glyph "F04DD"}" end)  \(.description)\t\(.name)"')
        choice=$( { printf '%s\n%s\n%s\n' "$back" "$mixer" "$mute"; cut -f1 <<< "$sinks"; } | pick "Audio output" "$(( $(wc -l <<< "$sinks") + 3 ))") || exit 0
        case "$choice" in
          "$back") main ;;
          "$mixer") run pypr toggle volume ;;
          "$mute") wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle ;;
          *)
            sink=$(grep -F "$choice" <<< "$sinks" | cut -f2)
            pactl set-default-sink "$sink"
            ;;
        esac
      }

      network() {
        back=${lib.escapeShellArg (entry "F004D" "Back")}
        editor=${lib.escapeShellArg (entry "F0493" "Connection editor")}
        tui=${lib.escapeShellArg (entry "F018D" "Terminal interface")}
        vpn=${lib.escapeShellArg (entry "F0565" "Toggle Mullvad VPN")}
        items=("$back" "$editor" "$tui")
        if command -v mullvad > /dev/null; then
          items+=("$vpn")
        fi
        choice=$(printf '%s\n' "''${items[@]}" | pick "$(nmcli -t -f STATE general) - Network" "''${#items[@]}") || exit 0
        case "$choice" in
          "$back") main ;;
          "$editor") run nm-connection-editor ;;
          "$tui") run kitty --class nmtui -e nmtui ;;
          "$vpn")
            status=$(mullvad status)
            case "$status" in
              Connected*) mullvad disconnect ;;
              *) mullvad connect ;;
            esac
            ;;
        esac
      }

      keybindings() {
        column -t -s '|' < ${keybindingList} \
          | rofi -dmenu -i -p Keybindings -l 16 -theme-str 'window { width: 860px; } listview { columns: 1; lines: 16; fixed-height: true; }' > /dev/null || true
      }

      ${lib.concatMapStrings menu menus}

      "''${1:-main}"
    '';
  };

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
      placeholder: "Search";
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

    home.packages = [
      favoritesList
      pkgs.rofi-bluetooth
      quickMenu
    ];

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
        modi = "favorites:${lib.getExe favoritesMode},drun,run,window,calc";
        show-icons = true;
        icon-theme = config.gtk.iconTheme.name;
        drun-display-format = "{name}";
        drun-use-desktop-cache = true;
        drun-reload-desktop-cache = true;
        display-favorites = "Favorites";
        display-drun = "Apps";
        display-run = "Run";
        display-window = "Windows";
        display-calc = "Calc";
      };
    };
  };
}
