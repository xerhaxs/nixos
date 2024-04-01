{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    desktop.desktopEnvironment.gnome = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Enable Gnome desktop environment.";
      };
    };
  };

  config = mkIf config.nixos.desktop.desktopEnvironment.gnome.enable {
    services.xserver.desktopManager.gnome = {
      enable = true;
    };

    programs.dconf.enable = true;

    services.udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
    ];

    environment = {
      gnome.excludePackages = with pkgs; with gnome; [
        cheese
        epiphany
        geary
        gnome-photos
        gnome-characters
        gnome-tour
        totem
        gnome-music
        gnome-maps
        gnome-weather
        seahorse
      ];
    };

    # systemPackages = with pkgs; [
  #     adw-gtk3
  #     gnome.gnome-tweaks
  #     gnome.gnome-terminal			# Gnome terminal emulator
  #     gnome.gedit				        # Gnome texteditor
  #     gnome-usage				        # Gnome task manager
  #     gnome.simple-scan			    # Gnome scanning utility
  #      gnome.gvfs				
  #      endeavour
  #      gnome.gnome-tweaks
  #      gnomeExtensions.appindicator
  #      gnomeExtensions.clipboard-indicator
  #      gnomeExtensions.privacy-settings-menu
  #	  gnomeExtensions.appindicator
  #	  gnome.gnome-shell-extensions
  #	  gnomeExtensions.gsconnect
  #	  gnomeExtensions.caffeine
  #	  gnomeExtensions.sound-output-device-chooser
  #	  gnomeExtensions.vlan-switcher
  #	  gnomeExtensions.trash
  #	  gnomeExtensions.vitals
  #	  gnomeExtensions.trash
  #	  gnomeExtensions.gtk4-desktop-icons-ng-ding
  #      gnomeExtensions.x11-gestures
      #gnomeExtensions.forge
  #	  gnomeExtensions.tiling-assistant
  #	  gnomeExtensions.media-controls
      #gnomeExtensions.battery-time-percentage-compact
  #	  gnome.gnome-power-manager
      #gnomeExtensions.gamemode
  #     gnomeExtensions.syncthing-indicator
    # ];
  };
}
