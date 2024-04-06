{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    desktop.windowManager.awesome.awesome = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable awesome modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.windowManager.awesome.awesome.enable {
    xsession.windowManager.awesome = {
      enable = true;
      #luaModules = with pkgs.luaPackages; [ ];
    };
  };
}