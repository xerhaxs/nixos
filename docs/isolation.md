# Isolation of services: NixOS containers and microvm.nix

Today every service of a host runs as its own system user with systemd hardening (`unitHardening`, the upstream module hardening) and only listens on localhost behind nginx. An attacker who exploits one service gets that user, and through a kernel exploit possibly the whole host with all data of all services. Containers and micro VMs add a boundary between the services.

## Options

| | systemd hardening (today) | NixOS containers (systemd-nspawn, `containers.<name>`) | microvm.nix (`microvm.vms.<name>`) |
|---|---|---|---|
| Boundary | users, namespaces, seccomp per unit | own mount/PID/network namespace, optional own user namespace (`privateUsers = "pick"`) | own kernel in a KVM VM (cloud-hypervisor, firecracker, qemu) |
| Kernel exploit escapes | yes | yes (shared kernel) | no, the attacker needs a hypervisor escape |
| Overhead | none | small (shared kernel and `/nix/store`) | RAM per VM (guest kernel + services, 256 MB to several GB), a few seconds boot |
| Configuration | normal NixOS options | a full NixOS config per container, same modules usable | a full NixOS config per VM, `/nix/store` shared read-only through virtiofs |
| Network | host | `privateNetwork` + veth, nginx on the host proxies to the container IP | tap/bridge interface per VM, nginx proxies to the VM IP |
| Secrets | sops on the host | bind-mount the decrypted secret file into the container | share the secret through a virtiofs/9p mount or run sops-nix inside the VM with its own age key |
| State, backups | `/var/lib`, restic on the host | bind mount of a host directory, backed up by the host | volume image or virtiofs share of a host directory, backed up by the host |
| GPU | direct | device bind mount | PCI passthrough only (not practical for the iGPU) |

## What it would change here

The exposed services of NixOS-ServerPublic are the main candidates, ordered by risk and size of the attack surface:

1. Matrix (Synapse + four bridges): large code base, parses data from four foreign networks, keeps session secrets of your messenger accounts.
2. Nextcloud + Collabora: large PHP code base, file uploads, office document parsing.
3. Minecraft: Java server reachable from the internet, mods.
4. Stalwart, CryptPad, Miniflux, ntfy, Mumble, Briar: smaller, written in memory-safe languages (Rust, Go, Node).

On NixOS-Server1 the services are only reachable in the LAN and through WireGuard, the benefit is smaller (exceptions: Home Assistant with many third-party integrations, the *arr stack that parses data from indexers).

## Recommendation

- Step 1 (low effort): NixOS containers with `privateUsers = "pick"` and `privateNetwork = true` for Minecraft and the Matrix bridges. The modules stay the same, the container config imports them. A container escape still needs a kernel exploit, but a service compromise no longer sees the other services' files.
- Step 2 (more effort, highest gain): Nextcloud + Collabora and Synapse as micro VMs with microvm.nix on NixOS-ServerPublic, each with a virtiofs share for its data below `nixos.server.dataDir` and its own small sops file. Needs about 2-3 GB extra RAM for both VMs; check the VPS size first.
- Keep the systemd hardening inside containers and VMs.

## How it would look

```nix
# NixOS container
containers.minecraft = {
  autoStart = true;
  privateNetwork = true;
  privateUsers = "pick";
  hostAddress = "192.168.100.1";
  localAddress = "192.168.100.2";
  bindMounts."/srv/minecraft" = { hostPath = "${config.nixos.server.dataDir}/minecraft"; isReadOnly = false; };
  config = { imports = [ ../../nixosModules/server/game/minecraft.nix ]; nixos.server.game.minecraft.enable = true; };
};

# micro VM (flake input microvm.url = "github:microvm-nix/microvm.nix")
microvm.vms.nextcloud.config = {
  imports = [ microvm.nixosModules.microvm ../../nixosModules ];
  microvm = {
    hypervisor = "cloud-hypervisor";
    mem = 2048;
    vcpu = 2;
    shares = [
      { tag = "ro-store"; source = "/nix/store"; mountPoint = "/nix/.ro-store"; proto = "virtiofs"; }
      { tag = "data"; source = "/data/applications/nextcloud"; mountPoint = "/var/lib/nextcloud"; proto = "virtiofs"; }
    ];
    interfaces = [ { type = "tap"; id = "vm-nextcloud"; mac = "02:00:00:00:00:01"; } ];
  };
  nixos.server.public.nextcloud.enable = true;
};
```

Added to `TODO.md` as a later step; it needs a test in NixOS-VMServerPublic first (nested virtualisation for micro VMs).
