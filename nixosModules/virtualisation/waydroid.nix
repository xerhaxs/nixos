{ config, lib, pkgs, ... }:

{
  options.nixos = {
    virtualisation.waydroid = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable waydroid virtualisation.";
      };
    };
  };

  config = lib.mkIf config.nixos.virtualisation.waydroid.enable {
    virtualisation.waydroid.enable = true;
  };
}

