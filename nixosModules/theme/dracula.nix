{ config, lib, pkgs, ... }:

let
  dracula = {
    plymouth = pkgs.fetchFromGitHub {
      owner = "dracula";
      repo = "plymouth";
      rev = "main"; # commit hash or tag
      sha256 = ""; #sha256 = lib.fakeSha256;
    };

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
in

{
  options.nixos = {
    theme.dracula = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable dracula theme.";
      };
    };
  };

  config = lib.mkIf (config.nixos.theme.dracula.enable && config.nixos.theme.theme.colorscheme == "dracula") {
    environment.systemPackages = with pkgs; [
      dracula-theme
      dracula-icon-theme
    ];

    boot.plymouth = lib.mkIf config.boot.plymouth.enable {
      font = "${pkgs.dejavu_fonts.minimal}/share/fonts/truetype/DejaVuSans.ttf";
      themePackages = with pkgs; [
          dracula.plymouth
        ];
      theme = "dracula";
    };
  };
}
