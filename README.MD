# NixOS Configuration

This is my personal NixOS configuration.
I use flakes, disko and sops to manage my system. To install NixOS on a device I have written a simple shell script. To run and use the script you only need to boot a NixOS installation medium and then open a terminal and execute the command below.

### Installation / Usage

```
sudo -i
```

```
curl -L https://raw.githubusercontent.com/xerhaxs/nixos/main/NixOSInstaller.sh | bash
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
- [ ] Make Syncthing declerativ
- [ ] Add HomeAssistant VM
- [ ] Setup Crafter Laptop
- [ ] Selvhost captive portal service + add to network manager and firefox
- [ ] Find out blocked url used for heoric games launcher blocked by ads and steven blocklist
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
- [ ] Plasma6 HDR test
- [ ] encrypted Swap Partition for Hybrid Sleep
- [ ] enable AV1 Encoding in OBS
- [ ] Nextcloud Database setup (postgresql)
- [ ] Find network blocklist error with gog


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





{
  options.nixos = {
    folder.name = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable Docker virtualisation.";
      };
    };
  };

  config = lib.mkIf config.nixos.folder.name.enable {

  };
}