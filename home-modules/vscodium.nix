{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    enableExtensionUpdateCheck = true;
    enableUpdateCheck = false;
    userSettings = {
      "files.autoSave" = "off";
      "[nix]"."editor.tabSize" = 2;
      "update.mode" = "none";
      "git.enableSmartCommit" = true;
    };

    extensions = with pkgs.vscode-extensions; [
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
      #vscodevim.vim
      yzhang.markdown-all-in-one
      jnoortheen.nix-ide
      arrterian.nix-env-selector
      streetsidesoftware.code-spell-checker
      davidlday.languagetool-linter
      #hediet.vscode-drawio
      james-yu.latex-workshop
      alefragnani.bookmarks
    ];
  };
}
