{ config, pkgs, ... }:

{
  services.flatpak = {
    enable = true;
  };

  services.accounts-daemon.enable = true;
}
