# NixOS Configuration

This is my personal NixOS configuration.
I use flakes, disko and sops to manage my system. To install NixOS on a device I have written a simple shell script. To run and use the script you only need to boot a NixOS installation medium and then open a terminal and execute the command below. **Keep in mind, that this config is tailored for my personal setup. So you need to change the config for your system.**

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

### BIOS / Firmware update

```
fwupdmgr refresh --force
fwupdmgr get-updates
fwupdmgr update
```

## ToDo List

* [ ] Make NixOS Offline installation working -> local nixos cache etc.
* [ ] Device Config
  * [ ] Rclone Setup https://rclone.org/protondrive/ + Rclone for Android https://github.com/x0b/rcx + https://home-manager-options.extranix.com/?query=rclone&release=release-25.05
  * [ ] Setup Syncthing Config declarative + security settings https://docs.syncthing.net/users/security.html
  * [ ] Install Single GPU Passthrough to Windows 11 VM
    * [ ] https://gitlab.com/risingprismtv/single-gpu-passthrough/-/wikis/home
    * [ ] https://github.com/QaidVoid/Complete-Single-GPU-Passthrough
    * [ ] https://wiki.nixos.org/wiki/PCI_passthrough
    * [ ] Test Gaming with winboat (GPU Passthrough) https://www.winboat.app/
  * [x] Setup Secure Boot https://github.com/nix-community/lanzaboote -> https://wiki.nixos.org/wiki/Limine
  * [ ] Extended secret provisioning https://github.com/polygon/scalpel
  * [ ] Create custom NixOS ISO https://github.com/nix-community/nixos-generators
  * [ ] Declarative VMs https://github.com/AshleyYakeley/NixVirt
  * [ ] Setup SMS SIM-Card Server https://search.nixos.org/options?channel=unstable&type=packages&query=Gammu
  * [ ] Hardening Nix https://saylesss88.github.io/nix/hardening_NixOS.html https://xeiaso.net/blog/paranoid-nixos-2021-07-18/
  * [ ] Remove secrets from home manager git config
  * [ ] Add a Remote Kill Switch to shutdown every system
* [ ] Rescue / Flight / Escape SSD with important data + generic OS
  
* [ ] User application setup in Home Manager
  * [ ] Firefox
    * [x] Setup firefox containers + keepassxc setttings + delete cookies addon + violentmonkey scripts (age restrition bypass + yt full hd)
    * [x] Firefox Captive Portal https://www.encrypted.at/firefox-captive-portal-url/ -> seems unnecessary
    * [x] Firefox isolated profils https://cyberinsider.com/firefox-to-roll-out-streamlined-profile-management-with-data-isolation/ -> absolutely useless (stay with old profiles)
  * [ ] Setup Chromium in Config via Settings -> maybe replace with Trivalent https://github.com/secureblue/Trivalent 
  * [ ] Config setup of Steam (write config file)
  * [ ] Config setup of Heroic (write config file)
  * [ ] Config setup of Prism Launcher (write config file)
  * [ ] Config setup of Rnote (write config file)
  * [ ] Config setup of Xournal++ (write config file)
  * [ ] Miracast / Screensharing in NixOS
  * [ ] SSH Password to SSH Certs + SSH Certfiles via Syncthing

