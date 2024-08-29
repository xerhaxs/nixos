{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.development.vscodium = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable VSCodium.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.development.vscodium.enable {
    programs.vscode = {
      enable = true;
      #package = pkgs.vscodium;
      package = (pkgs.vscodium.overrideAttrs (oldAttrs: {
        buildInputs = oldAttrs.buildInputs ++ [ pkgs.dotnet-sdk ];
      }));
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = true;
      userSettings = {
        "files.autoSave" = "off";
        "[nix]"."editor.tabSize" = 2;
        "update.mode" = "none";
        "git.enableSmartCommit" = true;
        "git.autofetch" = true;
        "diffEditor.maxComputationTime" = 0;
        "cSpell.language" = "en,de";
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
        ms-dotnettools.csharp
        ms-dotnettools.vscode-dotnet-runtime
      ];
    };
  };
}
