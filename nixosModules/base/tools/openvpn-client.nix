{ config, lib, pkgs, ... }:

{
  options.nixos = {
    base.tools.openvpn-client = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable OpenVPN Client.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.tools.openvpn-client.enable {
    services.openvpn.servers = {
      officeVPN  = { config = '' config /root/nixos/openvpn/officeVPN.conf ''; };
      homeVPN    = { config = '' config /root/nixos/openvpn/homeVPN.conf ''; };
      serverVPN  = { config = '' config /root/nixos/openvpn/serverVPN.conf ''; };
    };
  };
}
