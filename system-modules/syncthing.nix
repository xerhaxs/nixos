{ config, pkgs, ... }:

let
  user = "jf";
  pass = "CHANGEME";
in

{
  #environment.systemPackages = with pkgs; [
    #syncthing
    #syncthingtray
  #];

  services.syncthing = {
    enable = true;
    systemService = true;
    #user = "${user}";
    #group = "root";
    dataDir = "${config.home-manager.users.${config.defaultuser.name}.home.homeDirectory}";
    configDir = config.services.syncthing.dataDir + "/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true; 
    openDefaultPorts = true;

    settings = {
      options = {
        urAccepted = -1;
        globalAnnounceEnabled = true;
        localAnnounceEnabled = true;
        relaysEnabled = true;
        startBrowser = false;
      };

      gui = {
        theme = "black";
        tls = true;
      };

      devices = {
        #"NixOS-Desktop" = { id = "ADDJR6I-6W74LYT-D5OTTWB-YO5IDXN-YRTUS3T-DRXXPCQ-ROJJ7UW-MISBSAP"; };
        "NixOS-Laptop" = { id = "D3M37EV-OQ2WP7T-3PFWSDE-E7DQ74B-LSCQ6DL-75GFL2B-6KBRSAQ-POCUWQH"; };
        "GraphenOS" = { id = "NLYJGXH-QP27NVE-4JOX67Q-4XNQHG2-2RGX5LX-I6GL5XN-WU3EVG2-KWM6VQI"; };
      };

      folders = {
        "Bilder" = {
          path = "${config.home-manager.users.${config.defaultuser.name}.xdg.userDirs.pictures}";
          rescanInterval = 60;
          ignorePerms = true;
          type = "sendonly";
          devices = [ "NixOS-Laptop" ];
        };
        "Dokumente" = {
          path = "${config.home-manager.users.${config.defaultuser.name}.xdg.userDirs.documents}";
          rescanInterval = 60;
          ignorePerms = true;
          type = "sendonly";
          devices = [ "NixOS-Laptop" ];
        };
        "Downloads" = {
          path = "${config.home-manager.users.${config.defaultuser.name}.xdg.userDirs.download}";
          rescanInterval = 60;
          ignorePerms = true;
          type = "sendonly";
          devices = [ "NixOS-Laptop" ];
        };
        "Musik" = {
          path = "${config.home-manager.users.${config.defaultuser.name}.xdg.userDirs.music}";
          rescanInterval = 60;
          ignorePerms = true;
          type = "sendonly";
          devices = [ "NixOS-Laptop" ];
        };
        "Videos" = {
          path = "${config.home-manager.users.${config.defaultuser.name}.xdg.userDirs.videos}";
          rescanInterval = 60;
          ignorePerms = true;
          type = "sendonly";
        #  devices = [ "NixOS-Laptop" ];
        };
        "FreeTube" = {
          path = config.home-manager.users.${config.defaultuser.name}.home.homeDirectory + "/.config/FreeTube";
          rescanInterval = 30;
          ignorePerms = true;
          type = "sendonly";
          devices = [ "NixOS-Laptop" ];
        };
      };
    };
  };
}
