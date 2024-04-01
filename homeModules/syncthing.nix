{ config, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    tray.enable = false;
    extraOptions = [
      "--gui-theme=black"
    ];
  };
}
