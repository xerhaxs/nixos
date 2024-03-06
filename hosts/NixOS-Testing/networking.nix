{ config, lib, pkgs, ... }:

{
  networking = {
  
    hostName = "NixOS-Testing";
      
    interfaces = {  
      eth0 = {
        useDHCP = true;
      };
    };

    useDHCP = lib.mkForce false;

    #defaultGateway = "10.75.0.1";
  };
}
