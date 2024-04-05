{ config, lib, pkgs, ... }:

{
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    gImageReader
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_GB-large
    hunspellDicts.en_US
    hyphen
    kdePackages.ghostwriter
    kile
    languagetool
    libreoffice
    mythes
    normcap
    #onlyoffice-bin
    rnote
    #xournalpp
  ];
}
