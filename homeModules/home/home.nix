{ config, lib, osConfig, pkgs, ... }:

{
  imports = [
    ../../hosts/${osConfig.networking.hostName}/home/default.nix
  ];

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
      username = "${osConfig.nixos.system.user.defaultuser.name}";
      homeDirectory = "/home/${osConfig.nixos.system.user.defaultuser.name}";
      stateVersion = "25.05";
    };

    programs.home-manager.enable = true;
  };
}