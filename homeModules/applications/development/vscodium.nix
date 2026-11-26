{
  config,
  lib,
  pkgs,
  osConfig,
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
    programs.vscodium = {
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
          "workbench.colorTheme" = "Catppuccin ${osConfig.nixos.theme.catppuccin.flavor}";
          "workbench.iconTheme" = "catppuccin-${lib.strings.toLower osConfig.nixos.theme.catppuccin.flavor}";
          "[markdown]" = {
            "editor.defaultFormatter" = "yzhang.markdown-all-in-one";
          };
        };

        extensions = with pkgs.vscode-extensions; [
          alefragnani.bookmarks
          anthropic.claude-code
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

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/VSCodium"
        ".vscode-oss/extensions"
        ".vscode-oss-shared"
        {
          directory = ".claude";
          mode = "0700";
        }
      ];
    };

    # Claude Code replaces ~/.claude.json by rename, which breaks a persistence symlink (the next
    # switch fails with "A file already exists"). With CLAUDE_CONFIG_DIR the file is
    # ~/.claude/.claude.json inside the persisted directory. systemd.user for the editor started by
    # Plasma, home for shells.
    home.sessionVariables.CLAUDE_CONFIG_DIR = "${config.home.homeDirectory}/.claude";
    systemd.user.sessionVariables.CLAUDE_CONFIG_DIR = "${config.home.homeDirectory}/.claude";

    # Once: take over the newest old ~/.claude.json (the file in the home or its persisted copy).
    home.activation.claudeConfigMove = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      new="$HOME/.claude/.claude.json"
      if [ ! -e "$new" ] && [ -d "$HOME/.claude" ]; then
        for old in "$HOME/.claude.json" "/persistent$HOME/.claude.json"; do
          if [ -f "$old" ] && [ ! -L "$old" ]; then
            if [ ! -e "$new" ] || [ "$old" -nt "$new" ]; then
              run cp -p "$old" "$new"
            fi
          fi
        done
      fi
    '';
  };
}
