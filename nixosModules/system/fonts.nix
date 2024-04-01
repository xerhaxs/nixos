{ config, lib, pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      allowBitmaps = false;
      hinting.enable = true;
      enableGhostscriptFonts = false;
      subpixel.rgba = "rgb";
      defaultFonts = {
        emoji = [ "openmoji-color" "Noto Color Emoji" ];
        serif = [ "DejaVu Serif" ];
        sansSerif = [ "DejaVu Sans" ];
        monospace = [ "Nerd Font" "DejaVu Sans Mono" ];
      };
    };
    packages = with pkgs; [
      dejavu_fonts
      dina-font
      fira-code
      fira-code-symbols
      liberation_ttf
      liberation_ttf
      mplus-outline-fonts.githubRelease
      nerdfonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      proggyfonts
    ];
  };
}
