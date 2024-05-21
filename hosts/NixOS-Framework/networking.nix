{ config, lib, pkgs, ... }:

{
  networking = {
  
    hostName = "NixOS-Framework";
      
    interfaces = {
      eth0 = {
        useDHCP = true;
        #ipv4.addresses = [ {
        #  address = "10.75.0.40";
        #  prefixLength = 24;
        #} ];
      };

      wlp1s0 = {
        useDHCP = true;
      };
    };

    useDHCP = lib.mkForce false;

    #wireless = {
    #  environmentFile = config.sops.secrets."wifi".path;
    #  networks = {
    #    "@ENV_HOME_SSID@" = {
    #      psk = "@ENV_HOME_PSK@";
    #      authProtocols = "WPA-PSK-SHA256";
    #      priority = 0;
    #    };

    #    "@ENV_SCHOOL_SSID@" = {
    #      psk = "@ENV_SCHOOL_PSK@";
    #      priority = 0;
    #    };

    #    "@ENV_HOTSPOT_SSID@" = {
    #      psk = "@ENV_HOTSPOT_PSK@";
    #      priority = 1;
    #    };
    #  };
    #};
  };
}
