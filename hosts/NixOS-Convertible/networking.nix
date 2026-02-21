{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking = {

    hostName = "NixOS-Convertible";

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

  nixos.system.networking = {
    enable = true;
    localIP = "10.75.0.103";
  };
}
