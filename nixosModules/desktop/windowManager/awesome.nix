{ config, lib, pkgs, ... }:

{
  options.nixos = {
    desktop.windowManager.awesome = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable awesome windowManager.";
      };
    };
  };

  config = lib.mkIf config.nixos.desktop.windowManager.awesome.enable {
  };
}