* [ ] Hyprland setup
  * [ ] Touch setup https://github.com/horriblename/hyprgrass
  * [ ] https://github.com/vollowx-archived/arch-dotfiles?tab=readme-ov-file
  * [ ] https://github.com/hyprwm/hyprpaper
  * [ ] https://github.com/end-4/dots-hyprland
  * [ ] https://wiki.hypr.land/Useful-Utilities/Status-Bars/
  * [ ] https://wiki.hypr.land/FAQ/#how-do-i-screenshot
  * [ ] https://github.com/hyprwm/contrib
  * [ ] https://sr.ht/~kennylevinsen/wlsunset/
  * [ ] https://sr.ht/~exec64/imv/
  * [ ] https://github.com/ArtsyMacaw/wlogout
  * [ ] https://wiki.hypr.land/Configuring/Variables/
  * [ ] https://sr.ht/~emersion/kanshi/
  * [ ] https://wiki.hypr.land/Useful-Utilities/Wallpapers/
  * [ ] https://www.reddit.com/r/hyprland/comments/15lbp0i/waypaper_gui_wallpaper_setter_for_wayland/
  * [ ] https://github.com/LGFae/swww
  * [ ] https://github.com/Alexays/Waybar
  * [ ] https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles/tree/main/home/.config
  * [ ] https://github.com/horriblename/hyprgrass
  * [ ] https://github.com/end-4/dots-hyprland/blob/archive/hybrid/.config/hypr/keybinds.conf
  * [ ] https://streamable.com/4oogot
  * [ ] https://github.com/catppuccin/hyprland
  * [ ] https://github.com/catppuccin/waybar
  * [ ] https://github.com/sandwichfarm/hyprlax

* [ ] Server config
  * [ ] Internal Server https://wiki.nixos.org/wiki/NixOS_Containers
    * [ ] full disk encryption on servers
    * [ ] backup strategy on proxmox
    * [ ] setup oci container
    * [X] Caddy, insted of Nginx -> I'll stay with nginx
    * [ ] Update ddclient config
    * [X] Glance https://github.com/glanceapp/glance/blob/main/docs/configuration.md (Dashboard)
    * [ ] Server Backend (Redis alternative) https://github.com/valkey-io/valkey
    * [ ] Jellyfin
    * [X] Radical https://radicale.org/v3.html
    * [ ] WebDav for Bookmarksync
    * [ ] SSHFS as filesharing (second option to smb) https://wiki.nixos.org/wiki/SSHFS
    * [x] PiHole
    * [X] Invidous -> waiting for nixos pkg update
    * [X] Libreddit -> Outdated version in NixPKGS
    * [X] Lemmy -> Not usefull in LAN
    * [X] Nitter -> Missing API Tokens
    * [X] SearxNG -> Working!
    * [X] FreshRSS -> RSS Feed in Glance
    * [ ] Gitea -> local pull instance from public smb share with syncthing?
    * [ ] SMB / NFS Share
    * [X] Lidarr (Config setup) -> not possible due to no module options for settings
    * [X] NZBHydra2 (Config setup) -> not possible due to no module options for settings
    * [X] Radarr (Config setup) -> waiting for nixos pkg update
    * [X] Readarr (Config setup) -> not possible due to no module options for settings
    * [X] Sonarr (Config setup) -> not possible due to no module options for settings
    * [X] Sabnzbd (Config setup) -> not possible due to no module options for settings 
    * [ ] Networking-Toolbox https://github.com/Lissy93/networking-toolbox?tab=readme-ov-file
    * [ ] AI Tools
      * [ ] https://itsfoss.com/local-ai-image-tools/
      * [ ] Stable Diffusion https://www.reddit.com/r/NixOS/comments/11v1lgk/setting_up_stabe_diffusion_on_nixos/
      * [x] Ollama
    * [ ] Grafana + Prometheus Dashboard
  * [ ] External Server
    * [ ] Briar Mailbox: https://briarproject.org/download-briar-mailbox/
    * [ ] Mails server: https://nixos-mailserver.readthedocs.io/en/latest/setup-guide.html#setup-dns-a-record-for-server or mailcow
    * [ ] WireGuard
    * [ ] Matrix.org
    * [ ] Murmur or Teamspeak
    * [ ] Minecraft
    * [ ] Nextcloud / Collabora
    * [ ] User specific nas mount -> remove general user permissions for all nas folders on servers

## Usefull stuff
- IDs of processes: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/misc/ids.nix#L307
- Prefetch URLs and sha: nix-prefetch-url --unpack https://URL.com or use lib.fakeSha256
- 

## Credits

Thanks to:
https://github.com/ryan4yin/nix-config/blob/main/README.md
