{ config, lib, pkgs, ... }:

let
  colorScheme = {
    catppuccin = {
      grub = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "grub";
        rev = "main"; # commit hash or tag
        sha256 = ""; #sha256 = lib.fakeSha256;
      };

      sddm = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "sddm";
        rev = "main"; # commit hash or tag
        sha256 = ""; #sha256 = lib.fakeSha256;
      };

      latte = {
        accents = [ "blue" ];
        flavour = [ "latte" ];
        size = [ "standard" ];
        tweaks = [ "rimless" "normal" ];
        variant = [ "latte" ];
        winDecStyles = [ "modern" ];
        grub = "src/catppuccin-latte-grub-theme";
        sddm = "src/catppuccin-latte";
      };
      frappe = {
        accents = [ "mauve" ];
        flavour = [ "latte" ];
        size = [ "standard" ];
        tweaks = [ "rimless" "normal" ];
        variant = [ "latte" ];
        winDecStyles = [ "modern" ];
        grub = "src/catppuccin-frappe-grub-theme";
        sddm = "src/catppuccin-frappe";
      };
      macchiato = {
        accents = [ "mauve" ];
        flavour = [ "latte" ];
        size = [ "standard" ];
        tweaks = [ "rimless" "normal" ];
        variant = [ "latte" ];
        winDecStyles = [ "modern" ];
        grub = "src/catppuccin-machiato-grub-theme";
        sddm = "src/catppuccin-machiato";
      };
      mocha = {
        accents = [ "mauve" ];
        flavour = [ "latte" ];
        size = [ "standard" ];
        tweaks = [ "rimless" "normal" ];
        variant = [ "latte" ];
        winDecStyles = [ "modern" ];
        grub = "src/catppuccin-mocha-grub-theme";
        sddm = "src/catppuccin-mocha";
      };
    };

    dracula = {
      palette = {
        base00 = "#282936"; #background
        base01 = "#3a3c4e";
        base02 = "#4d4f68";
        base03 = "#626483";
        base04 = "#62d6e8";
        base05 = "#e9e9f4"; #foreground
        base06 = "#f1f2f8";
        base07 = "#f7f7fb";
        base08 = "#ea51b2";
        base09 = "#b45bcf";
        base0A = "#00f769";
        base0B = "#ebff87";
        base0C = "#a1efe4";
        base0D = "#62d6e8";
        base0E = "#b45bcf";
        base0F = "#00f769";
      };
    };
  };
in

{
  options.nixos = {
    theme.theme = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable themeset.";
      };

      colorscheme = {
        type = lib.types.str;
        default = "catppuccin";
      };

      catppuccin = {
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
          default = "normal";
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

        grub = {
          type = lib.types.str;
          default = "src/catppuccin-${config.nixos.theme.theme.catppuccin.flavor}";
        };

        sddm = {
          type = lib.types.str;
          default = "src/catppuccin-${config.nixos.theme.theme.catppuccin.flavor}";
        };
      };
    };
  };

  config = lib.mkIf config.nixos.theme.theme.enable {
    nixos.theme.theme = {
      colorscheme = config.nixos.theme.theme.colorscheme;

      catppuccin = { 
        enable = config.nixos.theme.theme.colorscheme == "catppuccin";
        flavor = config.nixos.theme.theme.catppuccin.flavor;
        accent = config.nixos.theme.theme.catppuccin.accent;
        colorscheme = colorScheme.catppuccin.${config.nixos.theme.theme.catppuccin.flavor};
      };

      dracula = {
        enable = config.nixos.theme.theme.colorscheme == "dracula";
        colorscheme = colorScheme.dracula;
      };
    };
  };
}
