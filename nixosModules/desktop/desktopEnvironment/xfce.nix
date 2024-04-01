{ config, lib, pkgs, ... }:

{
  options.nixos = {
    desktop.desktopEnvironment.xfce = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Enable XFCE desktop environment.";
      };
    };
  };

  config = mkIf config.nixos.desktop.desktopEnvironment.xfce.enable {
    services.xserver.desktopManager.xfce = {
      enable = true;
      enableXfwm = true;
      noDesktop = false;
      enableScreensaver = true;
    };

    programs = {
      thunar.enable = true;
      xfconf.enable = true;
    };

    #environment.xfce.excludePackages = with pkgs; [ ];
  };
}
