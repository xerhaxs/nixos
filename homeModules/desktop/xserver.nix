{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    desktop.xserver = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable xserver settings.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.xserver.enable {
    home.packages = with pkgs; [
      xorg.xkill # Alternative on Wayland (Kwin): Ctrl+Meta+ESC
    ];

    xresources.properties = {
      "Xcursor.size" = 16;
      "Xft.dpi" = 100;
    };
  };
}
