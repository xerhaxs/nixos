{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    desktop = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable desktop modules bundle.";
      };
    };
  };

  config = mkIf config.nixos.desktop.enable {
    imports = [
      ./desktopEnvironment
      ./displayManager
      ./windowManager
    ];
  };
}
