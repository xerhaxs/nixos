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

[ ] Setup Hyrpland with Waybar and Swaylock
[ ] Move the server configuration from Desktop to Nuc
[ ] Add a general testing configuration for interested people
[ ] Make Thunderbird decleartiv
[ ] Add Gnome Config
[ ] Complete Plasma Config
[ ] Setup Firefox + Librewolf + Brave in config
[ ] Make Syncthing declerativ
[ ] Add HomeAssistant VM
[ ] Setup Crafter Laptop
[ ] Selvhost captive portal service + add to network manager and firefox
