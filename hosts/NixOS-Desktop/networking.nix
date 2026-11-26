{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking = {
    hostName = "NixOS-Desktop";

    # Address and gateway by DHCP through NetworkManager like the laptops. With the static setup of
    # the NixOS scripts NetworkManager saw the interface as external and reported local only, Qt then
    # had no internet and Akonadi took the Radicale resource offline. DNS stays Pi-hole, then Quad9.
    nameservers = config.nixos.system.networking.lan.nameservers;
  };

  nixos.system.networking = {
    enable = true;
    wifi.enable = true;
    macRandomization.wifi = true;
    lan.staticRouting = false;
  };
}
