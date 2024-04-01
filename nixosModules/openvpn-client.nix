{ config, pkgs, ... }:

{
  services.openvpn.servers = {
    officeVPN  = { config = '' config /root/nixos/openvpn/officeVPN.conf ''; };
    homeVPN    = { config = '' config /root/nixos/openvpn/homeVPN.conf ''; };
    serverVPN  = { config = '' config /root/nixos/openvpn/serverVPN.conf ''; };
  };
}
