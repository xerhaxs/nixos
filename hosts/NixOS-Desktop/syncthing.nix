{ config, lib, pkgs, ... }:

{
  services.syncthing.settings = {
    devices = {
      "NixOS-Desktop" = { id = ""; };
      "NixOS-Framework" = { id = ""; };
      "GraphenOS" = { id = ""; };
      "TrueNAS" = { id = ""; };
    };

    folders = {
      "Bilder" = {
        enable = true;
        path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.pictures}";
        rescanIntervalS = 60;
        fsWatcherEnabled = true;
        ignorePerms = true;
        type = "sendreceive"; # receiveonly sendonly sendreceive
        #devices = [ "NixOS-Framework" "NixOS-Laptop" "TrueNAS" ];
      };
      "Desktop" = {
        enable = true;
        path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.desktop}";
        rescanIntervalS = 60;
        fsWatcherEnabled = true;
        ignorePerms = true;
        type = "sendreceive"; # receiveonly sendonly sendreceive
        #devices = [ "NixOS-Framework" "NixOS-Laptop" "TrueNAS" ];
      };
      "Dokumente" = {
        enable = true;
        path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.documents}";
        rescanIntervalS = 60;
        fsWatcherEnabled = true;
        ignorePerms = true;
        type = "sendreceive";
        #devices = [ "NixOS-Framework" "NixOS-Laptop" "TrueNAS" ];
      };
      "Downloads" = {
        enable = true;
        path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.download}";
        rescanIntervalS = 60;
        fsWatcherEnabled = true;
        ignorePerms = true;
        type = "sendreceive";
        #devices = [ "NixOS-Framework" "NixOS-Laptop" "GraphenOS" "TrueNAS" ];
      };
      "Musik" = {
        enable = true;
        path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.music}";
        rescanIntervalS = 60;
        fsWatcherEnabled = true;
        ignorePerms = true;
        type = "sendreceive";
        #devices = [ "NixOS-Framework" "NixOS-Laptop" "TrueNAS" ];
      };
      "Videos" = {
        enable = false;
        path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.videos}";
        rescanIntervalS = 60;
        fsWatcherEnabled = true;
        ignorePerms = true;
        type = "sendreceive";
        #devices = [ "NixOS-Framework" "NixOS-Laptop" "TrueNAS" ];
      };

      "Sops" = {
        enable = true;
        path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.home.homeDirectory}/.config/sops";
        rescanIntervalS = 60;
        fsWatcherEnabled = true;
        ignorePerms = true;
        type = "sendreceive";
        #devices = [ "NixOS-Framework" "NixOS-Laptop" "TrueNAS" ];
      };
      "FreeTube" = {
        enable = true;
        path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.home.homeDirectory}/.config/FreeTube";
        rescanIntervalS = 60;
        fsWatcherEnabled = true;
        ignorePerms = true;
        type = "sendreceive";
        #devices = [ "NixOS-Framework" "NixOS-Laptop" "TrueNAS" ];
      };

      #"Pixel 6a Dokumente" = {
        #enable = true;
        #path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.documents}/Wichtige Datein";
        #rescanIntervalS = 60;
        #fsWatcherEnabled = true;
        #ignorePerms = true;
        #type = "sendonly";
        #devices = [ "GraphenOS" ];
      #};
      #"Pixel 6a Kamera" = {
        #enable = true;
        #path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.pictures}/Pixel 6a Kamera/";
        #rescanIntervalS = 60;
        #fsWatcherEnabled = true;
        #ignorePerms = true;
        #type = "sendreceive";
        #devices = [ "GraphenOS" ];
      #};
      #"Pixel 6a Hörbücher" = {
        #enable = false;
        #path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.music}/Hörbücher";
        #rescanIntervalS = 60;
        #fsWatcherEnabled = true;
        #ignorePerms = true;
        #type = "sendonly";
        #devices = [ "GraphenOS" ];
      #};
      #"Pixel 6a Musik" = {
        #enable = true;
        #path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.music}/Musik/Musik MP3";
        #rescanIntervalS = 60;
        #fsWatcherEnabled = true;
        #ignorePerms = true;
        #type = "sendonly";
        #devices = [ "GraphenOS" ];
      #};
    };
  };
}