{ config, lib, osConfig, pkgs, ... }:

{
  options.homeManager = {
    home.home = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable home settings.";
      };
    };
  };

  config = lib.mkIf config.homeManager.home.home.enable {
    home = {
      username = "${osConfig.defaultuser.name}";
      homeDirectory = "/home/" + osConfig.defaultuser.name;
      stateVersion = "24.05";
    };

    programs.home-manager.enable = true;
  };
}