{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.development.raspberry = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable Raspberry PI Imager.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.development.raspberry.enable {
    home.packages = with pkgs; [
      rpi-imager
    ];
  };
}
