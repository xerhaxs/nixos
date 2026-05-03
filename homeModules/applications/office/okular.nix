{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

{
  options.homeManager = {
    applications.office.okular = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable okular.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.office.okular.enable {
    xdg.configFile."okularpartrc".text = ''
      [General]
      ShellOpenFileInTabs=true
      ttsVoice=samantha

      [Main View]
      ShowLeftPanel=false

      [PageView]
      MouseMode=TextSelect

      [Reviews]
      BuiltinAnnotationTools=<tool id="1" type="highlight"><engine color="#ffffff" type="TextSelector"><annotation color="#ffffff" type="Highlight"/></engine></tool>,<tool id="2" type="underline"><engine color="#ff0000" type="TextSelector"><annotation color="#ffff0000" type="Underline"/></engine></tool>,<tool id="3" type="squiggly"><engine color="#ff0000" type="TextSelector"><annotation color="#ffff0000" type="Squiggly"/></engine></tool>,<tool id="4" type="strikeout"><engine color="#ff0000" type="TextSelector"><annotation color="#ffff0000" type="StrikeOut"/></engine></tool>,<tool id="5" type="typewriter"><engine block="true" type="PickPoint"><annotation color="#00ffffff" font="Noto Sans\\,10\\,-1\\,5\\,50\\,0\\,0\\,0\\,0\\,0\\,Regular" textColor="#000000" type="Typewriter" width="0"/></engine></tool>,<tool id="6" type="note-inline"><engine block="true" color="#ffff00" hoverIcon="tool-note-inline" type="PickPoint"><annotation color="#ffffff00" font="Noto Sans\\,10\\,-1\\,5\\,50\\,0\\,0\\,0\\,0\\,0\\,Regular" type="FreeText"/></engine></tool>,<tool id="7" type="note-linked"><engine color="#ffff00" hoverIcon="tool-note" type="PickPoint"><annotation color="#ffffff00" icon="Note" type="Text"/></engine></tool>,<tool id="8" type="ink"><engine color="#000000" type="SmoothLine"><annotation color="#000000" type="Ink" width="2"/></engine></tool>,<tool id="9" name="Arrow" type="straight-line"><engine color="#000000" points="2" type="PolyLine"><annotation color="#ff000000" endStyle="3" type="Line" width="2"/></engine></tool>,<tool id="10" type="straight-line"><engine color="#000000" points="2" type="PolyLine"><annotation color="#ff000000" type="Line" width="2"/></engine></tool>,<tool id="11" type="rectangle"><engine block="true" color="#ff0000" type="PickPoint"><annotation color="#ffff0000" type="GeomSquare" width="3"/></engine></tool>,<tool id="12" type="ellipse"><engine block="true" color="#00ffff" type="PickPoint"><annotation color="#ff00ffff" type="GeomCircle" width="3"/></engine></tool>,<tool id="13" type="polygon"><engine color="#007eee" points="-1" type="PolyLine"><annotation color="#ff007eee" type="Line" width="2"/></engine></tool>,<tool id="14" type="stamp"><engine block="true" size="64" type="PickPoint"><annotation type="Stamp"/></engine></tool>
      QuickAnnotationTools=<tool id="1" type="ink"><engine color="#ff000000" type="SmoothLine"><annotation color="#ff000000" type="Ink" width="2"/></engine><shortcut>1</shortcut></tool>,<tool id="2" type="ink"><engine color="#ffff0000" type="SmoothLine"><annotation color="#ffff0000" type="Ink" width="2"/></engine><shortcut>2</shortcut></tool>,<tool default="true" id="3" name="Yellow Highlighter" type="highlight"><engine color="#ffff00" type="TextSelector"><annotation color="#ffffff00" type="Highlight"/></engine><shortcut>3</shortcut></tool>,<tool default="true" id="4" name="Green Highlighter" type="highlight"><engine color="#00ff00" type="TextSelector"><annotation color="#ff00ff00" type="Highlight"/></engine><shortcut>4</shortcut></tool>,<tool id="5" name="Black Highlighter" type="highlight"><engine color="#ff000000" type="TextSelector"><annotation color="#ff000000" type="Highlight"/></engine><shortcut>5</shortcut></tool>,<tool id="6" type="underline"><engine color="#ff0000" type="TextSelector"><annotation color="#ffff0000" type="Underline"/></engine><shortcut>6</shortcut></tool>,<tool default="true" id="7" name="Insert Text" type="typewriter"><engine block="true" type="PickPoint"><annotation color="#00ffffff" textColor="#000000" type="Typewriter" width="0"/></engine><shortcut>7</shortcut></tool>,<tool id="8" type="note-inline"><engine block="true" color="#ffff00" hoverIcon="tool-note-inline" type="PickPoint"><annotation color="#ffffff00" textColor="#ff000000" type="FreeText"/></engine><shortcut>8</shortcut></tool>,<tool id="9" type="note-linked"><engine color="#ffff00" hoverIcon="tool-note" type="PickPoint"><annotation color="#ffffff00" icon="Note" type="Text"/></engine><shortcut>9</shortcut></tool>
    '';

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".local/share/okular"
      ];
    };
  };
}
