{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hyprland.nix
  ];

  options.nixos = {
    desktop.windowManager = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable windowManager modules bundle.";
      };
    };
  };
}
