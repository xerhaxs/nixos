{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    desktop.desktopEnvironment.gnome.dconf = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable dconf.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.desktopEnvironment.gnome.dconf.enable {
    dconf.settings = {
      "org/gnome/desktop/wm.preferences" = {
        button-layout = "close,minimize,maximize";
      };

      "org/gnome/shell" = {
        favorite-apps = [
          "librewolf.desktop"
          "org.gnome.Terminal.desktop"
          "virt-manager.desktop"
          "org.gnome.Nautilus.desktop"
        ];

  #     "/org/gnome/mutter" = {
  #       dynamic-workspaces = true;
  #     };

  #     "/system/locale/region" = [
  #       "de_DE.UTF-8"
  #     ];

  #     "/org/gnome/desktop/interface/" = {
  #       locate-pointer = true;
  #     };

        disable-user-extensions = false;

        enabled-extensions = [
          "user-theme@gnome-shell-extensions.gcampax.github.com"
          "trayIconsReloaded@selfmade.pl"
          "Vitals@CoreCoding.com"
          "dash-to-panel@jderose9.github.com"
          "sound-output-device-chooser@kgshank.net"
          "space-bar@luchrioh"
        ];
      };

      "org/gnome/calculator" = {
        button-mode = "programming";
        show-thousands = true;
        base = 10;
        word-size = 64;
        #window-position = lib.hm.gvariant.mkTuple [100 100];
      };
    };

    home.packages = with pkgs; [
      gnomeExtensions.user-themes
      gnomeExtensions.tray-icons-reloaded
      gnomeExtensions.vitals
      gnomeExtensions.dash-to-panel
      gnomeExtensions.sound-output-device-chooser
      gnomeExtensions.space-bar
    ];
  };
}
