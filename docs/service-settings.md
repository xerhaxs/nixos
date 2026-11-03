# Service settings: NixOS or the service itself

Rule of thumb: NixOS defines **how a service runs** (ports, paths, database, reverse proxy, updates, secrets). Whatever happens **inside the service** (accounts, content, connections) is set in its web UI and lives in its data, on the ZFS pool (Server1) or in the persistence (other servers).

| Service | In NixOS | In the service itself |
|---|---|---|
| Home Assistant | Name, units, time zone, killswitch script, included components | Integrations, devices, dashboards, automations, scenes and scripts (the last three in its own YAML files through `!include`) |
| Sonarr, Radarr, Lidarr, Readarr, NZBHydra2 | Port, data path, updates and telemetry off | Indexers, download client, libraries, quality profiles, accounts |
| SABnzbd | Base settings (`settings`) | Usenet servers, categories |
| Jellyfin | Data path, GPU groups | Libraries, users, transcoding |
| Syncthing | Devices and folders, completely (`overrideDevices`, `overrideFolders`): changes made in the UI are overwritten on the next deploy | Nothing permanent |
| Pi-hole, Unbound | Blocklists, local DNS names, upstream, all settings | At most temporary changes (groups, exceptions) |
| Grafana, Prometheus, Loki, Alertmanager | Data sources, dashboards, alerts, scrape targets | Admin password, additional own dashboards |
| Glance | The whole page | Nothing |
| Forgejo | Domain, database, server settings | Accounts, repositories, organisations |
| Nextcloud | Apps, Office and Talk integration, quota, PHP | Admin and users, shares, personal settings |
| Matrix | Server, bridges, registration rules | Rooms, accounts |
| Stalwart | Domains, ports, certificates | Mailboxes, aliases (admin web UI) |
| HomeBox, Linkwarden, Miniflux, Radicale | Port, path, registration on or off | Accounts and all content |
| Ollama, ComfyUI | Service, GPU, paths | Models (`ollama pull`, files in `models/`) |

After a reinstall, everything in the middle column comes back with the configuration. The right column is restored from the data on the pool or from the backup, see [`disaster-recovery.md`](disaster-recovery.md).
