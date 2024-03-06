{ config, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    liberation_ttf
    dejavu_fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];

  fonts.fontDir.enable = true;
}
