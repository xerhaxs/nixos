{ pkgs, ... }:

{
  services.xserver = {
    enable = true; # if gdm fails to start, xserver needs to be enabled
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
        autoSuspend = false;
        #settings = {};
      };
      defaultSession = "gnome";
      #setupCommands = ""; # commands to run after displayManager has launched
    };
  };
}
