{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking = {

    hostName = "NixOS-Server1";

    interfaces = {
      eno1 = {
        ipv4.addresses = [
          {
            address = "10.75.0.21";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "fe80::be24:11ff:fef3:96ff";
            prefixLength = 64;
          }
        ];
      };
    };

    defaultGateway.interface = "eno1";
    defaultGateway6.interface = "eno1";
  };

  nixos.system.networking = {
    enable = true;
    localIP = "10.75.0.21";
  };
}
