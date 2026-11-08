# management

## Purpose

Management, dashboards, home automation, inventory and monitoring.

## How it works

- Cockpit (server administration), Glance (start page), Home Assistant (with Matter, Thread, Tankerkoenig, killswitch script), HomeBox (inventory).
- `monitoring.nix`: Prometheus, Alertmanager, Loki and Grafana with pinned dashboards from grafana.com (node, ZFS, SMART, nginx, PostgreSQL, Pi-hole, Unbound, blackbox, WireGuard, Alertmanager, logs). The exporters run on every host (`nixosModules/system/monitoring-agent.nix`).
- Alert rules: host down, disk space, memory, failed units, SMART, ZFS pool, certificates, endpoints. Alerts go to ntfy and/or mail (`alerts.*`).
- `glance-server-page.nix`: page Server of Glance with a section per server, the stats of the other hosts come from Prometheus. Jellyfin, calendar, Miniflux and Home Assistant are options and need API keys in the secret `glance`.
- `update-check.nix`: compares the pinned sources and images with upstream once a day (`docs/updates-and-vulnerabilities.md`), `dashboards/security-updates.nix` is the Grafana dashboard.

## Contents

| Path | Description |
|---|---|
| `cockpit.nix` | Enable cockpit. |
| `default.nix` | Imports the modules of this folder and defines the bundle option `nixos.server.management.enable`. |
| [`dashboards/`](dashboards/) | Own Grafana dashboards. |
| `glance-server-page.nix` | Page Server of Glance. |
| `glance.nix` | Enable glance. |
| `homeassistant.nix` | Enable Home Assistant. |
| `homebox.nix` | Enable HomeBox inventory management. |
| `monitoring.nix` | Enable Prometheus, Alertmanager, Loki and Grafana. |
| `update-check.nix` | Compare the pinned sources and container images with upstream. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nixos.server.management.cockpit.enable` | boolean | `false` | Enable cockpit. |
| `nixos.server.management.enable` | boolean | `false` | Enable management modules bundle. |
| `nixos.server.management.glance.calendar.enable` | boolean | `false` | Show the Sonarr and Radarr calendar on the page Server (needs ENV_SONARR_KEY and ENV_RADARR_KEY in the secret glance). |
| `nixos.server.management.glance.enable` | boolean | `false` | Enable glance. |
| `nixos.server.management.glance.homeassistant.enable` | boolean | `false` | Show Home Assistant sensors on the page Server (needs ENV_HA_TOKEN in the secret glance). |
| `nixos.server.management.glance.homeassistant.entities` | list of string | `[ ]` | Entities shown on the page Server. |
| `nixos.server.management.glance.jellyfin.enable` | boolean | `false` | Show Jellyfin on the page Server (needs ENV_JELLYFIN_TOKEN in the secret glance). |
| `nixos.server.management.glance.miniflux.enable` | boolean | `false` | Show the unread entries of Miniflux on the page Server (needs ENV_MINIFLUX_TOKEN in the secret glance). |
| `nixos.server.management.glance.serverPage` | boolean | `config.networking.hostName == "NixOS-Server1"` | Add the page Server with a section per server, alerts and vulnerabilities. |
| `nixos.server.management.homeassistant.enable` | boolean | `false` | Enable Home Assistant. |
| `nixos.server.management.homeassistant.killswitch` | boolean | `false` | Provide script.killswitch, which publishes poweroff to the killswitch ntfy topic (secret killswitch/ha-env with NTFY_TOKEN and KILLSWITCH_TOPIC). |
| `nixos.server.management.homebox.allowRegistration` | boolean | `false` | Allow new accounts (enable once to create the accounts). |
| `nixos.server.management.homebox.enable` | boolean | `false` | Enable HomeBox inventory management. |
| `nixos.server.management.monitoring.alerts.mail` | boolean | `false` | Send alerts by mail (uses the account of nixos.system.notify.mail and its password secret). |
| `nixos.server.management.monitoring.alerts.ntfy` | boolean | `false` | Send alerts to ntfy (secret monitoring/ntfy-token, topic in monitoring/ntfy-url). |
| `nixos.server.management.monitoring.enable` | boolean | `false` | Enable Prometheus, Alertmanager, Loki and Grafana. |
| `nixos.server.management.monitoring.nodes` | attribute set of string | `{   NixOS-Convertible = "10.100.0.5";   NixOS-Desktop = "...` | Hosts to scrape (hostname -> address in the LAN or the WireGuard network). |
| `nixos.server.management.monitoring.pihole` | boolean | `false` | Export Pi-hole metrics (secret monitoring/pihole-env with PIHOLE_PASSWORD). |
| `nixos.server.management.monitoring.probes` | list of string | `all nginx vhosts of this host and the main public services` | HTTPS endpoints checked for availability and certificate expiry. |
| `nixos.server.management.monitoring.retention` | string | `"180d"` | Retention of the metrics. |

| `nixos.server.management.update-check.enable` | boolean | `false` | Compare the pinned sources and container images with upstream once a day. |
| `nixos.server.management.update-check.minecraftVersion` | string | `"1.21.11"` | Minecraft version the pinned Fabric mods have to support. |

## Notes

- Home Assistant devices that depend on the hardware (IPs, Thread radio) are configured in the host (`hosts/NixOS-Server1/homeassistant.nix`).
- Killswitch button: add a button card for `script.killswitch` with confirmation to a dashboard.
- Glance integrations: each widget reads an API key from the secret `glance` (env file, one `NAME=value` line per key) and stays off until its option is enabled; Glance does not start when a referenced key is missing. Add the key first (`cd ~/Documents/nixos-private/secrets && sops nixos-server1.yaml`, commit, `nix flake update private`), then enable the option in `hosts/NixOS-Server1/server.nix` under `nixos.server.management.glance` and deploy.

  | Option | Line in `glance` | Where the key comes from |
  |---|---|---|
  | `miniflux.enable` | `ENV_MINIFLUX_TOKEN=` | Miniflux as `jf`: Settings, API Keys, "Create a new API key" (the widget shows the feeds of that user) |
  | `jellyfin.enable` | `ENV_JELLYFIN_TOKEN=` | Jellyfin as admin: Dashboard, API Keys, "+" |
  | `calendar.enable` | `ENV_SONARR_KEY=`, `ENV_RADARR_KEY=` | Sonarr and Radarr: Settings, General, API Key |
  | `homeassistant.enable` | `ENV_HA_TOKEN=` | Home Assistant: profile, Security, Long-lived access tokens; the shown sensors are `homeassistant.entities` |
