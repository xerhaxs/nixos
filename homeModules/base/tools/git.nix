{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    base.tools.git = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
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
  };
}
