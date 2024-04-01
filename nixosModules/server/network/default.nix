{ pkgs, lib, config, ... }: 

{ 
  imports = [
    ./adguard.nix
    ./dnsmasq.nix
    ./networking.nix
    ./nginx.nix
    ./uptime-kuma.nix
  ];
}
