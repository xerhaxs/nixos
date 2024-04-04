{ config, lib, pkgs, ... }:

{ 
  options.nixos = {
    server.network = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable network modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.network.enable {
    imports = [
      ./adguard.nix
      ./dnsmasq.nix
      ./networking.nix
      ./nginx.nix
      ./openvpn-server
      ./uptime-kuma.nix
      ./wireguard-server.nix
    ];
  };
}
