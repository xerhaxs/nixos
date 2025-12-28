{ config, lib, pkgs, ... }:

{
  imports = [
    ./gdm.nix
    ./sddm.nix
  ];

  options.nixos = {
    desktop.displayManager = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable displayManager modules bundle.";
      };
      defaultSession = lib.mkOption {
        type = lib.types.str;
        example = "plasma";
        description = "Set the default session for display manager.";
      };
    };
  };

  config = lib.mkIf config.nixos.desktop.displayManager.enable {
    nixos.desktop.displayManager = {
      gdm.enable = false;
      sddm.enable = true;
    };
  };
}
