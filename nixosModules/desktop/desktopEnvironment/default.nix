{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./plasma6.nix
  ];

  options.nixos = {
    desktop.desktopEnvironment = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable desktopEnvironment modules bundle.";
      };
    };
  };
}
