{ config, lib, pkgs, ... }:

{
  services.syncthing.settings = {
    devices = {
      "NixOS-Desktop" = { id = "GJBFJEC-CUEZR5R-JSXR4TC-SL7YEMY-7XN3KED-TN2BUWQ-XFXRUEY-53GRVQD"; };
      "NixOS-Framework" = { id = "D3M37EV-OQ2WP7T-3PFWSDE-E7DQ74B-LSCQ6DL-75GFL2B-6KBRSAQ-POCUWQH"; };
      "NixOS-Laptop" = { id = "TZIANB3-KBIIN5E-4ADBVLO-6MSC3WJ-U3CTUVW-ERAW4NC-FCKT7KE-KX6ZBQ4"; };
      "GraphenOS" = { id = "NLYJGXH-QP27NVE-4JOX67Q-4XNQHG2-2RGX5LX-I6GL5XN-WU3EVG2-KWM6VQI"; };
    };

    folders = {
      "Bilder" = {
        enable = true;
        path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.pictures}";
        rescanIntervalS = 60;
        fsWatcherEnabled = true;
        ignorePerms = true;
        type = "sendandreceive"; # receiveonly sendonly sendandreceive
        devices = [ "NixOS-Framework" "NixOS-Laptop" ];
      };
      "Dokumente" = {
        enable = true;
        path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.documents}";
        rescanIntervalS = 60;
        fsWatcherEnabled = true;
        ignorePerms = true;
        type = "sendandreceive";
        devices = [ "NixOS-Framework" "NixOS-Laptop" ];
      };
      "Downloads" = {
        enable = true;
        path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.download}";
        rescanIntervalS = 60;
        fsWatcherEnabled = true;
        ignorePerms = true;
        type = "sendandreceive";
        devices = [ "NixOS-Framework" "NixOS-Laptop" "GraphenOS" ];
      };
      "Musik" = {
        enable = true;
        path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.music}";
        rescanIntervalS = 60;
        fsWatcherEnabled = true;
        ignorePerms = true;
        type = "sendandreceive";
        devices = [ "NixOS-Framework" "NixOS-Laptop" ];
      };
      "Videos" = {
        enable = false;
        path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.videos}";
        rescanIntervalS = 60;
        fsWatcherEnabled = true;
        ignorePerms = true;
        type = "sendandreceive";
        devices = [ "NixOS-Framework" "NixOS-Laptop" ];
      };

      "Sops" = {
        enable = true;
        path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.home.homeDirectory}/.config/sops";
        rescanIntervalS = 60;
        fsWatcherEnabled = true;
        ignorePerms = true;
        type = "sendandreceive";
        devices = [ "NixOS-Framework" "NixOS-Laptop" ];
      };
      "FreeTube" = {
        enable = true;
        path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.home.homeDirectory}/.config/FreeTube";
        rescanIntervalS = 60;
        fsWatcherEnabled = true;
        ignorePerms = true;
        type = "sendandreceive";
        devices = [ "NixOS-Framework" "NixOS-Laptop" ];
      };

      "Pixel 6a Dokumente" = {
        enable = true;
        path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.documents}/Wichtige Datein";
        rescanIntervalS = 60;
        fsWatcherEnabled = true;
        ignorePerms = true;
        type = "sendonly";
        devices = [ "GraphenOS" ];
      };
      "Pixel 6a Kamera" = {
        enable = true;
        path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.pictures}/Pixel 6a Kamera/";
        rescanIntervalS = 60;
        fsWatcherEnabled = true;
        ignorePerms = true;
        type = "sendandreceive";
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
        path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.music}/Musik/Musik MP3";
        rescanIntervalS = 60;
        fsWatcherEnabled = true;
        ignorePerms = true;
        type = "sendonly";
        devices = [ "GraphenOS" ];
      };
    };
  };
}