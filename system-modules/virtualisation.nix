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
    quickemu
    quickgui
    qemu
    vde2
    ebtables
    iptables
    nftables
    dnsmasq
    bridge-utils
    OVMF 
    libvirt
    spice-gtk
    win-spice
    win-virtio
    virt-viewer
    virglrenderer
  ];
}
