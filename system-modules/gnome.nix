{ config, pkgs, ... }:

{
  services.xserver = {
    desktopManager = {
      gnome.enable = true;
    };
  };

#  qt.platformTheme = "gnome";

  programs.dconf.enable = true;

  services.udev.packages = with pkgs; [
    gnome.gnome-settings-daemon
  ];

  environment = {
    gnome.excludePackages = with pkgs; [
      gnome.cheese
      epiphany
      gnome.geary
      gnome-photos
      gnome.gnome-characters
      gnome-tour
      gnome.totem
      gnome.gnome-music
      gnome.gnome-maps
      gnome.gnome-weather
      gnome.seahorse
    ];

    systemPackages = with pkgs; [
      adw-gtk3
 #     gnome.gnome-tweaks
 #     gnome.gnome-terminal			# Gnome terminal emulator
 #     gnome.gedit				        # Gnome texteditor
 #     gnome-usage				        # Gnome task manager
 #     gnome.simple-scan			    # Gnome scanning utility
      gnome.gvfs				
      endeavour
      gnome.gnome-tweaks
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
    ];
  };
}
