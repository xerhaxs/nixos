{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    system.firewall = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable network firewall.";
      };
    };
  };

  config = mkIf config.nixos.system.firewall.enable {
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
  };
}