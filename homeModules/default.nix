{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
      description = "Enable homeManager modules bundle.";
    };
  };

  config = lib.mkIf config.homeManager.enable {
    imports = [
      ./applications
      ./base
      ./desktop
      ./home
      ./theme
    ];
  };
}
