{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.network.openvpn-server = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable OpenVPN-Server.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.network.openvpn-server.enable {
    
  };
}