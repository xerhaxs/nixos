{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.development.singleboardcomputer = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Single-Board Computer software.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.development.singleboardcomputer.enable {
    home.packages = with pkgs; [
      arduino-ide
      esphome
      fritzing
      rpi-imager
    ];
  };
}
