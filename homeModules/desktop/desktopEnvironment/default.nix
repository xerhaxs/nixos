{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./plasma6
  ];

  options.homeManager = {
    desktop.desktopEnvironment = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable desktopEnvironment modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.desktopEnvironment.enable {
    homeManager.desktop.desktopEnvironment = {
      plasma6.enable = true;
    };
  };
}
