{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    desktop.windowManager.awesome = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Enable awesome windowManager.";
      };
    };
  };

  config = mkIf config.nixos.desktop.windowManager.awesome.enable {
  };
}
