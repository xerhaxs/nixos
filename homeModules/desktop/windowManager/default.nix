{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hyprland
  ];

  options.homeManager = {
    desktop.windowManager = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable windowManager modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.windowManager.enable {
    homeManager.desktop.windowManager = {
      hyprland.enable = true;
    };
  };
}
