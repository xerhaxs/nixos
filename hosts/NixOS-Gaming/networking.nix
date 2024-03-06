{ config, lib, pkgs, ... }:

{
  networking = {
  
    hostName = "NixOS-Gaming";
      
    interfaces = {  
      enp5s0 = {
        useDHCP = true;
      };
    };

    useDHCP = lib.mkForce false;

    defaultGateway = "10.75.0.1";
  };
}
