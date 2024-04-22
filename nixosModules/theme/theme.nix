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
      
      plymouth = {
        font = "${pkgs.dejavu_fonts.minimal}/share/fonts/truetype/DejaVuSans.ttf";
        themePackages = with pkgs; [
          (catppuccin-plymouth.override {variant = "${config.nixos.theme.theme}";})
        ];
        theme = "${config.nixos.theme.theme}";
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
      };
    };
  };

  config = lib.mkIf config.nixos.theme.theme.enable {
    nixos.theme.theme = {
      colorscheme = config.nixos.theme.theme.colorscheme;

      catppuccin = { 
        enable = config.nixos.theme.theme.colorscheme == "catppuccin";
        flavor = config.nixos.theme.theme.catppuccin.flavor;
        colorscheme = colorScheme.catppuccin.${config.nixos.theme.theme.catppuccin.flavor};
        plymouth = 
      };

      dracula = {
        enable = config.nixos.theme.theme.colorscheme == "dracula";
        colorscheme = colorScheme.dracula;
        plymouth = 
      };

    boot.plymouth = {
      theme = plymouth;
      themePackages = plymouth-pkgs;
    };

    environment.systemPackages = with pkgs; [
      papirus-icon-theme
    ];

  };
}
