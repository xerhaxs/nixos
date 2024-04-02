{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    desktop.displayManager = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable displayManager modules bundle.";
      };
    };
  };

  config = mkIf config.nixos.desktop.displayManager.enable {
    imports = [
      ./gdm.nix
      ./sddm.nix
    ];
  };
}
