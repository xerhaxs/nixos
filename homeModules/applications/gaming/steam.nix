{ config, lib, pkgs, flatpak, ... }:

{
  services.flatpak = {
    packages = [
      "com.valvesoftware.Steam"
    ];
    
    preSwitchCommand = [
      "com.valvesoftware.Steam:flatpak override --user --filesystem=/mount/Games/Spiele/Steam/ com.valvesoftware.Steam"
    ];
  };
}