{ config, pkgs, ... }:

{
  virtualisation.libvirtd = {
    enable = true;
    #allowedBridges = [];
    onShutdown = "suspend";
    qemu = {
      swtpm.enable = true;
      ovmf.enable = true;
      runAsRoot = false; # may can cause problems
    };
  };

  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    bridge-utils
    dnsmasq
    ebtables
    iptables
    libvirt
    nftables
    OVMF 
    qemu
    qemu_kvm
    quickemu
    vde2
    virglrenderer
    virtio-win
    win-spice
  ];
}
