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
    calendar = "F00ED";
    clock = "F0150";
    cpu = "F0EE0";
    disk = "F02CA";
    down = "F01DA";
    gpu = "F08AE";
    humidity = "F058E";
    list = "F0279";
    load = "F04C5";
    memory = "F035B";
    network = "F0318";
    power = "F140B";
    pressure = "F029A";
    sunrise = "F059C";
    sunset = "F059B";
    temp = "F050F";
    up = "F0552";
    uv = "F05A8";
    weather = "F0595";
    wind = "F059D";
  };

  weatherCodes =
    let
      entry = text: day: night: {
        inherit text;
        day = glyph day;
        night = glyph night;
      };
      same = text: icon: entry text icon icon;
    in
    pkgs.writeText "weather-codes.json" (
      builtins.toJSON {
        "0" = entry "Clear sky" "F0599" "F0594";
        "1" = entry "Mainly clear" "F0599" "F0594";
        "2" = entry "Partly cloudy" "F0595" "F0F31";
        "3" = same "Overcast" "F0590";
        "45" = same "Fog" "F0591";
        "48" = same "Rime fog" "F0591";
        "51" = same "Light drizzle" "F0597";
        "53" = same "Drizzle" "F0597";
        "55" = same "Heavy drizzle" "F0597";
        "56" = same "Freezing drizzle" "F0597";
        "57" = same "Freezing drizzle" "F0597";
        "61" = same "Light rain" "F0597";
        "63" = same "Rain" "F0596";
        "65" = same "Heavy rain" "F0596";
        "66" = same "Freezing rain" "F0596";
        "67" = same "Freezing rain" "F0596";
        "71" = same "Light snow" "F0598";
        "73" = same "Snow" "F0598";
        "75" = same "Heavy snow" "F0598";
        "77" = same "Snow grains" "F0598";
        "80" = same "Light showers" "F0597";
        "81" = same "Showers" "F0596";
        "82" = same "Heavy showers" "F0596";
        "85" = same "Snow showers" "F0598";
        "86" = same "Snow showers" "F0598";
        "95" = same "Thunderstorm" "F067E";
        "96" = same "Thunderstorm with hail" "F0592";
        "99" = same "Thunderstorm with hail" "F0592";
      }
    );

  emptyWeather = builtins.toJSON {
    ready = false;
    name = "";
    current = { };
    hourly = [ ];
    daily = [ ];
  };

  emptySystem = builtins.toJSON {
    cpu_temp = 0;
    load = "";
    swap = "";
    swap_percent = 0;
    gpu_present = false;
    gpu_busy = 0;
    gpu_temp = 0;
    gpu_power = 0;
    vram = "";
    vram_percent = 0;
    net_down = "";
    net_up = "";
    net_down_bytes = 0;
    disks = [ ];
    processes = [ ];
  };

  desktopWeather = pkgs.writeShellApplication {
    name = "desktop-weather";
    runtimeInputs = with pkgs; [
      coreutils
      curl
      jq
    ];
    text = ''
      export LC_ALL=en_US.UTF-8
      location=${osConfig.sops.secrets."weather-location".path}
      cache="''${XDG_CACHE_HOME:-$HOME/.cache}/desktop-weather.json"

      refresh() {
        [ -f "$location" ] || return 0
        if [ -f "$cache" ] && [ $(( $(date +%s) - $(stat -c %Y "$cache") )) -lt 540 ]; then
          return 0
        fi
        latitude=$(jq -r .latitude "$location")
        longitude=$(jq -r .longitude "$location")
        name=$(jq -r .name "$location")
        forecast=$(curl -fsSG --max-time 20 https://api.open-meteo.com/v1/forecast \
          -d "latitude=$latitude" -d "longitude=$longitude" -d timezone=auto -d forecast_days=7 \
          -d current=temperature_2m,apparent_temperature,relative_humidity_2m,weather_code,wind_speed_10m,wind_direction_10m,surface_pressure,is_day \
          -d hourly=temperature_2m,precipitation_probability,weather_code,is_day \
          -d daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max,sunrise,sunset,uv_index_max) || return 0
        jq -c --arg name "$name" --slurpfile codes ${weatherCodes} '
          def describe($code; $day):
            ($codes[0][$code | tostring] // $codes[0]["3"]) as $entry
            | {text: $entry.text, icon: (if $day == 1 then $entry.day else $entry.night end)};
          def compass:
            ["N", "NE", "E", "SE", "S", "SW", "W", "NW"][((. + 22.5) / 45 | floor) % 8];
          def round0: . + 0.5 | floor;
          . as $data
          | ($data.daily.temperature_2m_min | min) as $low
          | ($data.daily.temperature_2m_max | max) as $high
          | (($high - $low) | if . == 0 then 1 else . end) as $span
          | ($data.hourly.time | map(. >= $data.current.time[0:13]) | index(true) // 0) as $start
          | {
              ready: true,
              name: $name,
              current: (describe($data.current.weather_code; $data.current.is_day) + {
                temp: ($data.current.temperature_2m | round0),
                feels: ($data.current.apparent_temperature | round0),
                humidity: $data.current.relative_humidity_2m,
                wind: ($data.current.wind_speed_10m | round0),
                direction: ($data.current.wind_direction_10m | compass),
                pressure: ($data.current.surface_pressure | round0),
                uv: $data.daily.uv_index_max[0],
                sunrise: $data.daily.sunrise[0][11:16],
                sunset: $data.daily.sunset[0][11:16]
              }),
              hourly: [range(0; 8) | $start + . * 2 | select(. < ($data.hourly.time | length)) as $i
                | describe($data.hourly.weather_code[$i]; $data.hourly.is_day[$i]) + {
                    time: $data.hourly.time[$i][11:16],
                    temp: ($data.hourly.temperature_2m[$i] | round0),
                    rain: ($data.hourly.precipitation_probability[$i] // 0)
                  }],
              daily: [range(0; $data.daily.time | length) as $i
                | describe($data.daily.weather_code[$i]; 1) + {
                    name: (if $i == 0 then "Today" else ($data.daily.time[$i] | strptime("%Y-%m-%d") | mktime | strftime("%a")) end),
                    min: ($data.daily.temperature_2m_min[$i] | round0),
                    max: ($data.daily.temperature_2m_max[$i] | round0),
                    rain: ($data.daily.precipitation_probability_max[$i] // 0),
                    offset: ((($data.daily.temperature_2m_min[$i] - $low) / $span * 100) | round0),
                    width: ((($data.daily.temperature_2m_max[$i] - $data.daily.temperature_2m_min[$i]) / $span * 100 + 6) | round0)
                  }]
            }' <<< "$forecast" > "$cache.tmp" && mv "$cache.tmp" "$cache"
      }

      refresh
      if [ ! -f "$cache" ]; then
        if [ "''${1:-}" = "--bar" ]; then
          printf '{"text":""}\n'
        else
          printf '%s\n' ${lib.escapeShellArg emptyWeather}
        fi
      elif [ "''${1:-}" = "--bar" ]; then
        jq -c '{
          text: "\(.current.icon)  \(.current.temp)°",
          tooltip: ([
            "\(.name): \(.current.text), \(.current.temp)°, feels like \(.current.feels)°",
            "Wind \(.current.wind) km/h \(.current.direction), humidity \(.current.humidity)%",
            "",
            (.daily[] | "\(.name)\t\(.icon)  \(.min)° / \(.max)°   \(.rain)%")
          ] | join("\n"))
        }' "$cache"
      else
        cat "$cache"
      fi
    '';
  };

  desktopSysinfo = pkgs.writeShellApplication {
    name = "desktop-sysinfo";
    runtimeInputs = with pkgs; [
      coreutils
      gawk
      jq
      procps
    ];
    text = ''
      cpu_sensor=""
      gpu_sensor=""
      for hwmon in /sys/class/hwmon/hwmon*; do
        case "$(cat "$hwmon/name")" in
          k10temp | coretemp | zenpower) [ -n "$cpu_sensor" ] || cpu_sensor=$hwmon ;;
          amdgpu) [ -n "$gpu_sensor" ] || gpu_sensor=$hwmon ;;
        esac
      done

      gpu_device=""
      for device in /sys/class/drm/card*/device; do
        if [ -r "$device/gpu_busy_percent" ]; then
          gpu_device=$device
          break
        fi
      done

      celsius() { if [ -r "$1" ]; then echo $(( $(cat "$1") / 1000 )); else echo 0; fi; }
      counters() { awk 'NR > 2 && $1 !~ /^(lo|tun|wg|veth|podman|virbr|docker)/ { rx += $2; tx += $10 } END { printf "%d %d\n", rx, tx }' /proc/net/dev; }
      rate() {
        awk -v bytes="$1" 'BEGIN {
          if (bytes >= 1048576) printf "%.1f MB/s", bytes / 1048576
          else if (bytes >= 1024) printf "%.0f KB/s", bytes / 1024
          else printf "%d B/s", bytes
        }'
      }

      disks='[]'
      processes='[]'
      tick=0
      read -r last_rx last_tx < <(counters)

      while true; do
        if [ $(( tick % 30 )) -eq 0 ]; then
          disks=$(df -B1 --output=target,used,size -x tmpfs -x devtmpfs -x efivarfs -x cifs -x fuse.gvfsd-fuse -x fuse.portal 2>/dev/null \
            | awk 'NR > 1 && $3 > 0 && $1 !~ /^\/(home|persistent|boot|root|etc|var|swap|tmp|secrets)/ && !seen[$2 "/" $3]++ {
                printf "%s\t%.0f\t%.1f / %.0f GiB\n", $1, $2 / $3 * 100, $2 / 1073741824, $3 / 1073741824
              }' \
            | jq -Rsc 'split("\n") | map(select(length > 0) | split("\t") | {mount: .[0], percent: (.[1] | tonumber), text: .[2]})')
        fi
        if [ $(( tick % 2 )) -eq 0 ]; then
          processes=$(ps -eo comm:32,pcpu --sort=-pcpu --no-headers \
            | awk 'NR <= 5 { cpu = $NF; $NF = ""; sub(/ +$/, ""); sub(/^\./, ""); sub(/-wrap(ped)?$/, ""); printf "%s\t%s\n", $0, cpu }' \
            | jq -Rsc 'split("\n") | map(select(length > 0) | split("\t") | {name: .[0], cpu: .[1]})')
        fi

        read -r rx tx < <(counters)
        down=$(( (rx - last_rx) / 2 ))
        up=$(( (tx - last_tx) / 2 ))
        last_rx=$rx
        last_tx=$tx

        read -r swap_used swap_total < <(awk '/^SwapTotal/ { total = $2 } /^SwapFree/ { free = $2 } END { print total - free, total }' /proc/meminfo)
        swap_percent=0
        [ "$swap_total" -eq 0 ] || swap_percent=$(( swap_used * 100 / swap_total ))

        gpu_present=false gpu_busy=0 vram_percent=0 vram="" gpu_power=0
        if [ -n "$gpu_device" ]; then
          gpu_present=true
          gpu_busy=$(cat "$gpu_device/gpu_busy_percent")
          vram_used=$(cat "$gpu_device/mem_info_vram_used")
          vram_total=$(cat "$gpu_device/mem_info_vram_total")
          vram_percent=$(( vram_used * 100 / vram_total ))
          vram=$(awk -v used="$vram_used" -v total="$vram_total" 'BEGIN { printf "%.1f / %.0f GiB", used / 1073741824, total / 1073741824 }')
        fi
        for sensor in power1_average power1_input; do
          if [ -n "$gpu_sensor" ] && [ -r "$gpu_sensor/$sensor" ]; then
            gpu_power=$(( $(cat "$gpu_sensor/$sensor") / 1000000 ))
            break
          fi
        done

        read -r load _ < /proc/loadavg

        jq -nc \
          --argjson cpu_temp "$(celsius "$cpu_sensor/temp1_input")" \
          --arg load "Load $load" \
          --argjson swap_percent "$swap_percent" \
          --arg swap "$(awk -v used="$swap_used" -v total="$swap_total" 'BEGIN { printf "%.1f / %.0f GiB", used / 1048576, total / 1048576 }')" \
          --argjson gpu_present "$gpu_present" \
          --argjson gpu_busy "$gpu_busy" \
          --argjson gpu_temp "$(celsius "$gpu_sensor/temp1_input")" \
          --argjson gpu_power "$gpu_power" \
          --arg vram "$vram" \
          --argjson vram_percent "$vram_percent" \
          --arg net_down "$(rate "$down")" \
          --arg net_up "$(rate "$up")" \
          --argjson net_down_bytes "$down" \
          --argjson disks "$disks" \
          --argjson processes "$processes" \
          '$ARGS.named'

        tick=$(( tick + 1 ))
        sleep 2
      done
    '';
  };

  desktopWidgets = pkgs.writeShellApplication {
    name = "desktop-widgets";
    runtimeInputs = [ eww ];
    text = ''
      case "''${1:-toggle}" in
        open)
          for _ in 1 2 3 4 5 6 7 8 9 10; do
            eww ping > /dev/null 2>&1 && break
            sleep 0.3
          done
          eww open-many left right dock
          ;;
        toggle) eww open-many --toggle left right dock ;;
      esac
    '';
  };

  prelude = ''
    (defvar i '${builtins.toJSON icons}')
    (defvar launch "${pkgs.gtk3}/bin/gtk-launch")
    (defpoll weather :interval "600s" :initial '${emptyWeather}' "${lib.getExe desktopWeather}")
    (defpoll clock_date :interval "60s" "LC_ALL=en_US.UTF-8 ${pkgs.coreutils}/bin/date '+%A, %B %d'")
    (defpoll favorites :interval "3600s" :initial "[]" "favorites-list --json")
    (deflisten sys :initial '${emptySystem}' "${lib.getExe desktopSysinfo}")
  '';
