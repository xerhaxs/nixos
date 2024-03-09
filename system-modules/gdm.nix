{ pkgs, ... }:

{
  services.xserver = {
    enable = true; # if gdm fails to start, xserver needs to be enabled
    displayManager = {
      gdm = {
        enable = true;
        banner = "Hello World!";
        wayland = true;
        autoSuspend = true;
        #settings = {};
      };
      defaultSession = "gnome";
      #setupCommands = ""; # commands to run after displayManager has launched
    };
  };
}
