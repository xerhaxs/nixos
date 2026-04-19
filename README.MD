# NixOS Configuration

This is my personal NixOS configuration.
I use flakes, disko, impermanence and sops to manage my system. To install NixOS on a device I have written a simple shell script. To run and use the script you only need to boot a NixOS installation medium and then open a terminal and execute the command below. **Keep in mind, that this config is tailored for my personal setup. So you need to change the config for your system.**

This config is still in development (see ToDo).

### Installation / Usage

```
sudo -i
```

```
curl -L https://raw.githubusercontent.com/xerhaxs/nixos/main/NixOSInstaller.sh | bash
```

### Setup Secure Boot

1. Generate Secure Boot keys:

```
sudo sbctl create-keys
```

This stores your secure boot keys at /var/lib/sbctl and sets the permissions so that they can only be read by the root user. 

Then enable `nixos.system.secureboot.enable = true;`.

2. Reboot and enable UEFI Secure Boot mode in UEFI firmware menu (BIOS).

3. Enroll Secure Boot keys

```
sudo sbctl enroll-keys --microsoft --firmware-builtin
```

4. Once rebooted, you can verify the Secure Boot status using, `bootctl status`.

### Set Keyfile.key for drives

```
cryptsetup luksKillSlot /dev/disk/by-label/CRYPTDATA 1
cryptsetup luksKillSlot /dev/disk/by-label/CRYPTGAMES 1
cryptsetup luksKillSlot /dev/disk/by-label/CRYPTBACKUP 1

cryptsetup luksAddKey /dev/disk/by-label/CRYPTDATA keyfile.key
cryptsetup luksAddKey /dev/disk/by-label/CRYPTGAMES keyfile.key
cryptsetup luksAddKey /dev/disk/by-label/CRYPTBACKUP keyfile.key
```

### If you need to create your own keys for sops:

```
# generate new key at ~/.config/sops/age/keys.txt
$ nix shell nixpkgs#age -c age-keygen -o ~/.config/sops/age/keys.txt

# generate new key at ~/.config/sops/age/keys.txt from private ssh key at ~/.ssh/private
$ nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/private > ~/.config/sops/age/keys.txt

# get a public key of ~/.config/sops/age/keys.txt
nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt
```

### NixOS System update

```
nix flake update --commit-lock-file
nixos-rebuild switch --flake .#HOSTNAME
```

Remote Build from local Host:

```
 nixos-rebuild switch --flake .#SERVERHOSTNAME --target-host REMOTEUSER@SERVERHOSTNAME --sudo
```

### BIOS / Firmware update

```
fwupdmgr refresh --force
fwupdmgr get-updates
fwupdmgr update
```

## Usefull stuff
- IDs of processes: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/misc/ids.nix#L307
- Prefetch URLs and sha: nix-prefetch-url --unpack https://URL.com or use lib.fakeSha256

## Credits

Thanks to:
https://github.com/ryan4yin/nix-config/blob/main/README.md
