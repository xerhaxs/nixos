# NixOS Configuration

This is my personal NixOS configuration.
I use flakes, disko and sops to manage my system. To install NixOS on a device I have written a simple shell script. To run and use the script you only need to boot a NixOS installation medium and then open a terminal and execute the command below.

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

### ToDo

- [ ] Setup Hyrpland with Waybar and Swaylock
- [ ] Move the server configuration from Desktop to Nuc
- [ ] Add a general testing configuration for interested people
- [ ] Make Thunderbird decleartiv
- [ ] Add Gnome Config
- [ ] Complete Plasma Config
- [ ] Setup Firefox + Librewolf + Brave in config
- [X] Make Syncthing declerativ
- [ ] Add HomeAssistant VM
- [ ] Setup Crafter Laptop
- [ ] Selvhost captive portal service + add to network manager and firefox
- [X] Find out blocked url used for heoric games launcher blocked by ads and steven blocklist
- [ ] Add a custom Homepage for nginx#
- [ ] create NixOS Hardend Config
- [ ] write killswitch for server with rapi
- [ ] move secrets to privat repo and create new secrets
- [ ] bring normcap + handbrake to work
- [ ] setup bash
- [ ] setup zsh
- [ ] setup fish
- [ ] OpenVPN Client
- [ ] WireguardVPN Client
- [ ] setup helix + vim theming
- [ ] default editor für EDITOR env in hm + nixos
- [ ] kiwix addon firefox
- [ ] create protonmail-bridge module
- [ ] setup diff tools in hm
- [ ] theme starship
- [ ] setup emacs, helix, neovim, vim + theming
- [ ] setup ranger with theming
- [ ] USB Bootdrive with NixOS and files
- [X] encrypted Swap Partition for Hybrid Sleep
- [ ] enable AV1 Encoding in OBS
- [ ] Nextcloud Database setup (postgresql)
- [ ] setup gamescope for hdr in games
- [ ] bring fwupd to work


- [ ] Server config
  - [ ] setup lemmy
  - [ ] setup mastodon
  - [ ] setup moneronode
  - [ ] setup peertube
  - [ ] setup pixelfed
  - [ ] setup haos vm
  - [ ] setup OpenVPN Server config
  - [ ] setup WireGuardVPN Server config
  - [ ] setup mailserver

Prefetch URLs and sha: nix-prefetch-url --unpack https://URL.com oder lib.fakeSha256