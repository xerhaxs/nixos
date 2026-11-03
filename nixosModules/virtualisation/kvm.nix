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
        onBoot = "ignore";
        onShutdown = "suspend";
        qemu = {
          swtpm.enable = true;
          runAsRoot = true;
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

    # nixpkgs installs vendor-reset by copying the .ko, so the .ko.cer that aggregateModules expects
    # is missing. kbuild's modules_install signs the module and writes it (like broadcom-sta).
    # Remove once nixpkgs fixes the package (TODO 13.22).
    boot.extraModulePackages = with config.boot.kernelPackages; [
      (vendor-reset.overrideAttrs (old: {
        installPhase = ''
          runHook preInstall
          make ${lib.escapeShellArgs old.makeFlags} \
            -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M="$PWD" \
            INSTALL_MOD_PATH="$out" INSTALL_MOD_DIR=kernel/drivers/misc DEPMOD=true \
            modules_install
          runHook postInstall
        '';
      }))
    ];

    boot.extraModprobeConfig = ''
      options vendor-reset
    '';

    environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        "/var/lib/libvirt"
      ];
    };
  };
}
