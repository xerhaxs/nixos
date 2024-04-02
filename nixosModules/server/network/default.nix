{ config, lib, pkgs, ... }:

with lib;

{ 
  options.nixos = {
    server.network = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable network modules bundle.";
      };
    };
  };

  config = mkIf config.nixos.server.network.enable {
    imports = [
      ./adguard.nix
      ./dnsmasq.nix
      ./networking.nix
      ./nginx.nix
      ./openvpn-server
      ./uptime-kuma.nix
    ];
  };
}
