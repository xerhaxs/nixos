{
  config,
  lib,
  pkgs,
  userName,
  ...
}:

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
          runAsRoot = true; # may can cause problems
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

    users.users."${userName}" = {
      extraGroups = [
        "libvirtd"
      ];
    };

    boot.extraModulePackages = with config.boot.kernelPackages; [ vendor-reset ];

    boot.extraModprobeConfig = ''
      options vendor-reset
    '';
  };
}
