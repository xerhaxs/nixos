{ config, lib, pkgs, ... }:

{
  services.syncthing.settings.folders = {
    "Bilder" = {
      enable = true;
      path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.pictures}";
      rescanIntervalS = 60;
      fsWatcherEnabled = true;
      ignorePerms = true;
      type = "sendonly";
      devices = [ "NixOS-Framework" "NixOS-Laptop" ];
    };
    "Dokumente" = {
      enable = true;
      path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.documents}";
      rescanIntervalS = 60;
      fsWatcherEnabled = true;
      ignorePerms = true;
      type = "sendonly";
      devices = [ "NixOS-Framework" "NixOS-Laptop" ];
    };
    "Downloads" = {
      enable = true;
      path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.download}";
      rescanIntervalS = 60;
      fsWatcherEnabled = true;
      ignorePerms = true;
      type = "sendonly";
      devices = [ "NixOS-Framework" "NixOS-Laptop" ];
    };
    "Musik" = {
      enable = true;
      path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.music}";
      rescanIntervalS = 60;
      fsWatcherEnabled = true;
      ignorePerms = true;
      type = "sendonly";
      devices = [ "NixOS-Framework" "NixOS-Laptop" ];
    };
    "Videos" = {
      enable = false;
      path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.videos}";
      rescanIntervalS = 60;
      fsWatcherEnabled = true;
      ignorePerms = true;
      type = "sendonly";
      devices = [ "NixOS-Framework" "NixOS-Laptop" ];
    };
    "FreeTube" = {
      enable = true;
      path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.home.homeDirectory}/.config/FreeTube";
      rescanIntervalS = 60;
      fsWatcherEnabled = true;
      ignorePerms = true;
      type = "sendonly";
      devices = [ "NixOS-Framework" "NixOS-Laptop" ];
    };
    "Pixel 6a Kamera" = {
      enable = true;
      path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.pictures}/Pixel 6a Kamera/";
      rescanIntervalS = 60;
      fsWatcherEnabled = true;
      ignorePerms = true;
      type = "receiveonly";
      devices = [ "GraphenOS" ];
    };
    "Pixel 6a Hörbücher" = {
      enable = false;
      path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.music}/Hörbücher";
      rescanIntervalS = 60;
      fsWatcherEnabled = true;
      ignorePerms = true;
      type = "sendonly";
      devices = [ "GraphenOS" ];
    };
    "Pixel 6a Musik" = {
      enable = true;
      path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.music}/Musik MP3";
      rescanIntervalS = 60;
      fsWatcherEnabled = true;
      ignorePerms = true;
      type = "sendonly";
      devices = [ "GraphenOS" ];
    };
  };
}