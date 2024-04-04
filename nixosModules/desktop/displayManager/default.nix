{ config, lib, pkgs, ... }:

{
  options.nixos = {
    desktop.displayManager = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable displayManager modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.desktop.displayManager.enable {
    imports = [
      ./gdm.nix
      ./sddm.nix
    ];
  };
}
