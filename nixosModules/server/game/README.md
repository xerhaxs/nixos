# game

## Purpose

Game servers.

## How it works

- `countdown.nix`: static countdown website on `countdown.<domain>`, date and texts are options set in the host.
- `minecraft.nix` provides the infrastructure of nix-minecraft and common `serverProperties`; the server instances (whitelist, motd, ports, JVM heap) are defined in the host, `hosts/NixOS-ServerGaming/minecraft.nix`.

## Contents

| Path | Description |
|---|---|
| `countdown.html` | Page of the countdown (`@title@`, `@subtitle@`, `@target@`, `@doneText@` are replaced). |
| `countdown.nix` | Enable the countdown website on countdown.<domain>. |
| `default.nix` | Imports the modules of this folder and defines the bundle option `nixos.server.game.enable`. |
| `minecraft.nix` | Enable Minecraft Server. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nixos.server.game.countdown.doneText` | string |  | Headline shown when the countdown has ended. |
| `nixos.server.game.countdown.enable` | boolean | `false` | Enable the countdown website on countdown.<domain>. |
| `nixos.server.game.countdown.subtitle` | string | `""` | Line below the headline. |
| `nixos.server.game.countdown.target` | string matching the ISO 8601 pattern |  | End of the countdown (ISO 8601 with time zone). |
| `nixos.server.game.countdown.title` | string |  | Headline of the page. |
| `nixos.server.game.enable` | boolean | `false` | Enable game modules bundle. |
| `nixos.server.game.minecraft.enable` | boolean | `false` | Enable Minecraft Server. |
| `nixos.server.game.minecraft.serverProperties` | attribute set of anything | `{   accepts-transfers = false;   allow-flight = true;   a...` | Common server.properties for all instances, merged with the instance specific values in the host. |

## Notes

- BlueMap and Fabric API are pinned as flake inputs and linked into `mods/` of the instance in the host, the map is on `bluemap.<domain>`.
- https://github.com/Infinidoge/nix-minecraft

### Managing the Minecraft servers

Every instance is a block under `services.minecraft-servers.servers` in `hosts/NixOS-ServerGaming/minecraft.nix` (version, mods, whitelist, operators, `serverProperties`). Its data is in `/srv/minecraft/<name>` (persisted, in the nightly restic backup), the service is `minecraft-server-<name>`. The commands below run on NixOS-ServerGaming (`ssh -t admin@NixOS-ServerGaming`), `<name>` is e.g. `flolserver`.

- Files: Dolphin on the clients has the place "Minecraft" (`sftp://admin@NixOS-ServerGaming/srv/minecraft`, option `homeManager.desktop.desktopEnvironment.plasma6.dolphin.places`), KeePassXC has to be unlocked for the SSH key. `admin` is in the group `minecraft`, a default ACL on `/srv/minecraft` keeps all files writable for the group, so worlds and configs can be copied and edited there directly. Stop the server before replacing a world.
- Status and log: `systemctl status minecraft-server-<name>`, `journalctl -u minecraft-server-<name> -f`.
- Console (commands like `say`, `op`, `save-all`, `stop`): `sudo -u minecraft tmux -S /run/minecraft/<name>.sock attach`, leave it with Ctrl+b, then d (typing `stop` there stops the server).
- Settings, whitelist and operators: edit them in `minecraft.nix` (whitelist and operators as `Name = "<uuid>";`, the uuid from `curl -s https://api.mojang.com/users/profiles/minecraft/<Name>`), then deploy. NixOS writes `server.properties`, `whitelist.json` and `ops.json` at every start, changes made in game to these files are lost. If the server keeps the old values after the deploy: `sudo systemctl restart minecraft-server-<name>`.

New world (the old one is kept as a copy):

```
sudo systemctl stop minecraft-server-<name>
sudo mv /srv/minecraft/<name>/world /srv/minecraft/<name>/world.old-$(date +%F)
sudo systemctl start minecraft-server-<name>
```

The server generates a new world named after `level-name` (default `world`). A fixed seed: `level-seed = "<seed>";` in `serverProperties` of the instance before the start. Delete the old copy when it is no longer needed: `sudo rm -r /srv/minecraft/<name>/world.old-<date>`. BlueMap renders the new world by itself; to drop the old map: in the console `bluemap purge world`, then `bluemap force-update`.

Download a world to the client (stop first, or `save-off` and `save-all` in the console and `save-on` afterwards):

```
ssh -t admin@NixOS-ServerGaming sudo systemctl stop minecraft-server-<name>
ssh admin@NixOS-ServerGaming 'sudo tar czf - -C /srv/minecraft/<name> world' > <name>-world-$(date +%F).tar.gz
ssh -t admin@NixOS-ServerGaming sudo systemctl start minecraft-server-<name>
```

Upload a world (a folder `world` packed with `tar czf world.tar.gz world`; a singleplayer world from `.minecraft/saves/<world>` has to be renamed to `world` first):

```
scp world.tar.gz admin@NixOS-ServerGaming:/tmp/
ssh -t admin@NixOS-ServerGaming
sudo systemctl stop minecraft-server-<name>
cd /srv/minecraft/<name>
sudo mv world world.old-$(date +%F)
sudo tar xzf /tmp/world.tar.gz
sudo chown -R minecraft:minecraft world
sudo systemctl start minecraft-server-<name>
rm /tmp/world.tar.gz
```

Change the Minecraft version:

1. Back up the world first (download above). A world can be upgraded but never downgraded.
2. Available versions: `nix flake update nix-minecraft` (newer versions), then `nix eval --json .#nixosConfigurations.NixOS-ServerGaming.pkgs.fabricServers --apply builtins.attrNames`. The name is the version with `_` (`fabric-1_21_11`, `fabric-26_3`).
3. Mods for exactly that version: on modrinth.com open Fabric API and BlueMap, Versions, filter by the game version and loader Fabric, copy the link of the `.jar` file. Put the links into the inputs `fabric-api` and `bluemap` in `flake.nix` (keep `flake = false;`), then `nix flake update fabric-api bluemap`.
4. Set `package = pkgs.fabricServers.fabric-<version>;` of the instance, build (`nix build --no-link .#nixosConfigurations.NixOS-ServerGaming.config.system.build.toplevel`), deploy.
5. Check: `journalctl -u minecraft-server-<name> -n 50` shows `Done` without mod errors, the clients join with the same version.

Another instance: copy a block in `minecraft.nix` (other name, `server-port` and `query-port`), `enable = true;`, open its port in the Contabo firewall, deploy. The disabled blocks (`creativeserver`, `pvpserver`, `testserver`, `silverageserver`) are examples.
