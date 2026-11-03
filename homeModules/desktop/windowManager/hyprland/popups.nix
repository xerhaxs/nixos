{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:

let
  glyph = import ./glyphs.nix { inherit lib; };

  eww = config.programs.eww.package;

  palette =
    (lib.importJSON "${config.catppuccin.sources.palette}/palette.json")
    .${config.catppuccin.flavor}.colors;
  color = name: palette.${name}.hex;
  accent = color config.catppuccin.accent;

  icons = lib.mapAttrs (_: glyph) {
    audio = "F057E";
    battery = "F0079";
    bluetooth = "F00AF";
    lock = "F033E";
    search = "F0349";
    wifi = "F05A9";
    back10 = "F045F";
    brightness = "F00E0";
    forward10 = "F0211";
    mic = "F036C";
    micoff = "F036D";
    muted = "F0581";
    next = "F04AD";
    pause = "F03E4";
    play = "F040A";
    previous = "F04AE";
  };

  popupScript = pkgs.writeShellApplication {
    name = "desktop-popup";
    runtimeInputs = [
      eww
      pkgs.jq
    ];
    text = ''
      close() {
        eww update audio_open=false media_open=false calendar_open=false launcher_open=false
        for window in audio-popup media-popup calendar-popup launcher-popup popup-closer; do
          eww close "$window" > /dev/null 2>&1 || true
        done
      }

      name="''${1:-close}"
      active=$(eww active-windows)
      [[ $active == *popup* || $name != close ]] || exit 0
      close
      case "$name" in
        close) ;;
        *)
          [[ $active == *"$name-popup"* ]] && exit 0
          [ "$name" != launcher ] || desktop-launcher prepare
          screen=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
          eww update "''${name}_open=true"
          eww open --screen "$screen" popup-closer || eww open popup-closer
          eww open --screen "$screen" "$name-popup" || eww open "$name-popup"
          ;;
      esac
    '';
  };

  audioScript = pkgs.writeShellApplication {
    name = "desktop-audio";
    runtimeInputs = [
      pkgs.jq
      pkgs.pulseaudio
    ];
    text = ''
      export LC_ALL=C

      state() {
        jq -nc \
          --arg default_sink "$(pactl get-default-sink)" \
          --arg default_source "$(pactl get-default-source)" \
          --argjson sinks "$(pactl -f json list sinks)" \
          --argjson sources "$(pactl -f json list sources)" \
          --argjson apps "$(pactl -f json list sink-inputs)" '
            def volume: .volume | to_entries[0].value.value_percent | rtrimstr("%") | tonumber;
            def device($default): {
              name, label: .description, volume: volume, muted: .mute, active: (.name == $default)
            };
            ($sinks | map(device($default_sink))) as $sink_list
            | ($sources | map(select(.monitor_source == "") | device($default_source))) as $source_list
            | {
                sink: ($sink_list | map(select(.active)) | first // {}),
                sinks: $sink_list,
                source: ($source_list | map(select(.active)) | first // {}),
                sources: $source_list,
                apps: ($apps | map({
                  id: .index,
                  name: (.properties["application.name"] // .properties["media.name"] // "Application"),
                  volume: volume,
                  muted: .mute
                }))
              }'
      }

      state
      while read -r _; do
        while read -r -t 0.15 _; do :; done
        state
      done < <(pactl subscribe)
    '';
  };

  brightnessScript = pkgs.writeShellApplication {
    name = "desktop-brightness";
    runtimeInputs = with pkgs; [
      brightnessctl
      coreutils
      ddcutil
      gawk
      util-linux
    ];
    text = ''
      backlight=$(ls /sys/class/backlight 2> /dev/null || true)

      if [ "''${1:-get}" = "get" ]; then
        if [ -n "$backlight" ]; then
          value=$(brightnessctl -m | cut -d, -f4 | tr -d %)
        else
          value=$(ddcutil getvcp 10 --brief 2> /dev/null | awk '$2 == "10" { print int($4 * 100 / $5) }' || true)
        fi
        if [ -n "$value" ]; then
          printf '{"present":true,"value":%s}\n' "$value"
        else
          printf '{"present":false,"value":0}\n'
        fi
        exit 0
      fi

      value="''${2%.*}"
      if [ -n "$backlight" ]; then
        brightnessctl -q set "$value%"
        exit 0
      fi

      # DDC takes about a second, while the slider moves only the last value matters.
      target="$XDG_RUNTIME_DIR/desktop-brightness"
      printf '%s' "$value" > "$target"
      exec 9> "$target.lock"
      flock -n 9 || exit 0
      applied=""
      while [ "$(cat "$target")" != "$applied" ]; do
        applied=$(cat "$target")
        ddcutil setvcp 10 "$applied" > /dev/null 2>&1 || true
      done
    '';
  };

  mediaScript = pkgs.writeShellApplication {
    name = "desktop-media";
    runtimeInputs = with pkgs; [
      coreutils
      curl
      jq
      playerctl
    ];
    text = ''
      format=$(printf '%s\037' '{{status}}' '{{title}}' '{{artist}}' '{{album}}' '{{mpris:artUrl}}' '{{position}}' '{{mpris:length}}')
      line=$(playerctl metadata --format "$format" 2> /dev/null || true)
      if [ -z "$line" ]; then
        printf '{"present":false,"status":"","title":"","artist":"","album":"","art":"","position":0,"length":0,"position_text":"","length_text":""}\n'
        exit 0
      fi

      IFS=$'\037' read -r status title artist album url position length _ <<< "$line" || true
      art=""
      case "$url" in
        file://*) art="''${url#file://}" ;;
        http*)
          art="$XDG_RUNTIME_DIR/desktop-media-$(printf '%s' "$url" | sha1sum | cut -d' ' -f1)"
          [ -s "$art" ] || curl -fsS --max-time 5 -o "$art" "$url" || art=""
          ;;
      esac

      clock() { date -u -d "@$1" +%-M:%S; }
      position=$(( ''${position:-0} / 1000000 ))
      length=$(( ''${length:-0} / 1000000 ))
      jq -nc --arg status "$status" --arg title "$title" --arg artist "$artist" --arg album "$album" \
        --arg art "$art" --argjson position "$position" --argjson length "$length" \
        --arg position_text "$(clock "$position")" --arg length_text "$(clock "$length")" \
        '$ARGS.named + {present: true}'
    '';
  };

  calendarScript = pkgs.writeShellApplication {
    name = "desktop-calendar";
    runtimeInputs = [
      config.programs.khal.package
      eww
      pkgs.coreutils
      pkgs.jq
    ];
    text = ''
      export LC_ALL=en_US.UTF-8

      events() {
        khal list --json title --json start-date --json start-time --json end-time --json all-day "$@" 2> /dev/null \
          | jq -sc 'add // [] | map({
              when: ((.["start-date"] | strptime("%Y-%m-%d") | mktime | strftime("%a, %b %d"))
                + (if .["all-day"] == "True" then "" else "  " + .["start-time"] + " - " + .["end-time"] end)),
              title
            })' || printf '[]\n'
      }

      if [ "''${1:-}" = "--day" ]; then
        # eww passes the month of GTK, which counts from 0.
        day=$(printf '%04d-%02d-%02d' "$4" "$(( $3 + 1 ))" "$2")
        eww update events="$(events "$day" 1d)"
      else
        events today 14d
      fi
    '';
  };

  calendarSync = pkgs.writeShellApplication {
    name = "desktop-calendar-sync";
    runtimeInputs = [ config.programs.vdirsyncer.package ];
    text = ''
      yes | vdirsyncer discover || true
      vdirsyncer sync
    '';
  };

  launcherScript = pkgs.writeShellApplication {
    name = "desktop-launcher";
    runtimeInputs = with pkgs; [
      bluez
      cliphist
      coreutils
      eww
      findutils
      gawk
      gtk3
      jq
      networkmanager
      pulseaudio
      util-linux
      wl-clipboard
    ];
    text = ''
      export LC_ALL=C.UTF-8
      apps="''${XDG_CACHE_HOME:-$HOME/.cache}/desktop-apps.json"
      recent="''${XDG_STATE_HOME:-$HOME/.local/state}/desktop-launcher/recent"
      perRow=7

      # One pass over all desktop files and icons, searching them on every key press would be too slow.
      index() {
        IFS=: read -ra dirs <<< "''${XDG_DATA_HOME:-$HOME/.local/share}:''${XDG_DATA_DIRS:-/run/current-system/sw/share}"
        icons=()
        files=()
        for dir in "''${dirs[@]}"; do
          [ -d "$dir/applications" ] && files+=("$dir/applications")
          for theme in ${lib.escapeShellArg config.gtk.iconTheme.name} Papirus-Dark Papirus breeze-dark breeze hicolor; do
            for size in 48x48/apps 64x64/apps apps/48 scalable/apps 128x128/apps 256x256/apps 512x512/apps 1024x1024/apps; do
              [ -d "$dir/icons/$theme/$size" ] && icons+=("$dir/icons/$theme/$size")
            done
          done
          [ -d "$dir/pixmaps" ] && icons+=("$dir/pixmaps")
        done
        {
          find -L "''${icons[@]}" -maxdepth 1 \( -name '*.svg' -o -name '*.png' \) 2> /dev/null | sed 's/^/icon\t/'
          find -L "''${files[@]}" -maxdepth 1 -name '*.desktop' 2> /dev/null | sed 's/^/app\t/'
        } | awk -F'\t' '
          function clean(text) { gsub(/[\t\\"]/, "", text); return text }
          $1 == "icon" {
            name = $2; sub(/.*\//, "", name); sub(/\.[a-z]+$/, "", name)
            if (!(name in path)) path[name] = $2
            next
          }
          {
            id = $2; sub(/.*\//, "", id); sub(/\.desktop$/, "", id)
            if (id in seen) next
            seen[id] = 1
            label = ""; icon = ""; hidden = 0; section = ""
            while ((getline line < $2) > 0) {
              if (line ~ /^\[/) section = line
              if (section != "[Desktop Entry]") continue
              if (line ~ /^Name=/ && label == "") label = substr(line, 6)
              if (line ~ /^Icon=/ && icon == "") icon = substr(line, 6)
              if (line ~ /^(NoDisplay|Hidden)=true/) hidden = 1
            }
            close($2)
            if (hidden || label == "") next
            file = (icon ~ /^\//) ? icon : path[icon]
            if (file == "") file = path["application-x-executable"]
            printf "%s\t%s\t%s\n", id, clean(label), file
          }' \
          | jq -Rsc 'split("\n") | map(select(length > 0) | split("\t") | {id: .[0], name: .[1], path: (.[2] // "")})
              | sort_by(.name | ascii_downcase)' > "$apps.tmp"
        mv "$apps.tmp" "$apps"
      }

      find_apps() {
        jq -c --arg query "$1" '
          ($query | ascii_downcase) as $needle
          | map(select(.name | ascii_downcase | contains($needle)))
          | sort_by(.name | ascii_downcase | startswith($needle) | not)' "$apps"
      }

      rows() { jq -c --argjson size "$perRow" '[range(0; length; $size) as $i | .[$i:$i + $size]]'; }

      launch() {
        mkdir -p "$(dirname "$recent")"
        { printf '%s\n' "$1"; grep -vxF "$1" "$recent" 2> /dev/null || true; } | head -n "$perRow" > "$recent.tmp"
        mv "$recent.tmp" "$recent"
        desktop-popup close
        setsid -f gtk-launch "$1" > /dev/null 2>&1 < /dev/null
      }

      state() {
        muted=$(pactl get-sink-mute @DEFAULT_SINK@ 2> /dev/null | awk '{ print ($2 == "yes") }')
        mic_muted=$(pactl get-source-mute @DEFAULT_SOURCE@ 2> /dev/null | awk '{ print ($2 == "yes") }')
        bluetooth=Off
        if bluetoothctl show 2> /dev/null | grep -q 'Powered: yes'; then
          bluetooth=$(bluetoothctl devices Connected 2> /dev/null | head -n 1 | cut -d' ' -f3-)
          bluetooth=''${bluetooth:-On}
        fi
        wifi=$(nmcli radio wifi 2> /dev/null || true)
        network=$(nmcli -t -f NAME connection show --active 2> /dev/null | grep -v '^lo$' | head -n 1 || true)
        autolock=$(systemctl --user is-active hypridle.service 2> /dev/null || true)
        battery=""
        for supply in /sys/class/power_supply/BAT*; do
          [ -r "$supply/capacity" ] && battery="$(cat "$supply/capacity")% $(cat "$supply/status")"
        done
        clipboard=$(cliphist list 2> /dev/null | head -n 5 | jq -Rsc 'split("\n") | map(select(length > 0) | split("\t") | {id: .[0], text: (.[1:] | join(" "))})' || true)
        recent_apps='[]'
        if [ -r "$recent" ] && [ -r "$apps" ]; then
          recent_apps=$(jq -Rsc 'split("\n") | map(select(length > 0))' "$recent" | jq -c --slurpfile all "$apps" 'map(. as $id | $all[0][] | select(.id == $id))' | rows)
        fi
        jq -nc --argjson muted "''${muted:-0}" --argjson mic "''${mic_muted:-0}" --arg bluetooth "$bluetooth" \
          --arg wifi "$wifi" --arg network "''${network:-Disconnected}" --arg autolock "$autolock" --arg battery "$battery" \
          --argjson clipboard "''${clipboard:-[]}" --argjson recent "$recent_apps" \
          '{muted: ($muted == 1), mic_muted: ($mic == 1), bluetooth: $bluetooth, wifi: ($wifi == "enabled"),
            network: $network, autolock: ($autolock == "active"), battery: $battery, clipboard: $clipboard, recent: $recent}'
      }

      case "''${1:-state}" in
        prepare)
          [ -s "$apps" ] || index
          [ -z "$(find "$apps" -mmin +60 2> /dev/null)" ] || index &
          eww update search="" launcher_results='[]' launcher_state="$(state)"
          ;;
        state) state ;;
        favorites) favorites-list --json | rows ;;
        search)
          eww update search="$2" launcher_results="$(find_apps "$2" | jq -c '.[:14]' | rows)"
          ;;
        accept)
          first=$(find_apps "$2" | jq -r '.[0].id // empty')
          [ -z "$first" ] || launch "$first"
          ;;
        launch) launch "$2" ;;
        clip)
          printf '%s\t' "$2" | cliphist decode | wl-copy
          desktop-popup close
          ;;
        toggle)
          case "$2" in
            mute) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
            mic) pactl set-source-mute @DEFAULT_SOURCE@ toggle ;;
            bluetooth)
              if bluetoothctl show | grep -q 'Powered: yes'; then bluetoothctl power off; else bluetoothctl power on; fi
              ;;
            wifi)
              if [ "$(nmcli radio wifi)" = enabled ]; then nmcli radio wifi off; else nmcli radio wifi on; fi
              ;;
            autolock)
              if systemctl --user is-active --quiet hypridle.service; then
                systemctl --user stop hypridle.service
              else
                systemctl --user start hypridle.service
              fi
              ;;
          esac > /dev/null
          eww update launcher_state="$(state)"
          ;;
      esac
    '';
  };

  commands = {
    brightness = lib.getExe brightnessScript;
    calendar = lib.getExe calendarScript;
    launcher = lib.getExe launcherScript;
    mixer = "${pkgs.pavucontrol}/bin/pavucontrol";
    pactl = "${pkgs.pulseaudio}/bin/pactl";
    playerctl = "${pkgs.playerctl}/bin/playerctl";
    popup = lib.getExe popupScript;
  };

  prelude = ''
    (defvar cmd '${builtins.toJSON commands}')
    (defvar pi '${builtins.toJSON icons}')
    (defvar audio_open false)
    (defvar media_open false)
    (defvar calendar_open false)
    (defvar launcher_open false)
    (defvar search "")
    (defvar launcher_results "[]")
    (defpoll favorite_rows :interval "3600s" :initial "[]" "${lib.getExe launcherScript} favorites")
    (defpoll launcher_state :interval "3s" :run-while launcher_open :initial '{"muted":false,"mic_muted":false,"bluetooth":"Off","wifi":false,"network":"","autolock":false,"battery":"","clipboard":[],"recent":[]}' "${lib.getExe launcherScript} state")
    (deflisten audio :initial '{"sink":{"muted":false,"volume":0,"label":""},"sinks":[],"source":{"muted":false,"volume":0,"label":""},"sources":[],"apps":[]}' "${lib.getExe audioScript}")
    (defpoll brightness :interval "10s" :run-while audio_open :initial '{"present":false,"value":0}' "${lib.getExe brightnessScript} get")
    (defpoll media :interval "1s" :run-while media_open :initial '{"present":false,"status":"","title":"","artist":"","album":"","art":"","position":0,"length":0,"position_text":"","length_text":""}' "${lib.getExe mediaScript}")
    (defpoll events :interval "300s" :run-while calendar_open :initial "[]" "${lib.getExe calendarScript}")
  '';
