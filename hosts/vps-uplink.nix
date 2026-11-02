# Uplink of a VPS, the argument is the attribute in the private site.nix.
# The network card is matched by name pattern, no interface name is needed. With ipv4Gateway the
# addresses are static (Contabo shows gateway and netmask in the customer panel), without it they
# come from DHCP.
name:

{
  config,
  lib,
  ...
}:

let
  net = config.nixos.site.${name};
  gateway = net.ipv4Gateway or null;
  ipv6 = net.ipv6 or null;
  prefixLength = net.ipv4PrefixLength or 32;

  pow2 = n: lib.foldl' (acc: _: acc * 2) 1 (lib.range 1 n);
  octet =
    index:
    let
      bits = lib.min 8 (lib.max 0 (prefixLength - index * 8));
    in
    toString (256 - pow2 (8 - bits));
  netmask = lib.concatMapStringsSep "." octet (lib.range 0 3);
in

{
  networking.useNetworkd = true;

  systemd.network.networks."10-uplink" = {
    matchConfig.Name = "en* eth*";
    networkConfig = {
      DHCP = if gateway == null then "ipv4" else "no";
      IPv6AcceptRA = gateway == null;
    };
    dhcpV4Config.UseDNS = false;
    address =
      lib.optional (gateway != null) "${net.ipv4}/${toString prefixLength}"
      ++ lib.optional (ipv6 != null) "${ipv6}/${toString (net.ipv6PrefixLength or 64)}";
    routes =
      lib.optional (gateway != null) {
        Gateway = gateway;
        GatewayOnLink = true;
      }
      ++ lib.optional (ipv6 != null) {
        Gateway = "fe80::1";
        GatewayOnLink = true;
      };
  };

  nixos.system.initrdssh.ip =
    if gateway == null then "dhcp" else "${net.ipv4}::${gateway}:${netmask}:::none";
}
