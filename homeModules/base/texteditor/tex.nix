 { config, lib, pkgs, ... }:

 {
  options.homeManager = {
    base.texteditor.tex = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable tex.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.texteditor.tex.enable {
    home.packages = with pkgs; [
      lmodern
    ];

    programs.texlive = {
      enable = true;
      packageSet = pkgs.texliveFull
    };
  };
}

