{ config, pkgs, ... }:

{
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    rnote
    #xournalpp
    kile
    libreoffice
    #onlyoffice-bin
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US
    hunspellDicts.en_GB-large
    languagetool
    hyphen
    mythes
    #normcap
    #gnome-frog
    gImageReader
    #libsForQt5.ghostwriter
  ];
}
