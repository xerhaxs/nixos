{
  config,
  lib,
  pkgs,
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

    xdg.configFile."kilerc".text = ''
      [FileBrowserWidget]
      Allow Expansion=false
      Decoration position=2
      Show Inline Previews=true
      Show hidden files=false
      Sort by=Name
      Sort directories first=true
      Sort hidden files last=false
      Sort reversed=false
      View Style=Tree

      [IncludeGraphics]
      imagemagick=true

      [KTextEditor Document]
      Allow End of Line Detection=true
      Auto Detect Indent=true
      Auto Reload If Any External Changes Occurs=false
      Auto Reload If State Is In Version Control=true
      Auto Save=false
      Auto Save Interval=0
      Auto Save On Focus Out=false
      BOM=false
      Backup Local=false
      Backup Prefix=
      Backup Remote=false
      Backup Suffix=~
      Camel Cursor=false
      Encoding=UTF-8
      End of Line=0
      Indent On Backspace=true
      Indent On Tab=true
      Indent On Text Paste=true
      Indentation Mode=normal
      Indentation Width=4
      Keep Extra Spaces=false
      Line Length Limit=10000
      Newline at End of File=true
      On-The-Fly Spellcheck=true
      Overwrite Mode=false
      PageUp/PageDown Moves Cursor=false
      Remove Spaces=1
      ReplaceTabsDyn=true
      Show Spaces=0
      Show Tabs=true
      Smart Home=true
      Swap Directory=
      Swap File Mode=1
      Swap Sync Interval=15
      Tab Handling=2
      Tab Width=4
      Trailing Marker Size=1
      Use Editor Config=true
      Word Wrap=false
      Word Wrap Column=80

      [KTextEditor Editor]
      Encoding Prober Type=1
      Fallback Encoding=UTF-16

      [KTextEditor Renderer]
      Animate Bracket Matching=false
      Auto Color Theme Selection=true
      Color Theme=Catppuccin Mocha
      Line Height Multiplier=1
      Show Indentation Lines=false
      Show Whole Bracket Expression=true
      Text Font=Hack,10,-1,7,400,0,0,0,0,0,0,0,0,0,0,1
      Text Font Features=
      Word Wrap Marker=false

      [KTextEditor View]
      Allow Mark Menu=true
      Auto Brackets=true
      Auto Center Lines=0
      Auto Completion=true
      Auto Completion Preselect First Entry=true
      Backspace Remove Composed Characters=false
      Bookmark Menu Sorting=0
      Bracket Match Preview=false
      Chars To Enclose Selection=<>(){}[]'"
      Cycle Through Bookmarks=true
      Default Mark Type=1
      Disable bracket match highlight if inactive=false
      Disable current line highlight if inactive=false
      Dynamic Word Wrap=true
      Dynamic Word Wrap Align Indent=80
      Dynamic Word Wrap At Static Marker=false
      Dynamic Word Wrap Indicators=1
      Dynamic Wrap not at word boundaries=false
      Enable Accessibility=true
      Enable Tab completion=false
      Enter To Insert Completion=true
      Fold First Line=false
      Folding Bar=true
      Folding Preview=true
      Hide cursor if inactive=false
      Icon Bar=false
      Input Mode=0
      Keyword Completion=true
      Line Modification=true
      Line Numbers=true
      Max Clipboard History Entries=20
      Maximum Search History Size=100
      Mouse Paste At Cursor Position=false
      Multiple Cursor Modifier=134217728
      Persistent Selection=false
      Scroll Bar Marks=false
      Scroll Bar Mini Map All=true
      Scroll Bar Mini Map Width=60
      Scroll Bar MiniMap=true
      Scroll Bar Preview=true
      Scroll Past End=false
      Search/Replace Flags=140
      Shoe Line Ending Type in Statusbar=false
      Show Documentation With Completion=true
      Show File Encoding=true
      Show Folding Icons On Hover Only=true
      Show Line Count=true
      Show Scrollbars=0
      Show Statusbar Dictionary=true
      Show Statusbar Highlighting Mode=true
      Show Statusbar Input Mode=true
      Show Statusbar Line Column=true
      Show Statusbar Tab Settings=true
      Show Word Count=true
      Smart Copy Cut=true
      Statusbar Line Column Compact Mode=true
      Text Drag And Drop=true
      User Sets Of Chars To Enclose Selection=
      Vi Input Mode Steal Keys=false
      Vi Relative Line Numbers=false
      Word Completion=true
      Word Completion Minimal Word Length=3
      Word Completion Remove Tail=true

      [MostFrequentlyUsedSymbols]
      counts=
      paths=

      [NewFileWizard]
      UseWizardWhenCreatingEmptyFile=true
    '';
  };
}
