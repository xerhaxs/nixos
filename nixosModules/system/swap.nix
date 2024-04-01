{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    system.swap = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable Swap file";
      };
    };
  };

  config = mkIf config.nixos.system.swap.enable {
    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = 4*1024;
      }
    ];
  };
}