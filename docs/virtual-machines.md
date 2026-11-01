# Declarative virtual machines (NixVirt)

[NixVirt](https://github.com/AshleyYakeley/NixVirt) is a flake with NixOS and Home Manager modules that define libvirt objects (domains, networks, storage pools and volumes) in Nix. On every activation it creates or updates them in libvirt (`qemu:///system` or `qemu:///session`), so `virt-manager` shows them like manually created VMs.

## What it can do

- Domains from templates: `NixVirt.lib.domain.templates.linux` and `.windows` produce sane XML (q35, UEFI/OVMF with Secure Boot, TPM 2.0 emulation for Windows 11, virtio disk and network, SPICE, QEMU guest agent channel, optional virtio driver ISO for the Windows installer).
- Full control over the XML through Nix attribute sets (CPU pinning, hugepages, USB/PCI passthrough, shared folders with virtiofs).
- Networks (NAT, bridge, isolated) and storage pools/volumes (qcow2 images with a given size).
- `active = true` starts the VM with the host, `restart = true` restarts it when the definition changes.

## What it does not do

- It does not install the guest operating system. The disk volume is created empty, Windows is installed once from the ISO (manually or unattended with an `autounattend.xml` on a second virtual CD). The installed system inside the disk image is state, not configuration.
- The disk image has to be backed up like any other data (it lives in the libvirt pool directory, which must be persisted on impermanence hosts: `/var/lib/libvirt`).
- Windows licensing and updates stay manual.

## Example: Windows 11 VM

```nix
# flake input: NixVirt.url = "github:AshleyYakeley/NixVirt"; module: NixVirt.nixosModules.default
virtualisation.libvirt = {
  enable = true;
  connections."qemu:///system" = {
    pools = [ {
      definition = NixVirt.lib.pool.writeXML {
        name = "default"; uuid = "<uuidgen>";
        type = "dir"; target.path = "/var/lib/libvirt/images";
      };
      active = true;
      volumes = [ { definition = NixVirt.lib.volume.writeXML {
        name = "win11.qcow2"; capacity = { count = 128; unit = "GiB"; }; target.format.type = "qcow2";
      }; } ];
    } ];
    domains = [ {
      definition = NixVirt.lib.domain.writeXML (NixVirt.lib.domain.templates.windows {
        name = "win11"; uuid = "<uuidgen>";
        memory = { count = 8; unit = "GiB"; };
        storage_vol = { pool = "default"; volume = "win11.qcow2"; };
        install_vol = /mount/Data/ISO/Win11_German_x64.iso;
        nvram_path = /var/lib/libvirt/qemu/nvram/win11_VARS.fd;
        virtio_net = true; virtio_drive = true; install_virtio = true;
      });
      active = false;
    } ];
  };
};
```

## Assessment

Useful for a VM that should always exist with known settings on several clients (Windows for Fusion 360 if wine fails, test VMs of the own hosts, an isolated browser VM). The VM definition becomes reproducible, the guest installation does not. The existing `nixos.virtualisation.kvm` module (libvirt + virt-manager) stays the base; NixVirt would be an extra module `nixos.virtualisation.nixvirt` with the domain list per host. Listed in `TODO.md` as optional.
