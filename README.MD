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

### ToDo

- [ ] Setup Hyrpland with Waybar and Swaylock / hyprlock + rofi
- [ ] Firefox +  Thunderbird theme
- [ ] touchpad settings in plasma config
- [ ] energy settings in plasma config
- [ ] monitor settings in plasma config
- [ ] lock screen, kate, dolphin settings in plasma manager
- [X] Move the server configuration from Desktop to Nuc
- [X] Add a general testing configuration for interested people
- [X] Make Thunderbird decleartiv
- [ ] Add Gnome Config
- [X] Complete Plasma Config
- [X] Setup Firefox + Librewolf + Brave in config
- [X] Make Syncthing declerativ
- [ ] Add HomeAssistant VM
- [ ] Setup Crafter Laptop
- [ ] Selvhost captive portal service + add to network manager and firefox
- [X] Find out blocked url used for heoric games launcher blocked by ads and steven blocklist
- [ ] Add a custom Homepage for nginx
- [ ] create NixOS Hardend Config
- [ ] write killswitch for server with rapi
- [ ] move secrets to privat repo and create new secrets
- [X] bring normcap + handbrake to work
- [X] setup bash
- [X] setup zsh
- [X] setup fish
- [ ] OpenVPN Client
- [ ] WireguardVPN Client
- [X] setup helix + vim theming
- [ ] default editor für EDITOR env in hm + nixos
- [X] kiwix addon firefox
- [X] create protonmail-bridge module
- [X] setup diff tools in hm
- [X] theme starship
- [X] setup emacs, helix, neovim, vim + theming
- [ ] setup emacs
- [X] setup ranger with theming
- [ ] USB Bootdrive with NixOS and files
- [X] encrypted Swap Partition for Hybrid Sleep
- [X] enable AV1 Encoding in OBS
- [ ] Nextcloud Database setup (postgresql)
- [X] setup gamescope for hdr in games
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