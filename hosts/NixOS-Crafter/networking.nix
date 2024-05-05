{ config, lib, pkgs, ... }:

{
  networking = {
  
    hostName = "NixOS-Crafter";
      
    interfaces = {  
      enp5s0 = {
        useDHCP = true;
      };

      wlp3s0 = {
        useDHCP = true;
      };
    };

    useDHCP = lib.mkForce false;

    defaultGateway = "10.75.0.1";

    wireless = {
      environmentFile = config.sops.secrets.wifi.path;
      networks = {
        "@ENV_HOME_SSID@" = {
          psk = "ENV_HOME_PSK";
          authProtocols = "WPA-PSK-SHA256";
          priority = 0;
        };
      };
    };
  };
}
