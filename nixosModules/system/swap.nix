{ config, lib, pkgs, ... }:

{
  options.nixos = {
    system.swap = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable Swap file";
      };
    };
  };

  config = lib.mkIf config.nixos.system.swap.enable {
    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = 4*1024;
      }
    ];
  };
}