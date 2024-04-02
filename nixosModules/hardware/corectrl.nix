{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    hardware.corectrl = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Enable corectrl.";
      };
    };
  };

  config = mkIf config.nixos.hardware.corectrl.enable {
    programs.corectrl = {
      enable = true;
      gpuOverclock.enable = true;
      gpuOverclock.ppfeaturemask = "0xfff7ffff";
    };
  };
}
