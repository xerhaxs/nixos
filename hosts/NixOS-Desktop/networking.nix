{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking = {

    hostName = "NixOS-Desktop";

    interfaces = {
      enp5s0 = {
        ipv4.addresses = [
          {
            address = "10.75.0.80";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "fe80::f22f:74ff:fe54:aac9";
            prefixLength = 64;
          }
        ];
      };
    };

    defaultGateway.interface = "enp5s0";
    defaultGateway6.interface = "enp5s0";
  };

  nixos.system.networking = {
    enable = true;
    localIP = "10.75.0.80";
  };
}
