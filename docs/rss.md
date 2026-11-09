# RSS

Miniflux on NixOS-ServerPublic (`https://rss.<domain>`) keeps all feeds and the read state, every client syncs with it. Feeds are read with the personal account `jf`, `admin` only manages users.

## Miniflux account

1. Admin (once): `sudo -u miniflux env DATABASE_URL="user=miniflux host=/run/postgresql dbname=miniflux" miniflux -create-admin` on NixOS-ServerPublic, login from the KeePassXC entry "Miniflux".
2. As admin: Settings > Users > "Add user" `jf`, without admin rights, password from "Miniflux jf".
3. As `jf`: add feeds or import an OPML file (Settings > Import).

## Fluent Reader (clients)

Installed on all clients (`homeModules/applications/media/fluentreader.nix`), the Miniflux service is prefilled.

1. In Miniflux as `jf`: Settings > API Keys > "Create a new API key", description `fluent-reader`.
2. Fluent Reader > Settings > Service > Miniflux: URL `https://rss.<domain>`, authentication by API key, paste the key, save. Store the key in KeePassXC ("Miniflux jf", additional attribute `fluent-reader token`).
3. The theme follows the system, it refreshes every 30 minutes.

## Read You (phone)

Read You (F-Droid) syncs through the Google Reader API of Miniflux.

1. In Miniflux as `jf`: Settings > Integrations > Google Reader: enable it, set a user name (e.g. `jf`) and a separate integration password (generate it in KeePassXC, store it at "Miniflux jf" as attribute `google reader password`), save.
2. Read You > Settings > Accounts > Add account > "Google Reader API": server `https://rss.<domain>`, user name and integration password from step 1.
3. Choose the sync interval and whether only unread articles are kept offline. Read state syncs back to Miniflux and Fluent Reader.

## Glance

The page Server of Glance on NixOS-Server1 shows the unread count (API key of `jf` as `ENV_MINIFLUX_TOKEN`, see `nixosModules/server/management/README.md`).
