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

  services.postgresql.package = pkgs.postgresql_17;

  nixos.server.network.fail2ban.enable = true;

  nixos.system.clamav.extraScanDirectories = [ "${config.services.nextcloud.home}/data" ];

  nixos.system.hardening.hardenedMalloc = true;

  boot.kernel.sysctl."net.ipv4.icmp_echo_ignore_all" = 1;

  security.lockKernelModules = true;
  boot.kernelModules = [
    "wireguard"
    "tun"
    "veth"
    "bridge"
    "br_netfilter"
    "overlay"
    "nf_tables"
    "nft_ct"
    "nft_nat"
    "nft_masq"
    "nft_chain_nat"
    "nft_compat"
    "nft_fib_inet"
    "xt_conntrack"
    "xt_MASQUERADE"
    "xt_comment"
    "xt_mark"
    "iptable_nat"
    "iptable_mangle"
    "iptable_raw"
    "ip6table_nat"
  ];

  nixos.system.ssh.listenAddresses = lib.mkIf (
    config.nixos.system.wireguard.enable && config.nixos.system.wireguard.hasPeers
  ) [ "10.100.0.1" ];
  networking.firewall.interfaces.${config.nixos.system.wireguard.interface}.allowedTCPPorts = [ 22 ];
}
