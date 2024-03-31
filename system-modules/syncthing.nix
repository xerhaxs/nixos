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
    dataDir = config.home.homeDirectory;
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
        #"NixOS-PC" = { id = "ADDJR6I-6W74LYT-D5OTTWB-YO5IDXN-YRTUS3T-DRXXPCQ-ROJJ7UW-MISBSAP"; };
        "NixOS-LT" = { id = "D3M37EV-OQ2WP7T-3PFWSDE-E7DQ74B-LSCQ6DL-75GFL2B-6KBRSAQ-POCUWQH"; };
        "GraphenOS-SP" = { id = "NLYJGXH-QP27NVE-4JOX67Q-4XNQHG2-2RGX5LX-I6GL5XN-WU3EVG2-KWM6VQI"; };
      };

      folders = {
        "Bilder" = {
          path = "${config.home-manager.users.${USER}.xdg.userDirs.pictures}";
          rescanInterval = 60;
          ignorePerms = true;
          type = "sendonly";
          devices = [ "NixOS-LT" ];
        };
        "Dokumente" = {
          path = "${config.xdg.userDirs.documents}";
          rescanInterval = 60;
          ignorePerms = true;
          type = "sendonly";
          devices = [ "NixOS-LT" ];
        };
        "Downloads" = {
          path = "${config.xdg.userDirs.download}";
          rescanInterval = 60;
          ignorePerms = true;
          type = "sendonly";
          devices = [ "NixOS-LT" ];
        };
        "Musik" = {
          path = "${config.xdg.userDirs.music}";
          rescanInterval = 60;
          ignorePerms = true;
          type = "sendonly";
          devices = [ "NixOS-LT" ];
        };
        "Videos" = {
          path = "${config.xdg.userDirs.videos}";
          rescanInterval = 60;
          ignorePerms = true;
          type = "sendonly";
        #  devices = [ "NixOS-LT" ];
        };
        "FreeTube" = {
          path = "/home/jf/.config/FreeTube";
          rescanInterval = 30;
          ignorePerms = true;
          type = "sendonly";
          devices = [ "NixOS-LT" ];
        };
      };
    };
  };
}
