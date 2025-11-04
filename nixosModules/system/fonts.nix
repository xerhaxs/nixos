{ config, lib, pkgs, ... }:

{
  options.nixos = {
    system.fonts = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable system fonts.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.fonts.enable {
    fonts = {
      fontDir.enable = true;
      enableGhostscriptFonts = false;
      fontconfig = {
        enable = true;
        allowBitmaps = false;
        hinting.enable = true;
        subpixel.rgba = "rgb";
        defaultFonts = {
          emoji = [ "openmoji-color" "Noto Color Emoji" ];
          serif = [ "Noto Serif" ];
          sansSerif = [ "Noto Sans" ];
          monospace = [ "Nerd Font" "Noto Sans Mono" ];
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
        nerd-fonts.zed-mono
        nerd-fonts.victor-mono
        nerd-fonts.ubuntu-sans
        nerd-fonts.ubuntu-mono
        nerd-fonts.ubuntu
        nerd-fonts.tinos
        nerd-fonts.terminess-ttf
        nerd-fonts.symbols-only
        nerd-fonts.space-mono
        nerd-fonts.shure-tech-mono
        nerd-fonts.sauce-code-pro
        nerd-fonts.roboto-mono
        nerd-fonts.recursive-mono
        nerd-fonts.proggy-clean-tt
        nerd-fonts.profont
        nerd-fonts.overpass
        nerd-fonts.open-dyslexic
        nerd-fonts.noto
        nerd-fonts.mononoki
        nerd-fonts.monoid
        nerd-fonts.monofur
        nerd-fonts.monaspace
        nerd-fonts.meslo-lg
        nerd-fonts.martian-mono
        nerd-fonts.lilex
        nerd-fonts.liberation
        nerd-fonts.lekton
        nerd-fonts.jetbrains-mono
        nerd-fonts.iosevka-term-slab
        nerd-fonts.iosevka-term
        nerd-fonts.iosevka
        nerd-fonts.intone-mono
        nerd-fonts.inconsolata-lgc
        nerd-fonts.inconsolata-go
        nerd-fonts.inconsolata
        nerd-fonts.im-writing
        nerd-fonts.hurmit
        nerd-fonts.heavy-data
        nerd-fonts.hasklug
        nerd-fonts.hack
        nerd-fonts.gohufont
        nerd-fonts.go-mono
        nerd-fonts.geist-mono
        nerd-fonts.fira-mono
        nerd-fonts.fira-code
        nerd-fonts.fantasque-sans-mono
        nerd-fonts.envy-code-r
        nerd-fonts.droid-sans-mono
        nerd-fonts.departure-mono
        nerd-fonts.dejavu-sans-mono
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        proggyfonts
      ];
    };
  };
}
