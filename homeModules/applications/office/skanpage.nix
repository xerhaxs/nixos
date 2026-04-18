{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.office.skanpage = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable skanpage.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.office.skanpage.enable {
    home.packages = with pkgs; [
      (symlinkJoin {
        name = "skanpage-with-tesseract";
        paths = [ kdePackages.skanpage ];
        buildInputs = [ makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/skanpage \
            --prefix PATH : ${tesseract}/bin \
            --set TESSDATA_PREFIX ${tesseract}/share/tessdata
        '';
      })
    ];

    xdg.configFile."skanpagerc".text = ''
      [General]
      defaultFolder=file://${config.xdg.userDirs.desktop}
      nameTemplate=$[YYYY]-$[MM]-$[DD]_$[hh]_$[mm]_$[ss]
    '';

    home.file.".local/state/skanpagerc".text = ''
      [UiSettings]
      showAllOptions=true
    '';
  };
}
