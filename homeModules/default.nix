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
      default = false;
      example = true;
      description = "Enable homeManager modules bundle.";
    };
  };

  config = lib.mkIf config.homeManager.enable {
    homeManager = {
      applications.enable = true;
      base.enable = true;
      desktop.enable = true;
      home.enable = true;
      theme.enable = true;
    };
  };
}
