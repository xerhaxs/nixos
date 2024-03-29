{ pkgs, ... }:

{
  services.xserver = {
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
