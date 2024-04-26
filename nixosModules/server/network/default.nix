{ config, lib, pkgs, ... }:

{ 
  imports = [
    ./adguard.nix
    ./dnsmasq.nix
    ./networking.nix
    ./nginx.nix
    ./openvpn-server.nix
    ./uptime-kuma.nix
    ./wireguard-server.nix
  ];

  options.nixos = {
    server.network = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable network modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.network.enable {
    nixos.server.network = {
      adguard.enable = true;
      dnsmasq.enable = false;
      networking.enable = true;
      nginx.enable = true;
      openvpn-server.enable = true;
      uptime-kuma.enable = true;
      wireguard-server.enable = true;
    };
  };
}
