 { config, lib, pkgs, ... }:

 {
  options.homeManager = {
    base.texteditor.tex = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable tex.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.texteditor.tex.enable {
    home.packages = with pkgs; [
      lmodern
      texliveFull
    ];

    #programs.texlive = {
    #  enable = true;
    #};
  };
}

