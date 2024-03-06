{ config, pkgs, ... }:

{
  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [ 8384 21027 22000 ]; # syncthing ports
    #allowedTCPPortRanges = [ ];
    allowedUDPPorts = [ 8384 21027 22000 ]; # syncthing ports
    #allowedUDPPortRanges = [
    #  { from = 1714; to = 1764; }
    #  { from = 1714; to = 1764; }
    #];
  };
}
