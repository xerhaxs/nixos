{ config, lib, pkgs, ... }:

{
  options = {
    options.services.xserver.desktopManager.plasma5.wallpaperEngineKde.enable = config.lib.mkOption {
      type = config.types.bool;
      default = false;
      description = "Activate the kde wallpaper engine plugin.";
    };
  };

  config = {
    imports = if config.services.xserver.desktopManager.plasma5.wallpaperEngineKde.enable then
      [ ./pkgs/wallpaper-engine-kde-plugin.nix ]
  };
}