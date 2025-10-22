{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.development.imager = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable imager tools.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.development.imager.enable {
    home.packages = with pkgs; [
      rpi-imager
      ventoy
      woeusb # A windows image writer for linux
    ];
  };
}
