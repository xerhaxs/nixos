{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    desktop.windowManager.hyprland.display = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable kanshi (monitor profiles) and hyprsunset (blue light filter).";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.windowManager.hyprland.display.enable {
    services.kanshi.enable = true;

    services.hyprsunset = {
      enable = true;
      settings = {
        profile = [
          {
            time = "7:00";
            identity = true;
          }
          {
            time = "21:00";
            temperature = 4000;
          }
        ];
      };
    };
  };
}
