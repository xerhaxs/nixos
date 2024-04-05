{ config, lib, pkgs, ... }:

{
  options.nixos = {
    hardware.openrgb = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable openrgb.";
      };
    };
  };

  config = lib.mkIf config.nixos.hardware.openrgb.enable {
    services.hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
    };
  };
}
