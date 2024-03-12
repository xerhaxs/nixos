{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    papirus-icon-theme
  ];

  boot.plymouth.enable = true;
}
