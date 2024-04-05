{ config, lib, pkgs, ... }:

{
  options.nixos = {
    desktop.desktopEnvironment.xfce = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable XFCE desktop environment.";
      };
    };
  };

  config = lib.mkIf config.nixos.desktop.desktopEnvironment.xfce.enable {
    services.xserver.desktopManager.xfce = {
      enable = true;
      enableXfwm = true;
      noDesktop = false;
      enableScreensaver = true;
    };

    programs = {
      thunar = {
        enable = true;
        plugins = with pkgs.xfce; [
          thunar-volman
          thunar-archive-plugin
          thunar-media-tags-plugin
        ];
      };
      xfconf.enable = true;
    };

    #environment.xfce.excludePackages = with pkgs; [ ];
  };
}
