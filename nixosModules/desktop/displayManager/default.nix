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
      defaultSession = lib.mkOption {
        type = lib.types.str;
        default = "hyprland";
        example = "plasma";
        description = "Set the default session for display manager.";
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
