{ config, lib, pkgs, ... }:

let
  catppuccin = {
    grub = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "grub";
      rev = "main"; # commit hash or tag
      sha256 = lib.fakeSha256; #sha256 = lib.fakeSha256;
    };

    sddm = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "sddm";
      rev = "main"; # commit hash or tag
      sha256 = lib.fakeSha256; #sha256 = lib.fakeSha256;
    };
  };
in

{
  options.nixos = {
    theme.catppuccin = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable catppuccin theme.";
      };

      flavor = {
        type = lib.types.enum [
          "latte"
          "frappe"
          "macchiato"
          "mocha"
        ];
        default = "mocha";
      };

      size = {
        type = lib.types.enum [
          "standard"
          "compact"
        ];
        default = "standard";
      };

      tweaks = {
        type = lib.types.enum [
          "black"
          "rimless"
          "normal"
        ];
        default = "'rimless' 'normal'";
      };
      
      winDecStyles = {
        type = lib.types.enum [
          "modern"
          "classic"
        ];
        default = "modern";
      };

      accent = {
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
    };
  };

  config = lib.mkIf (config.nixos.theme.catppuccin.enable && config.nixos.theme.theme.colorscheme == "catppuccin") {
    environment.systemPackages = with pkgs; [
      papirus-icon-theme

      (catppuccin.override {
        accent = [ "${config.nixos.theme.catppuccin.accent}" ];
        variant = [ "${config.nixos.theme.catppuccin.flavor}" ];
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
      })

      (catppuccin-kde.override {
        accents = [ "${config.nixos.theme.catppuccin.accent}" ];
        flavour = [ "${config.nixos.theme.catppuccin.flavor}" ];
        winDecStyles = [ "${config.nixos.theme.catppuccin.winDecStyles}" ];
      })

      (catppuccin-gtk.override {
        accents = [ "${config.nixos.theme.catppuccin.accent}" ];
        size = [ "${config.nixos.theme.catppuccin.size}" ];
        tweaks = [ "${config.nixos.theme.catppuccin.tweaks}" ];
        variant = "${config.nixos.theme.catppuccin.flavor}";
      })

      (catppuccin-cursors.override {
        dimensions.color = [ "${config.nixos.theme.catppuccin.accent}" ];
        dimensions.palette = [ "${config.nixos.theme.catppuccin.flavor}" ];
      })

      (catppuccin-papirus-folders.override {
        accent = "${config.nixos.theme.catppuccin.accent}";
        flavor = "${config.nixos.theme.catppuccin.flavor}";
      })

      (catppuccin-kvantum.override {
        accent = "${config.nixos.theme.catppuccin.accent}";
        variant = "${config.nixos.theme.catppuccin.flavor}";
      })
    ];

    boot.plymouth = lib.mkIf config.boot.plymouth.enable {
      font = "${pkgs.dejavu_fonts.minimal}/share/fonts/truetype/DejaVuSans.ttf";
      themePackages = with pkgs; [
         (catppuccin-plymouth.override {variant = "${config.nixos.theme.catppuccin.flavor}";})
        ];
      theme = "catppuccin-${config.nixos.theme.catppuccin.flavor}";
    };

    boot.loader.grub.theme = lib.mkIf config.boot.loader.grub.enable catppuccin.grub + "/src/catppuccin-${config.nixos.theme.catppuccin.flavor}-grub-theme";

    services.xserver.displayManager.sddm.theme = lib.mkIf config.nixos.desktop.displayManager.sddm.enable catppuccin.sddm + "/src/catppuccin-${config.nixos.theme.catppuccin.flavor}";
  };
}