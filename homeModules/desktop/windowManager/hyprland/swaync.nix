{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    desktop.windowManager.hyprland.swaync = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable SwayNotificationCenter.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.windowManager.hyprland.swaync.enable {
    # swaync registers as D-Bus activator of org.freedesktop.Notifications, the first notification
    # in Plasma would start it and push out plasmashell.
    systemd.user.services.swaync.Unit.ConditionEnvironment = lib.mkForce [
      "WAYLAND_DISPLAY"
      "XDG_CURRENT_DESKTOP=Hyprland"
    ];

    services.swaync = {
      enable = true;
      settings = {
        positionX = "right";
        positionY = "top";
        layer = "overlay";
        control-center-layer = "overlay";
        control-center-margin-top = 8;
        control-center-margin-bottom = 14;
        control-center-margin-right = 14;
        notification-window-margin-top = 8;
        notification-window-margin-right = 14;
        control-center-width = 420;
        notification-window-width = 400;
        timeout = 8;
        timeout-low = 4;
        timeout-critical = 0;
        fit-to-screen = true;
        hide-on-clear = true;
        widgets = [
          "inhibitors"
          "title"
          "dnd"
          "mpris"
          "volume"
          "backlight"
          "notifications"
        ];
        widget-config = {
          title = {
            text = "Notifications";
            clear-all-button = true;
            button-text = "Clear";
          };
          dnd.text = "Do not disturb";
          mpris = {
            image-size = 96;
            image-radius = 12;
          };
          volume.label = "󰕾";
          backlight.label = "󰃟";
        };
      };
    };
  };
}
