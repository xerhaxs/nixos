{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    base.shell.zsh = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable zsh.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.shell.zsh.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting = {
        enable = true;
        catppuccin.enable = lib.mkIf config.homeManager.theme.catppuccin.enable true;
      };
    };
  };
}
