{ config, lib, pkgs, ... }:

{
  services.syncthing.settings = {
    devices = {
      "NixOS-Desktop" = { id = "GJBFJEC-CUEZR5R-JSXR4TC-SL7YEMY-7XN3KED-TN2BUWQ-XFXRUEY-53GRVQD"; };
      "NixOS-Framework" = { id = "WHYZC63-JGGKAUV-EQAB3BE-65RUAQX-FVI7N4B-TIP25KW-J3VBW5C-XFHIDAG"; };
      "NixOS-Laptop" = { id = "TZIANB3-KBIIN5E-4ADBVLO-6MSC3WJ-U3CTUVW-ERAW4NC-FCKT7KE-KX6ZBQ4"; };
      "GraphenOS" = { id = "NLYJGXH-QP27NVE-4JOX67Q-4XNQHG2-2RGX5LX-I6GL5XN-WU3EVG2-KWM6VQI"; };
      "TrueNAS" = { id = "LMEZBBC-HF2UMGH-OKVAIGH-XG3JVYW-GWW5CZQ-7C547HZ-GTRWGRA-7PB7OQR"; };
    };

    folders = {
      "Bilder" = {
        enable = true;
        path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.pictures}";
        rescanIntervalS = 60;
        fsWatcherEnabled = true;
        ignorePerms = true;
        type = "sendandreceive"; # receiveonly sendonly sendandreceive
        devices = [ "NixOS-Framework" "NixOS-Laptop" "TrueNAS" ];
      };
      "Dokumente" = {
        enable = true;
        path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.documents}";
        rescanIntervalS = 60;
        fsWatcherEnabled = true;
        ignorePerms = true;
        type = "sendandreceive";
        devices = [ "NixOS-Framework" "NixOS-Laptop" "TrueNAS" ];
      };
      "Downloads" = {
        enable = true;
        path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.download}";
        rescanIntervalS = 60;
        fsWatcherEnabled = true;
        ignorePerms = true;
        type = "sendandreceive";
        devices = [ "NixOS-Framework" "NixOS-Laptop" "GraphenOS" "TrueNAS" ];
      };
      "Musik" = {
        enable = true;
        path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.music}";
        rescanIntervalS = 60;
        fsWatcherEnabled = true;
        ignorePerms = true;
        type = "sendandreceive";
        devices = [ "NixOS-Framework" "NixOS-Laptop" "TrueNAS" ];
      };
      "Videos" = {
        enable = false;
        path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.videos}";
        rescanIntervalS = 60;
        fsWatcherEnabled = true;
        ignorePerms = true;
        type = "sendandreceive";
        devices = [ "NixOS-Framework" "NixOS-Laptop" "TrueNAS" ];
      };

      "Sops" = {
        enable = true;
        path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.home.homeDirectory}/.config/sops";
        rescanIntervalS = 60;
        fsWatcherEnabled = true;
        ignorePerms = true;
        type = "sendandreceive";
        devices = [ "NixOS-Framework" "NixOS-Laptop" "TrueNAS" ];
      };
      "FreeTube" = {
        enable = true;
        path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.home.homeDirectory}/.config/FreeTube";
        rescanIntervalS = 60;
        fsWatcherEnabled = true;
        ignorePerms = true;
        type = "sendandreceive";
        devices = [ "NixOS-Framework" "NixOS-Laptop" "TrueNAS" ];
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