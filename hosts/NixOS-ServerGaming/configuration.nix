{
  config,
  lib,
  pkgs,
  ...
}:

{
  _module.args.userName = "admin";

  nixos.system.sops.file = "nixos-servergaming";
  nixos.system.user.passwordFromSops = true;

  services.getty.autologinUser = null;

  # Off until the rework is merged, it would switch back to the old configuration of main (TODO phase 17).

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
}
