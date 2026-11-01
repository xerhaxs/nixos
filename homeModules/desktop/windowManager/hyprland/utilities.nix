{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    desktop.windowManager.hyprland.utilities = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Hyprland utilities (polkit agent, clipboard history, image viewer, color picker, media and brightness tools).";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.windowManager.hyprland.utilities.enable {
    home.packages = with pkgs; [
      brightnessctl
      hyprpicker
      nwg-look
      pavucontrol
      playerctl
      wl-clipboard
    ];

    programs.imv.enable = true;

    services.cliphist.enable = true;

    services.hyprpolkitagent.enable = true;

    services.playerctld.enable = true;
  };
}
