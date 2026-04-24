{
  config,
  lib,
  pkgs,
  osConfig,
  
  ...
}:

{
  options.homeManager = {
    applications.office.kile = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable kile";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.office.kile.enable {
    home.packages = with pkgs; [
      kile
      lmodern
      texliveFull
    ];

    #programs.texlive = {
    #  enable = true;
    #};

    programs.plasma.configFile."kilerc" = {
      "FileBrowserWidget" = {
        "Allow Expansion".value = false;
        "Decoration position".value = 2;
        "Show Inline Previews".value = true;
        "Show hidden files".value = false;
        "Sort by".value = "Name";
        "Sort directories first".value = true;
        "Sort hidden files last".value = false;
        "Sort reversed".value = false;
        "View Style".value = "Tree";
      };

      "IncludeGraphics" = {
        "imagemagick".value = true;
      };

      "KTextEditor Document" = {
        "Allow End of Line Detection".value = true;
        "Auto Detect Indent".value = true;
        "Auto Reload If Any External Changes Occurs".value = false;
        "Auto Reload If State Is In Version Control".value = true;
        "Auto Save".value = false;
        "Auto Save Interval".value = 0;
        "Auto Save On Focus Out".value = false;
        "BOM".value = false;
        "Backup Local".value = false;
        "Backup Prefix".value = "";
        "Backup Remote".value = false;
        "Backup Suffix".value = "~";
        "Camel Cursor".value = false;
        "Encoding".value = "UTF-8";
        "End of Line".value = 0;
        "Indent On Backspace".value = true;
        "Indent On Tab".value = true;
        "Indent On Text Paste".value = true;
        "Indentation Mode".value = "normal";
        "Indentation Width".value = 4;
        "Keep Extra Spaces".value = false;
        "Line Length Limit".value = 10000;
        "Newline at End of File".value = true;
        "On-The-Fly Spellcheck".value = true;
        "Overwrite Mode".value = false;
        "PageUp/PageDown Moves Cursor".value = false;
        "Remove Spaces".value = 1;
        "ReplaceTabsDyn".value = true;
        "Show Spaces".value = 0;
        "Show Tabs".value = true;
        "Smart Home".value = true;
        "Swap File Mode".value = 1;
        "Swap Sync Interval".value = 15;
        "Tab Handling".value = 2;
        "Tab Width".value = 4;
        "Trailing Marker Size".value = 1;
        "Use Editor Config".value = true;
        "Word Wrap".value = false;
        "Word Wrap Column".value = 80;
      };

      "KTextEditor Editor" = {
        "Encoding Prober Type".value = 1;
        "Fallback Encoding".value = "UTF-16";
      };

      "KTextEditor Renderer" = {
        "Animate Bracket Matching".value = false;
        "Auto Color Theme Selection".value = true;
        "Color Theme".value = "Catppuccin ${osConfig.nixos.theme.catppuccin.flavor}";
        "Line Height Multiplier".value = 1;
        "Show Indentation Lines".value = false;
        "Show Whole Bracket Expression".value = true;
        "Text Font".value = "Hack,10,-1,7,400,0,0,0,0,0,0,0,0,0,0,1";
        "Text Font Features".value = "";
        "Word Wrap Marker".value = false;
      };

      "KTextEditor View" = {
        "Allow Mark Menu".value = true;
        "Auto Brackets".value = true;
        "Auto Center Lines".value = 0;
        "Auto Completion".value = true;
        "Auto Completion Preselect First Entry".value = true;
        "Backspace Remove Composed Characters".value = false;
        "Bookmark Menu Sorting".value = 0;
        "Bracket Match Preview".value = false;
        "Cycle Through Bookmarks".value = true;
        "Default Mark Type".value = 1;
        "Disable bracket match highlight if inactive".value = false;
        "Disable current line highlight if inactive".value = false;
        "Dynamic Word Wrap".value = true;
        "Dynamic Word Wrap Align Indent".value = 80;
        "Dynamic Word Wrap At Static Marker".value = false;
        "Dynamic Word Wrap Indicators".value = 1;
        "Dynamic Wrap not at word boundaries".value = false;
        "Enable Accessibility".value = true;
        "Enable Tab completion".value = false;
        "Enter To Insert Completion".value = true;
        "Fold First Line".value = false;
        "Folding Bar".value = true;
        "Folding Preview".value = true;
        "Hide cursor if inactive".value = false;
        "Icon Bar".value = false;
        "Input Mode".value = 0;
        "Keyword Completion".value = true;
        "Line Modification".value = true;
        "Line Numbers".value = true;
        "Max Clipboard History Entries".value = 20;
        "Maximum Search History Size".value = 100;
        "Mouse Paste At Cursor Position".value = false;
        "Multiple Cursor Modifier".value = 134217728;
        "Persistent Selection".value = false;
        "Scroll Bar Marks".value = false;
        "Scroll Bar Mini Map All".value = true;
        "Scroll Bar Mini Map Width".value = 60;
        "Scroll Bar MiniMap".value = true;
        "Scroll Bar Preview".value = true;
        "Scroll Past End".value = false;
        "Search/Replace Flags".value = 140;
        "Shoe Line Ending Type in Statusbar".value = false;
        "Show Documentation With Completion".value = true;
        "Show File Encoding".value = true;
        "Show Folding Icons On Hover Only".value = true;
        "Show Line Count".value = true;
        "Show Scrollbars".value = 0;
        "Show Statusbar Dictionary".value = true;
        "Show Statusbar Highlighting Mode".value = true;
        "Show Statusbar Input Mode".value = true;
        "Show Statusbar Line Column".value = true;
        "Show Statusbar Tab Settings".value = true;
        "Show Word Count".value = true;
        "Smart Copy Cut".value = true;
        "Statusbar Line Column Compact Mode".value = true;
        "Text Drag And Drop".value = true;
        "User Sets Of Chars To Enclose Selection".value = "";
        "Vi Input Mode Steal Keys".value = false;
        "Vi Relative Line Numbers".value = false;
        "Word Completion".value = true;
        "Word Completion Minimal Word Length".value = 3;
        "Word Completion Remove Tail".value = true;
      };

      "NewFileWizard" = {
        "UseWizardWhenCreatingEmptyFile".value = true;
      };
    };
  };
}
