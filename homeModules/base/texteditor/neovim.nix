{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    base.texteditor.neovim = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable neovim.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.texteditor.neovim.enable {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
  };
}
