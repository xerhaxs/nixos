{ config, lib, pkgs, ... }:

{
  options.nixos = {
    hardware.corectrl = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable corectrl.";
      };
    };
  };

  config = lib.mkIf config.nixos.hardware.corectrl.enable {
    programs.corectrl = {
      enable = true;
      gpuOverclock.enable = true;
      gpuOverclock.ppfeaturemask = "0xfff7ffff";
    };
  };
}
