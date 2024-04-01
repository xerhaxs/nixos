{ config, pkgs, ... }:

{
  services.readarr = {
    enable = true;
    openFirewall = false;
    #dataDir = "";
  };
}
