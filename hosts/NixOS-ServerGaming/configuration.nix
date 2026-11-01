{
  config,
  lib,
  pkgs,
  ...
}:

{
  _module.args.userName = "admin";

  nixos.system.sops.perHostFile = true;
  nixos.system.user.passwordFromSops = true;

  services.getty.autologinUser = null;

  # Off until the rework is merged, it would switch back to the old configuration of main (TODO phase 17).
  system.autoUpgrade.enable = false;

  nixos.server.network.fail2ban.enable = true;

  boot.kernel.sysctl."net.ipv4.icmp_echo_ignore_all" = 1;

  security.lockKernelModules = true;
  boot.kernelModules = [
    "wireguard"
    "nf_tables"
    "nft_ct"
    "nft_compat"
    "nft_fib_inet"
    "xt_conntrack"
    "xt_comment"
    "xt_mark"
    "iptable_nat"
    "iptable_mangle"
    "iptable_raw"
  ];

  # ssh only through WireGuard, as soon as the hub knows this host (otherwise it would lock itself out).
  nixos.system.ssh.listenAddresses = lib.mkIf config.nixos.system.wireguard.enrolled [ "10.100.0.6" ];
  networking.firewall.interfaces.${config.nixos.system.wireguard.interface}.allowedTCPPorts = [ 22 ];
}
