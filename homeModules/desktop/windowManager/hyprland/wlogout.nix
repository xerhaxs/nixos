{
  config,
  lib,
  pkgs,
  ...
}:

let
  flavor = config.catppuccin.flavor;
  accentName = config.catppuccin.accent;
  palette = (lib.importJSON "${config.catppuccin.sources.palette}/palette.json").${flavor}.colors;
  accent = palette.${accentName}.hex;

  # wlogout has no SVG loader, so the icons are rendered to PNG.
  icon =
    name:
    pkgs.runCommand "wlogout-${name}.png" { nativeBuildInputs = [ pkgs.librsvg ]; } ''
      rsvg-convert -w 256 -h 256 -o $out \
        ${config.catppuccin.sources.wlogout}/icons/wlogout/${flavor}/${accentName}/${name}.svg
    '';

  buttons = [
    {
      label = "lock";
      action = "loginctl lock-session";
      text = "Sperren";
      keybind = "l";
    }
    {
      label = "logout";
      action = "hyprctl dispatch 'hl.dsp.exit()'";
      text = "Abmelden";
      keybind = "e";
    }
    {
      label = "suspend";
      action = "systemctl suspend";
      text = "Standby";
      keybind = "u";
    }
    {
      label = "reboot";
      action = "systemctl reboot";
      text = "Neustart";
      keybind = "r";
    }
    {
      label = "shutdown";
      action = "systemctl poweroff";
      text = "Aus";
      keybind = "s";
    }
  ];

  # wlogout stretches its buttons over the screen, the margins keep them at a fixed size.
  powerMenu = pkgs.writeShellApplication {
    name = "power-menu";
    runtimeInputs = with pkgs; [
      jq
      wlogout
    ];
    text = ''
      read -r width height < <(hyprctl monitors -j | jq -r '.[] | select(.focused) | "\(.width / .scale | floor) \(.height / .scale | floor)"')
      vertical=$(((height - 240) / 2))
      horizontal=$(((width - 1000) / 2))
      exec wlogout --protocol layer-shell --buttons-per-row ${toString (builtins.length buttons)} \
        --margin-top "$vertical" --margin-bottom "$vertical" \
        --margin-left "$horizontal" --margin-right "$horizontal"
    '';
  };
in

{
  options.homeManager = {
    desktop.windowManager.hyprland.wlogout = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable wlogout.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.windowManager.hyprland.wlogout.enable {
    catppuccin.wlogout.enable = false;

    home.packages = [
      powerMenu
    ];

    programs.wlogout = {
      enable = true;
      layout = buttons;
      style = ''
        * {
          background-image: none;
          box-shadow: none;
          font-family: "JetBrainsMono Nerd Font Propo", sans-serif;
          font-size: 15px;
          font-weight: 600;
        }

        window {
          background-color: alpha(${palette.crust.hex}, 0.6);
        }

        button {
          color: ${palette.subtext1.hex};
          background-color: alpha(${palette.base.hex}, 0.85);
          background-repeat: no-repeat;
          background-position: center 38%;
          background-size: 34%;
          border: 2px solid alpha(${palette.surface2.hex}, 0.4);
          border-radius: 24px;
          margin: 10px;
          min-width: 160px;
          transition: all 150ms ease;
        }

        button:hover,
        button:focus {
          color: ${accent};
          background-color: alpha(${palette.surface0.hex}, 0.95);
          border-color: ${accent};
          outline-style: none;
        }

        ${lib.concatMapStrings (button: ''
          #${button.label} {
            background-image: url("${icon button.label}");
          }
        '') buttons}
      '';
    };
  };
}
