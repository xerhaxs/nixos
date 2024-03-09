{ config, pkgs, ... }:

{
  services.nzbget = {
    enable = true;
    settings = {
      #MainDir = "/mount/Data/Datein/Downloads/NZB Download/";
      ControlPort = "6789";
      ControlUsername = "admin";
      ControlPassword = "CHANGEME";
    };
  };
}
