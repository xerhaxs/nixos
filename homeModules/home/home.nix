{ config, lib, osConfig, pkgs, ... }:

{
  options.homeManager = {
    home.home = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable home settings.";
      };
    };
  };

  config = lib.mkIf config.homeManager.home.home.enable {
    home = {
      username = "${osConfig.system.user.defaultuser.name}";
      homeDirectory = "/home/" + osConfig.system.user.defaultuser.name;
      stateVersion = "24.05";
    };

    programs.home-manager.enable = true;
  };
}