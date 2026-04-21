{
  config,
  lib,
  pkgs,
  catppuccin,
  ...
}:

{
  options.nixos = {
    theme.catppuccin = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable catppuccin theme.";
      };

      flavor = lib.mkOption {
        type = lib.types.enum [
          "Latte"
          "Frappe"
          "Macchiato"
          "Mocha"
        ];
        default = "Mocha";
      };

      size = lib.mkOption {
        type = lib.types.enum [
          "Standard"
          "Compact"
        ];
        default = "Standard";
      };

      tweaks = lib.mkOption {
        type = lib.types.enum [
          "Black"
          "Rimless"
          "Normal"
          "Float"
        ];
        default = "Normal";
      };

      winDecStyles = lib.mkOption {
        type = lib.types.enum [
          "Modern"
          "Classic"
        ];
        default = "Modern";
      };

      accent = lib.mkOption {
        type = lib.types.enum [
          "Blue"
          "Dark"
          "Flamingo"
          "Green"
          "Lavender"
          "Light"
          "Maroon"
          "Mauve"
          "Peach"
          "Pink"
          "Red"
          "Rosewater"
          "Sapphire"
          "Sky"
          "Teal"
          "Yellow"
        ];
        default = "Mauve";
      };

      prefer = lib.mkOption {
        type = lib.types.enum [
          "Dark"
          "Light"
        ];
        default = "Dark";
      };
    };
  };

  config = lib.mkIf config.nixos.theme.catppuccin.enable {
    catppuccin = {
      enable = true;
      enableReleaseCheck = true;
      accent = lib.strings.toLower "${config.nixos.theme.catppuccin.accent}";
      flavor = lib.strings.toLower "${config.nixos.theme.catppuccin.flavor}";
      #sources = "";

      sddm = {
        font = "Noto Sans";
        #background = "${config.home-manager.users.${userName}.xdg.userDirs.pictures}/Desktopbilder/JWST/compress/STScI-01G7ETPF7DVBJAC42JR5N6EQRH.jpg";
        background = "https://wallpapercave.com/wp/wp6058967.jpg";
        loginBackground = true;
      };
    };

    nixos.theme.catppuccin.prefer = lib.mkIf (config.nixos.theme.catppuccin.flavor == "Latte") "Light";

    environment.systemPackages = with pkgs; [
      papirus-icon-theme

      (catppuccin-kde.override {
        accents = map (str: lib.strings.toLower str) [ "${config.nixos.theme.catppuccin.accent}" ];
        flavour = map (str: lib.strings.toLower str) [ "${config.nixos.theme.catppuccin.flavor}" ];
        winDecStyles = map (str: lib.strings.toLower str) [
          "${config.nixos.theme.catppuccin.winDecStyles}"
        ];
      })

      (catppuccin-gtk.override {
        accents = map (str: lib.strings.toLower str) [ "${config.nixos.theme.catppuccin.accent}" ];
        size = lib.strings.toLower "${config.nixos.theme.catppuccin.size}";
        tweaks = map (str: lib.strings.toLower str) [ "${config.nixos.theme.catppuccin.tweaks}" ];
        variant = lib.strings.toLower "${config.nixos.theme.catppuccin.flavor}";
      })

      catppuccin-cursors

      (catppuccin-papirus-folders.override {
        accent = lib.strings.toLower "${config.nixos.theme.catppuccin.accent}";
        flavor = lib.strings.toLower "${config.nixos.theme.catppuccin.flavor}";
      })

      (catppuccin-kvantum.override {
        accent = lib.strings.toLower "${config.nixos.theme.catppuccin.accent}";
        variant = lib.strings.toLower "${config.nixos.theme.catppuccin.flavor}";
      })
    ];
  };
}
