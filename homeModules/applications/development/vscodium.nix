{
  config,
  lib,
  pkgs,
  ...
}:

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
      package = pkgs.vscodium;
      profiles.default = {
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
          "window.titleBarStyle" = "native";
          "git.confirmSync" = false;
        };

        extensions = with pkgs.vscode-extensions; [
          alefragnani.bookmarks
          arrterian.nix-env-selector
          #cweijan.vscode-office
          davidanson.vscode-markdownlint
          davidlday.languagetool-linter
          foam.foam-vscode
          #gera2ld.markmap-vscode
          hediet.vscode-drawio
          james-yu.latex-workshop
          jnoortheen.nix-ide
          marp-team.marp-vscode
          mkhl.shfmt
          #pomdtr.excalidraw-editor
          streetsidesoftware.code-spell-checker
          #vscodevim.vim
          #YuTengjing.open-in-external-app
          yzhang.markdown-all-in-one
        ];
      };
    };

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/VSCodium"
      ];
    };
  };
}
