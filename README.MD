# NixOS Configuration

This is my personal NixOS configuration.
I use flakes, disko and sops to manage my system. To install NixOS on a device I have written a simple shell script. To run and use the script you only need to boot a NixOS installation medium and then open a terminal and execute the command below. Keep in mind, that this config is tailored for my personal setup. So you need to change the config for your system.

This config is still in development (see ToDo).

### Installation / Usage

```
sudo -i
```

```
curl -L https://raw.githubusercontent.com/xerhaxs/nixos/main/NixOSInstaller.sh | bash
```

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

## ToDo after installation

- enable syncthing
- move sops keys to device
- login protonmail-bridge
- login in thunderbird
- login to discord, signal, telegram, teams, netflix, disney, chatgpt, simplelogin
- setup firefox containers + keepassxc setttings + delet cookies addon + violentmonkey scripts (age restrition bypass + yt full hd)
- import bookmarks
- set brave browser settings
- login to heroic and steam
- login to mullvad and protonvpn

Prefetch URLs and sha: nix-prefetch-url --unpack https://URL.com oder lib.fakeSha256