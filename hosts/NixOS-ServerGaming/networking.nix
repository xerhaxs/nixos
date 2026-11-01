{
  config,
  lib,
  pkgs,
  ...
}:

let
  net = config.nixos.site.serverGaming;
in

{
  networking = {
    hostName = "NixOS-ServerGaming";

    interfaces.${net.interface} = {
      ipv4.addresses = [
        {
          address = net.ipv4;
          prefixLength = net.ipv4PrefixLength;
        }
      ];
      ipv6.addresses = [
        {
          address = net.ipv6;
          prefixLength = net.ipv6PrefixLength;
        }
      ];
    };

    defaultGateway = {
      address = net.ipv4Gateway;
      interface = net.interface;
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = net.interface;
    };

    nameservers = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];

    tempAddresses = lib.mkForce "disabled";
  };

  nixos.system.networking = {
    enable = true;
    networkmanager.enable = false;
    lan.enable = false;
  };

  nixos.system.ssh.whitelist = [ "10.100.0.0/24" ];
}
