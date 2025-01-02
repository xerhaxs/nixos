{ config, lib, pkgs, ... }:

{
  networking = {
  
    hostName = "NixOS-Convertible";
      
    #interfaces = {  
    #  eth0 = {
    #    ipv4.addresses = [ {
    #      address = "10.75.0.90";
    #      prefixLength = 24;
    #    } ];
    #    #ipv6.addresses = [ {
    #    #  address = "2001:16b8:a400:cc00:80e6:a492:a930:d14c";
    #    #  prefixLength = 64;
    #    #} ];
    #  };
    #};

    useDHCP = lib.mkForce true;

    defaultGateway.interface = "eth0";
    defaultGateway6.interface = "eth0";

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
