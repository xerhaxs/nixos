{ config, lib, pkgs, ... }:

{
  options.nixos = {
    virtualisation.kvm = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable kvm / qemu virtualisation.";
      };
    };
  };

  config = lib.mkIf config.nixos.virtualisation.kvm.enable {
    virtualisation = {
      libvirtd = {
        enable = true;
        #allowedBridges = [];
        onBoot = "ignore";
        onShutdown = "suspend";
        qemu = {
          swtpm.enable = true;
          ovmf = {
            enable = true;
            packages = [(pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd];
          };
          runAsRoot = true; # may can cause problems
        };
        extraConfig = ''
          log_filters="3:qemu 1:libvirt"
          log_outputs="2:file:/var/log/libvirt/libvirtd.log"
        '';
        hooks.qemu = {
          "win11gpu" = ./vm-win11gpu-hook.sh;
        };
      };
      spiceUSBRedirection.enable = true;
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
