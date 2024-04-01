{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    virtualisation.waydroid = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable waydroid virtualisation.";
      };
    };
  };

  config = mkIf config.nixos.virtualisation.waydroid.enable {
    virtualisation.waydroid.enable = true;
  };
}