in

{
  options.homeManager = {
    desktop.windowManager.hyprland.widgets = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable the eww desktop widgets (clock, weather forecast, hardware monitor, favorites dock).";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.windowManager.hyprland.widgets.enable {
    home.packages = [
      desktopWeather
      desktopWidgets
    ];

    programs.eww = {
      enable = true;
      yuckConfig = prelude + builtins.readFile ./config/eww.yuck;
      scssConfig = ''
        * {
          all: unset;
          font-family: "JetBrainsMono Nerd Font Propo", "Noto Sans", sans-serif;
          font-size: 14px;
          color: ${color "text"};
        }

        .card {
          padding: 18px 20px;
          background-color: rgba(${color "crust"}, 0.72);
          border: 1px solid rgba(${color "surface2"}, 0.35);
          border-radius: 20px;
        }

        .section { margin-bottom: 2px; }
        .section-icon { color: ${accent}; font-size: 18px; }
        .section-title { color: ${color "subtext1"}; font-weight: 700; }

        .stat-icon { color: ${accent}; font-size: 16px; }
        .stat-text { color: ${color "subtext1"}; font-size: 13px; }

        .hint { color: ${color "subtext0"}; margin-top: 8px; }

        .clock-time { font-size: 72px; font-weight: 800; color: ${color "text"}; }
        .clock-date { font-size: 18px; font-weight: 600; color: ${accent}; }

        .now-icon { font-size: 66px; color: ${accent}; }
        .now-temp { font-size: 44px; font-weight: 800; }
        .now-text { color: ${color "subtext1"}; font-weight: 600; }
        .now-place { font-weight: 700; color: ${accent}; }
        .now-feels { color: ${color "subtext0"}; font-size: 13px; }

        .hour-time { color: ${color "subtext0"}; font-size: 12px; }
        .hour-icon { font-size: 22px; color: ${color "yellow"}; }
        .hour-temp { font-weight: 700; }
        .hour-rain { color: ${color "blue"}; font-size: 12px; }

        .day { padding: 3px 0; }
        .day-name { font-weight: 700; }
        .day-icon { font-size: 20px; color: ${color "yellow"}; }
        .day-rain { color: ${color "blue"}; font-size: 13px; }
        .day-min { color: ${color "subtext0"}; }
        .range { min-height: 6px; background-color: rgba(${color "surface1"}, 0.6); border-radius: 3px; }
        .range-fill {
          min-height: 6px;
          border-radius: 3px;
          background-image: linear-gradient(to right, ${color "blue"}, ${color "peach"});
        }

        .meter { margin-top: 2px; }
        .meter-label { color: ${color "subtext1"}; font-size: 13px; }
        .meter-value { font-weight: 700; font-size: 13px; }

        .bar trough {
          min-height: 8px;
          margin-top: 6px;
          background-color: rgba(${color "surface1"}, 0.6);
          border-radius: 4px;
        }
        .bar trough progress { min-height: 8px; border-radius: 4px; }
        .blue trough progress { background-color: ${color "blue"}; }
        .green trough progress { background-color: ${color "green"}; }
        .teal trough progress { background-color: ${color "teal"}; }
        .mauve trough progress { background-color: ${color "mauve"}; }
        .pink trough progress { background-color: ${color "pink"}; }
        .peach trough progress { background-color: ${color "peach"}; }

        .graph-box { padding: 4px 0; }
        .graph.blue { color: ${color "blue"}; }
        .graph.sky { color: ${color "sky"}; }

        .core trough {
          min-width: 6px;
          background-color: rgba(${color "surface1"}, 0.6);
          border-radius: 3px;
        }
        .core trough progress { min-width: 6px; border-radius: 3px; background-color: ${color "sapphire"}; }

        .process { padding: 2px 0; }
        .process-name { color: ${color "subtext1"}; font-size: 13px; }
        .process-value { font-weight: 700; font-size: 13px; }

        .dock {
          padding: 8px 10px;
          background-color: rgba(${color "crust"}, 0.72);
          border: 1px solid rgba(${color "surface2"}, 0.35);
          border-radius: 20px;
        }
        .dock-app { padding: 6px; border-radius: 14px; }
        .dock-app:hover { background-color: rgba(${color "surface1"}, 0.7); }
        tooltip { background-color: ${color "crust"}; border-radius: 10px; padding: 6px 10px; }
      '';
    };

    systemd.user.services.eww = {
      Unit = {
        Description = "eww desktop widgets";
        PartOf = [ config.wayland.systemd.target ];
        After = [ config.wayland.systemd.target ];
      };
      Service = {
        Environment = "PATH=${config.home.profileDirectory}/bin:/run/current-system/sw/bin";
        ExecStart = "${eww}/bin/eww daemon --no-daemonize";
        ExecStartPost = "${lib.getExe desktopWidgets} open";
        Restart = "on-failure";
      };
      Install.WantedBy = [ config.wayland.systemd.target ];
    };
  };
}
