{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking = {

    hostName = "NixOS-Server3";

    interfaces = {
      enp0s18 = {
        ipv4.addresses = [
          {
            address = "10.75.0.23";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "fe80::3128:c782:a68c:7e25";
            prefixLength = 64;
          }
        ];
      };
    };

    defaultGateway.interface = "enp0s18";
    defaultGateway6.interface = "enp0s18";
  };

  nixos.system.networking = {
    enable = true;
    localIP = "10.75.0.23";
  };
}
