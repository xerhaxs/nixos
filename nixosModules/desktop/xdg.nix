{ config, lib, pkgs, ... }:

{
  options.nixos = {
    desktop.xdg = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable XDG Portal settings.";
      };
    };
  };

  config = lib.mkIf config.nixos.desktop.xdg.enable {
    xdg = {
      portal = {
        enable = true;
        wlr = {
          enable = true;
          #settings = {};
        };
        extraPortals = with pkgs; [
          #xdg-desktop-portal-kde
          xdg-desktop-portal-gtk
        ];
        config.common.default = "*";
      };

      autostart.enable = true;
    };
  };
}
