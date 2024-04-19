{ config, lib, pkgs, ... }:

{
  imports = [
    ./fonts
    ./shell
    ./texteditor
    ./tools
  ];

  options.homeManager = {
    base = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable base modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.enable {
    homeManager.base = {
      fonts.enable = true;
      shell.enable = true;
      texteditor.enable = true;
      tools.enable = true;
    };
  };
}