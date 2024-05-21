{ catppuccin, config, lib, pkgs, ... }:

let
  catppuccin = {
    grub = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "grub";
      rev = "main"; # commit hash or tag
      sha256 = "sha256-e8XFWebd/GyX44WQI06Cx6sOduCZc5z7/YhweVQGMGY="; #sha256 = lib.fakeSha256;
    };

    sddm-background = pkgs.fetchurl {
      url = "https://wallpapercave.com/wp/wp6058967.jpg";
      sha256 = lib.fakeSha256;
    };

    obsThemesDir = "/home/${config.nixos.system.user.defaultuser.name}/.config./obs-studio/themes";
    heroicThemesDir = "/home/${config.nixos.system.user.defaultuser.name}/.config./heroic/themes";
    flavorToLower = lib.strings.toLower ${config.nixos.theme.catppuccin.flavor};
  };
in

{
  imports = [
    catppuccin.nixosModules.catppuccin
  ];

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

  config = lib.mkIf (config.nixos.theme.catppuccin.enable && config.nixos.theme.theme.colorscheme == "catppuccin") {
    catppuccin.flavour = "${config.nixos.theme.catppuccin.flavor}";
    
    nixos.theme.catppuccin.prefer = lib.mkIf (config.nixos.theme.catppuccin.flavor == "latte") "Light";

    systemd.user.services.obsThemeChecker = { #lib.mkIf (${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.homeManager.applications.media.obs-studio.enable) {
      description = "Check and download OBS theme if not present";

      serviceConfig = {
        ExecStart = ''
          if [ ! -d "${catppuccin.obsThemesDir}" ]; then
            mkdir -p "${catppuccin.obsThemesDir}"
          fi

          if ! ls ${catppuccin.obsThemesDir}/*.qss 1> /dev/null 2>&1; then
            curl -L https://raw.githubusercontent.com/catppuccin/obs/main/themes/Catppuccin%20${config.nixos.theme.catppuccin.flavor}.qss -o ${catppuccin.obsThemesDir}/Catppuccin\ ${config.nixos.theme.catppuccin.flavor}.qss
          fi
        '';
        Type = "oneshot";
      };

      wantedBy = [ "default.target" ];
    };

    systemd.user.services.heroicThemeChecker = { #lib.mkIf (${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.homeManager.applications.media.obs-studio.enable) {
      description = "Check and download Heroic theme if not present";

      serviceConfig = {
        ExecStart = ''
          if [ ! -d "${catppuccin.heroicThemesDir}" ]; then
            mkdir -p "${catppuccin.heroicThemesDir}"
          fi

          if ! ls ${catppuccin.heroicThemesDir}/*.qss 1> /dev/null 2>&1; then
            curl -L https://raw.githubusercontent.com/catppuccin/heroic/main/themes/catppuccin-${catppuccin.flavorToLower}.css -o ${catppuccin.heroicThemesDir}/catppuccin-${catppuccin.flavorToLower}.qss
          fi
        '';
        Type = "oneshot";
      };

      wantedBy = [ "default.target" ];
    };

    environment.systemPackages = with pkgs; [
      papirus-icon-theme

      #(catppuccin.override {
      #  accent = [ "${config.nixos.theme.catppuccin.accent}" ];
      #  variant = [ "${config.nixos.theme.catppuccin.flavor}" ];
        #themeList = [
        #  "bat"
        #  "bottom"
        #  "btop"
        #  "hyprland"
        #  "k9s"
        #  "kvantum"
        #  "lazygit"
        #  "plymouth"
        #  "refind"
        #  "rofi"
        #  "waybar"
        #];
      #})

      (catppuccin-kde.override {
        accents = map (str: lib.strings.toLower str) [ "${config.nixos.theme.catppuccin.accent}" ];
        flavour = map (str: lib.strings.toLower str) [ "${config.nixos.theme.catppuccin.flavor}" ];
        winDecStyles = map (str: lib.strings.toLower str) [ "${config.nixos.theme.catppuccin.winDecStyles}" ];
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
        accent = "${config.nixos.theme.catppuccin.accent}";
        variant = "${config.nixos.theme.catppuccin.flavor}";
      })
    ];

    boot.plymouth = lib.mkIf config.boot.plymouth.enable {
      font = "${pkgs.dejavu_fonts.minimal}/share/fonts/truetype/DejaVuSans.ttf";
      themePackages = with pkgs; [
        (catppuccin-plymouth.override {
          variant = lib.strings.toLower "${config.nixos.theme.catppuccin.flavor}";
        })
      ];
      theme = lib.strings.toLower "catppuccin-${config.nixos.theme.catppuccin.flavor}";
    };

    boot.loader.grub.theme = lib.mkIf config.boot.loader.grub.enable (catppuccin.grub + lib.strings.toLower "/src/catppuccin-${config.nixos.theme.catppuccin.flavor}-grub-theme");

    services.displayManager.sddm = lib.mkIf config.nixos.desktop.displayManager.sddm.enable {
      catppuccin = {
        enable = true;
        flavour = "${config.nixos.theme.catppuccin.flavor}";
        accent = "${config.nixos.theme.catppuccin.accent}";
        font = "DejaVu Sans";
        fontSize = 10;
        background = catppuccin.sddm-background;
        loginBackground = true;
      };
    };

    console = lib.mkIf config.nixos.base.shell.console.enable {
      catppuccin.enable = true;
    };
  };
}