{ config, lib, pkgs, ... }:

{
  networking = {
  
    hostName = "NixOS-Laptop";
      
    interfaces = {
      #eth0 = {
      #  useDHCP = true;
      #  #ipv4.addresses = [ {
      #  #  address = "10.75.0.40";
      #  #  prefixLength = 24;
      #  #} ];
      #};

      wlp3s0 = {
        useDHCP = true;
      };
    };

    useDHCP = lib.mkForce true;

    #defaultGateway = "10.75.0.1";

    wireless = {
      environmentFile = config.sops.secrets.wifi.path;
      networks = {
        "@ENV_HOME_SSID@" = {
          psk = "@ENV_HOME_PSK@";
          authProtocols = "WPA-PSK-SHA256";
          priority = 0;
        };

        "@ENV_SCHOOL_SSID@" = {
          psk = "@ENV_SCHOOL_PSK@";
          priority = 0;
        };

        "@ENV_HOTSPOT_SSID@" = {
          psk = "@ENV_HOTSPOT_PSK@";
          priority = 1;
        };
      };

      extraHosts = ''
        10.75.0.80 bitsync.icu
        10.75.0.80 uptimekuma.bitsync.icu
        10.75.0.80 nextcloud.bitsync.icu
        10.75.0.80 radicale.bitsync.icu
        10.75.0.80 homeassistant.bitsync.icu
        10.75.0.80 pihole.bitsync.icu
        10.75.0.80 radarr.bitsync.icu
        10.75.0.80 sonarr.bitsync.icu
        10.75.0.80 searx.bitsync.icu
        10.75.0.80 invidious.bitsync.icu
        10.75.0.80 libreddit.bitsync.icu
        10.75.0.80 jellyfin.bitsync.icu
        10.75.0.80 pufferpanel.bitsync.icu
        10.75.0.80 onlyoffice.bitsync.icu
      '';
    };
  };
}
