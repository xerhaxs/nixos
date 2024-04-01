{ config, pkgs, ... }:

{
  services.nzbhydra2 = {
    enable = true;
    openFirewall = false;
  };
}
