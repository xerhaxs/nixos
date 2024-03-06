{ config, pkgs, ... }:

{
  services.lidarr = {
    enable = true;
    openFirewall = false;
    #dataDir = "";
  };
}
