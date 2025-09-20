{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    base.tools.git = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable git.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.tools.git.enable {
    programs.git = {
      enable = true;
      userName = "xerhaxs";
      userEmail = "xerhaxs@protonmail.com";
    };
    
    home.packages = with pkgs; [
      bfg-repo-cleaner
      gh
    ];

    #catppuccin.gitui.enable = lib.mkIf config.homeManager.theme.catppuccin.enable true;
  };
}
