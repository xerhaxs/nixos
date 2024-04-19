{ config, lib, pkgs, ... }:

{
  imports = [
    ./applications
    ./base
    ./desktop
    ./home
    ./theme
  ];

  options.homeManager = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
      description = "Enable homeManager modules bundle.";
    };
  };

  config = lib.mkIf config.homeManager.enable {
    homeManager = {
      applications.enable = false;
      base.enable = true;
      desktop.enable = true;
      home.enable = true;
      theme.enable = true;
    };
  };
}