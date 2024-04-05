{ config, lib, pkgs, flatpak, ... }:

{
  services.flatpak = {
    packages = [
      "com.heroicgameslauncher.hgl"
    ];
  };
}