{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:

{
  imports = [
    ./plasma6.nix
  ];

  options.homeManager = {
    desktop.desktopEnvironment.plasma6 = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable plasma6 modules bundle.";
      };
    };
  };

  config =
    lib.mkIf
      (
        config.homeManager.desktop.desktopEnvironment.plasma6.enable
        && osConfig.nixos.desktop.desktopEnvironment.plasma6.enable
      )
      {
        homeManager.desktop.desktopEnvironment.plasma6 = {
          plasma6.enable = true;
        };
      };
}