in

{
  options.homeManager = {
    desktop.windowManager.hyprland.popups = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable the popups of Waybar (calendar with Radicale events, sound and brightness, media player).";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.windowManager.hyprland.popups.enable {
    home.packages = [
      launcherScript
      popupScript
    ];

    programs.eww = {
      yuckConfig = prelude + builtins.readFile ./config/eww-popups.yuck;
      scssConfig = ''
        .popup {
          padding: 18px 20px;
          background-color: rgba(${color "crust"}, 0.92);
          border: 1px solid rgba(${color "surface2"}, 0.45);
          border-radius: 20px;
        }

        .popup-icon { color: ${accent}; font-size: 20px; }
        .popup-heading { font-size: 16px; font-weight: 700; }
        .popup-section { color: ${color "subtext0"}; font-size: 13px; font-weight: 700; }
        .popup-empty { color: ${color "subtext0"}; padding: 8px 0; }

        .slider-icon { color: ${accent}; font-size: 18px; min-width: 24px; }
        .slider-label { color: ${color "subtext1"}; font-size: 13px; }
        .slider-value { font-weight: 700; font-size: 13px; }

        .popup-scale trough {
          min-height: 8px;
          margin: 6px 0;
          background-color: rgba(${color "surface1"}, 0.7);
          border-radius: 4px;
        }
        .popup-scale highlight { background-color: ${accent}; border-radius: 4px; }
        .popup-scale slider {
          min-width: 16px;
          min-height: 16px;
          margin: -6px;
          background-color: ${color "text"};
          border-radius: 8px;
        }

        .device { padding: 6px 10px; border-radius: 10px; color: ${color "subtext1"}; font-size: 13px; }
        .device:hover { background-color: rgba(${color "surface1"}, 0.7); }
        .device.active { color: ${accent}; font-weight: 700; }

        .popup-button {
          padding: 8px 12px;
          border-radius: 12px;
          background-color: rgba(${color "surface1"}, 0.6);
          color: ${color "subtext1"};
        }
        .popup-button:hover { background-color: rgba(${color "surface2"}, 0.8); }

        .media-cover {
          min-width: 96px;
          min-height: 96px;
          border-radius: 14px;
          background-color: rgba(${color "surface1"}, 0.7);
          background-size: cover;
          background-position: center;
        }
        .media-title { font-size: 16px; font-weight: 700; }
        .media-artist { color: ${color "subtext1"}; }
        .media-album { color: ${color "subtext0"}; font-size: 13px; }
        .media-time { color: ${color "subtext0"}; font-size: 12px; }
        .media-controls button { font-size: 24px; padding: 4px 8px; border-radius: 12px; }
        .media-controls button:hover { background-color: rgba(${color "surface1"}, 0.7); }
        .media-controls .media-play { color: ${accent}; font-size: 34px; }

        .calendar-day { color: ${accent}; font-size: 16px; font-weight: 700; }
        .month {
          padding: 6px;
          font-size: 15px;
          color: ${color "text"};
        }
        .month:selected {
          background-color: ${accent};
          color: ${color "crust"};
          border-radius: 8px;
        }
        .month.header { color: ${accent}; font-weight: 700; }
        .month.button { color: ${accent}; }
        .month:indeterminate { color: ${color "overlay0"}; }

        .event {
          padding: 8px 12px;
          border-radius: 12px;
          background-color: rgba(${color "surface0"}, 0.7);
        }
        .event-time { color: ${accent}; font-size: 12px; font-weight: 700; }
        .event-title { font-size: 14px; }

        .launcher { padding: 22px 24px; }
        .search {
          padding: 12px 18px;
          background-color: rgba(${color "surface0"}, 0.75);
          border-radius: 14px;
        }
        .search-input { font-size: 16px; caret-color: ${accent}; }
        .app-tile { padding: 10px 2px; border-radius: 14px; }
        .app-tile:hover { background-color: rgba(${color "surface1"}, 0.7); }
        .app-name { font-size: 12px; color: ${color "subtext1"}; }
        .toggle-tile {
          padding: 10px 14px;
          border-radius: 14px;
          background-color: rgba(${color "surface0"}, 0.7);
        }
        .toggle-tile:hover { background-color: rgba(${color "surface1"}, 0.8); }
        .toggle-tile.active { background-color: rgba(${color "surface1"}, 0.9); }
        .toggle-tile .toggle-icon { color: ${color "overlay1"}; }
        .toggle-tile.active .toggle-icon { color: ${accent}; }
        .toggle-icon { font-size: 18px; color: ${accent}; }
        .toggle-label { font-weight: 700; font-size: 13px; }
        .toggle-detail { color: ${color "subtext0"}; font-size: 12px; }
        .clip { padding: 5px 10px; border-radius: 10px; font-size: 12px; color: ${color "subtext1"}; }
        .clip:hover { background-color: rgba(${color "surface1"}, 0.7); }
      '';
    };

    programs.khal = {
      enable = true;
      locale = {
        dateformat = "%Y-%m-%d";
        datetimeformat = "%Y-%m-%d %H:%M";
        longdateformat = "%Y-%m-%d";
        longdatetimeformat = "%Y-%m-%d %H:%M";
        timeformat = "%H:%M";
      };
    };

    programs.vdirsyncer.enable = true;

    accounts.calendar.basePath = ".local/share/calendars";

    # The password is the plain text entry of the user in the htpasswd file of Radicale.
    accounts.calendar.accounts.radicale = {
      local = {
        type = "filesystem";
        fileExt = ".ics";
      };
      remote = {
        type = "caldav";
        url = "https://radicale.${osConfig.nixos.site.homeDomain}/";
        userName = config.home.username;
        passwordCommand = [
          "${pkgs.gawk}/bin/awk"
          "-F:"
          "-v"
          "user=${config.home.username}"
          "$1 == user { print $2 }"
          osConfig.sops.secrets."radicale/htpasswd".path
        ];
      };
      vdirsyncer = {
        enable = true;
        collections = [
          "from a"
          "from b"
        ];
        conflictResolution = "remote wins";
      };
      khal = {
        enable = true;
        type = "discover";
        readOnly = true;
      };
    };

    systemd.user.services.desktop-calendar-sync = {
      Unit.Description = "Sync the calendars from Radicale";
      Service = {
        Type = "oneshot";
        ExecStart = lib.getExe calendarSync;
      };
    };

    systemd.user.timers.desktop-calendar-sync = {
      Unit.Description = "Sync the calendars from Radicale";
      Timer = {
        OnStartupSec = "1min";
        OnUnitActiveSec = "15min";
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
