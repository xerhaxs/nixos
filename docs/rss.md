# RSS

- Server: Miniflux on NixOS-ServerPublic (`rss.<domain>`), the single source of feeds and read state. It offers the Miniflux API, the Fever API and the Google Reader API.
- Clients: Fluent Reader (`homeModules/applications/media/fluentreader.nix`) on all clients, in the Plasma task bar between Clementine and FreeTube. The Miniflux sync is prefilled (`https://rss.<domain>`, API key authentication); create an API key in Miniflux (Settings > API keys) and paste it once in Fluent Reader (Settings > Service). Theme follows the system, refresh every 30 minutes.
- Phone (GrapheneOS):

| App | Sync | Notes |
|---|---|---|
| Capy Reader (F-Droid) | Miniflux, FreshRSS, Feedbin, local | Recommended: native Miniflux support, Material You, offline reading, open source. |
| Read You (F-Droid) | Fever, Google Reader API (FreshRSS, Miniflux), local | Very polished, uses the Google Reader API endpoint of Miniflux (`https://rss.<domain>/` with the Miniflux user and an integration password from Settings > Integrations > Google Reader). |
| FeedMe | Miniflux, FreshRSS, others | Feature rich, closed source. |

FreshRSS is not needed: every app that syncs with FreshRSS through the Google Reader API also works with Miniflux.
