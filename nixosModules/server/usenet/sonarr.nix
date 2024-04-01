{ config, pkgs, ... }:

{
  services.sonarr = {
    enable = true;
    openFirewall = false;
    #dataDir = "";
  };
}
