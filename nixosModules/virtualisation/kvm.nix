{ config, lib, pkgs, ... }:

{
  options.nixos = {
    virtualisation.kvm = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable kvm / qemu virtualisation.";
      };
    };
  };

  config = lib.mkIf config.nixos.virtualisation.kvm.enable {
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
  };
}
