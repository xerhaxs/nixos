# management

## Purpose

Management, dashboards, home automation, inventory and monitoring.

## How it works

- Cockpit (server administration), Glance (start page), Home Assistant (with Matter, Thread, Tankerkoenig, killswitch script), HomeBox (inventory).
- `monitoring.nix`: Prometheus, Alertmanager, Loki and Grafana with pinned dashboards from grafana.com (node, ZFS, SMART, nginx, PostgreSQL, Pi-hole, Unbound, blackbox, WireGuard, Alertmanager, logs). The exporters run on every host (`nixosModules/system/monitoring-agent.nix`).
- Alert rules: host down, disk space, memory, failed units, SMART, ZFS pool, certificates, endpoints. Alerts go to ntfy and/or mail (`alerts.*`).

## Contents

| Path | Description |
|---|---|
| `cockpit.nix` | Enable cockpit. |
| `default.nix` | Imports the modules of this folder and defines the bundle option `nixos.server.management.enable`. |
| `glance.nix` | Enable glance. |
| `homeassistant.nix` | Enable Home Assistant. |
| `homebox.nix` | Enable HomeBox inventory management. |
| `monitoring.nix` | Enable Prometheus, Alertmanager, Loki and Grafana. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nixos.server.management.cockpit.enable` | boolean | `false` | Enable cockpit. |
| `nixos.server.management.enable` | boolean | `false` | Enable management modules bundle. |
| `nixos.server.management.glance.enable` | boolean | `false` | Enable glance. |
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

## Notes

- Home Assistant devices that depend on the hardware (IPs, Thread radio) are configured in the host (`hosts/NixOS-Server1/homeassistant.nix`).
- Killswitch button: add a button card for `script.killswitch` with confirmation to a dashboard.
