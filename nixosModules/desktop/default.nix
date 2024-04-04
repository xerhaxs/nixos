{ config, lib, pkgs, ... }:

{
  options.nixos = {
    desktop = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable desktop modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.desktop.enable {
    imports = [
      ./desktopEnvironment
      ./displayManager
      ./windowManager
      ./xdg.nix
      ./xserver.nix
    ];
  };
}
