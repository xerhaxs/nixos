{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    base = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable base modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.enable {
    imports = [
      ./fonts
      ./shell
      ./texteditor
      ./tools
    ];
  };
}