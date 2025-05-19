{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.development.arduino = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Arduino IDE.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.development.arduino.enable {
    home.packages = with pkgs; [
      arduino-ide
      esphome
      fritzing
    ];
  };
}
