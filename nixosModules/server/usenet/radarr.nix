{ config, pkgs, ... }:

{
  services.radarr = {
    enable = true;
    openFirewall = false;
    #dataDir = "";
  };
}
