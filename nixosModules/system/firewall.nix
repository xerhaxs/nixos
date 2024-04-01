{ config, lib, pkgs, ... }:

{
  networking.firewall = {
    enable = true;
    allowPing = true;
    #allowedTCPPorts = [ ];
    #allowedTCPPortRanges = [ ];
    #allowedUDPPorts = [ ];
    #allowedUDPPortRanges = [
    #  { from = ; to = ; }
    #  { from = ; to = ; }
    #];
  };
}
