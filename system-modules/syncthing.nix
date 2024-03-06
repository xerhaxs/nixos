{ pkgs, ... }:

let
  user = "jf";
  pass = "CHANGEME";
in

{
  #environment.systemPackages = with pkgs; [
    #syncthing
    #syncthingtray
  #];

  #users.users.syncthing.extraGroups = [ "users" "syncthing" "root" ];
  #users.users."${user}".extraGroups = [ "syncthing" ];
  #users.users.syncthing.isSystemUser = true;
  #users.users.syncthing.isNormalUser = false;
  #systemd.services.syncthing.serviceConfig.UMask = "0007";

  services.syncthing = {
    enable = true;
    systemService = true;
    user = "root";
    group = "root";
   # configDir = "/home/${user}/.config/syncthingserver";
   # dataDir = "/mount/Data/Datein/Sync/";
    overrideDevices = true;
    overrideFolders = true; 

    extraOptions = {
      gui = {
        theme = "black";
        tls = true;
        user = "${user}";
        password = "${pass}";
      };
      options = {
        localAnnounceEnabled = true;
        crashReportingEnabled = false;
      };
    };

    devices = {
      #"NixOS-PC" = { id = "ADDJR6I-6W74LYT-D5OTTWB-YO5IDXN-YRTUS3T-DRXXPCQ-ROJJ7UW-MISBSAP"; };
      "NixOS-LT" = { id = "D3M37EV-OQ2WP7T-3PFWSDE-E7DQ74B-LSCQ6DL-75GFL2B-6KBRSAQ-POCUWQH"; };
      "GraphenOS-SP" = { id = "NLYJGXH-QP27NVE-4JOX67Q-4XNQHG2-2RGX5LX-I6GL5XN-WU3EVG2-KWM6VQI"; };
    };

    folders = {
      "Bilder" = {
        path = "/mount/Data/Datein/Bilder";
        rescanInterval = 60;
        ignorePerms = true;
        type = "sendonly";
        devices = [ "NixOS-LT" ];
      };
      "Dokumente" = {
        path = "/mount/Data/Datein/Dokumente";
        rescanInterval = 60;
        ignorePerms = true;
        type = "sendonly";
        devices = [ "NixOS-LT" ];
      };
      "Downloads" = {
        path = "/mount/Data/Datein/Downloads";
        rescanInterval = 60;
        ignorePerms = true;
        type = "sendonly";
        devices = [ "NixOS-LT" ];
      };
      "Musik" = {
        path = "/mount/Data/Datein/Musik";
        rescanInterval = 60;
        ignorePerms = true;
        type = "sendonly";
        devices = [ "NixOS-LT" ];
      };
      "Videos" = {
        path = "/mount/Data/Datein/Videos";
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

 # systemd.services.syncthing.serviceConfig = {
#	PrivateHome = mkForce false;        
#	ProtectHome = mkForce false;
#	RestrictHome = mkForce false;
 # };
}
