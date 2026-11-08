# public

## Purpose

Services of the public server (NixOS-ServerPublic).

## How it works

- Mail (Stalwart), cloud (Nextcloud with Nextcloud Office/Collabora, Talk, end-to-end encryption), Matrix (Synapse with Discord/Signal/Telegram/WhatsApp bridges), CryptPad, ntfy (UnifiedPush), TURN (coturn), Miniflux, Briar Mailbox, MollySocket.
- All services listen on localhost behind nginx, except the protocols that need own ports (SMTP/IMAP, TURN).
- The bridges are built without the deprecated libolm (goolm or without encryption support).
- Stalwart publishes the own OpenPGP key (private `pgp/public.asc`) by WKD on `openpgpkey.<mailDomain>`.

## Contents

| Path | Description |
|---|---|
| `briar-mailbox.nix` | Enable Briar Mailbox. |
| `collabora.nix` | Enable Collabora Online for Nextcloud Office. |
| `coturn.nix` | Enable coturn TURN server. |
| `cryptpad.nix` | Enable cryptpad. |
| `default.nix` | Imports the modules of this folder and defines the bundle option `nixos.server.public.enable`. |
| `matrix.nix` | Enable matrix server. |
| `miniflux.nix` | Enable the Miniflux RSS reader. |
| `mollysocket.nix` | Enable MollySocket (UnifiedPush for the Signal client Molly, secret mollysocket/env with MOLLY_VAPID_PRIVKEY). |
| `nextcloud.nix` | Enable Nextcloud. |
| `ntfy.nix` | Enable ntfy push server (UnifiedPush). |
| `stalwart.nix` | Enable stalwart. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nixos.server.public.briar-mailbox.enable` | boolean | `false` | Enable Briar Mailbox. |
| `nixos.server.public.collabora.enable` | boolean | `false` | Enable Collabora Online for Nextcloud Office. |
| `nixos.server.public.coturn.enable` | boolean | `false` | Enable coturn TURN server. |
| `nixos.server.public.cryptpad.adminKeys` | list of string | `[ ]` | Public signing keys of the CryptPad administrators. |
| `nixos.server.public.cryptpad.enable` | boolean | `false` | Enable cryptpad. |
| `nixos.server.public.enable` | boolean | `false` | Enable public modules bundle. |
| `nixos.server.public.matrix.bridges.discord.enable` | boolean | `false` | Enable the Discord bridge (mautrix-discord). |
| `nixos.server.public.matrix.bridges.signal.enable` | boolean | `false` | Enable the Signal bridge (mautrix-signal). |
| `nixos.server.public.matrix.bridges.telegram.enable` | boolean | `false` | Enable the Telegram bridge (mautrix-telegram), needs api_id/api_hash from my.telegram.org. |
| `nixos.server.public.matrix.bridges.whatsapp.enable` | boolean | `false` | Enable the WhatsApp bridge (mautrix-whatsapp). |
| `nixos.server.public.matrix.enable` | boolean | `false` | Enable matrix server. |
| `nixos.server.public.miniflux.enable` | boolean | `false` | Enable the Miniflux RSS reader. |
| `nixos.server.public.mollysocket.enable` | boolean | `false` | Enable MollySocket (UnifiedPush for the Signal client Molly, secret mollysocket/env with MOLLY_VAPID_PRIVKEY). |
| `nixos.server.public.nextcloud.enable` | boolean | `false` | Enable Nextcloud. |
| `nixos.server.public.ntfy.declarativeAuth` | boolean | `false` | Users, tokens and access rules from sops (ntfy/env with NTFY_AUTH_USERS, NTFY_AUTH_TOKENS, NTFY_AUTH_ACCESS). |
| `nixos.server.public.ntfy.enable` | boolean | `false` | Enable ntfy push server (UnifiedPush). |
| `nixos.server.public.stalwart.enable` | boolean | `false` | Enable stalwart. |

## Notes

Accounts: admin and personal account are always separate. The account `admin` only manages the service, `jf` uses it (feeds, chats, documents). Tokens for own use belong to `jf`.

### Stalwart

- Accounts, domains, DKIM and the DNS records are managed in the webadmin (`stalwart.<domain>`). The fallback admin `admin` (secret `stalwart/admin`) cannot use 2FA or app passwords, use it only for the first setup and as emergency access; daily administration with an own admin account with 2FA.
- Addresses are `name@<domain>`, `mail.<domain>` is only the host name of the server.
- New DKIM signatures are used after `sudo systemctl restart stalwart`.
- MTA-STS needs a TXT record `_mta-sts` (`v=STSv1; id=<date>`), the webadmin does not list it. Stalwart serves the policy itself.
- Auto-ban blocks addresses that open many connections without sending mail. Scanners such as internet.nl are banned, their tests fail by design.

### Matrix

- `server_name` is `matrix.<domain>`, ids are `@name:matrix.<domain>`, the apex of the domain is not used. It cannot be changed once users exist.
- Users: `sudo -u matrix-synapse matrix-synapse-register_new_matrix_user -u <name>` with `-a` for an admin or `--no-admin`. The wrapper of NixOS passes the configuration and the address. First `admin` (admin), then `jf` (no admin).
- Registration only with a token. On NixOS-ServerPublic, as `admin` (the session is logged out again):

  ```
  read -rsp "Matrix admin password: " pw; echo
  at=$(curl -s -X POST -d "{\"type\":\"m.login.password\",\"identifier\":{\"type\":\"m.id.user\",\"user\":\"admin\"},\"password\":\"$pw\"}" http://127.0.0.1:8008/_matrix/client/v3/login | nix run nixpkgs#jq -- -r .access_token); unset pw
  # new token: uses_allowed = number of accounts, expiry in ms
  curl -s -X POST -H "Authorization: Bearer $at" -d "{\"uses_allowed\": 1, \"expiry_time\": $(date -d '+7 days' +%s%3N)}" http://127.0.0.1:8008/_synapse/admin/v1/registration_tokens/new | nix run nixpkgs#jq -- -r .token
  # list with usage, delete one
  curl -s -H "Authorization: Bearer $at" http://127.0.0.1:8008/_synapse/admin/v1/registration_tokens | nix run nixpkgs#jq -- '.registration_tokens[] | {token, uses_allowed, completed}'
  curl -s -X DELETE -H "Authorization: Bearer $at" http://127.0.0.1:8008/_synapse/admin/v1/registration_tokens/<token>
  curl -s -X POST -H "Authorization: Bearer $at" http://127.0.0.1:8008/_matrix/client/v3/logout; unset at
  ```

  New users: Element, "Create account", server `matrix.<domain>`, user name, password, token.

### Bridges

Set up in Element as `jf`. The bot of each bridge answers in a room with only you and the bot (management room), commands there need no prefix, `help` lists them, `ping` shows the login state.

| Bridge | Bot | Room | Login |
|---|---|---|---|
| Signal | `@signalbot:matrix.<domain>` | direct message (encryption supported) | `login`, scan the QR code in Signal, Settings, Linked devices |
| WhatsApp | `@whatsappbot:matrix.<domain>` | direct message (encryption supported) | `login`, choose QR, scan it in WhatsApp, Settings, Linked devices |
| Telegram | `@telegrambot:matrix.<domain>` | new room without encryption, invite the bot | `login`, phone number with country code, code from the app, 2FA password if set; needs `mautrix-telegram/env` (api_id and api_hash from my.telegram.org) |
| Discord | `@discordbot:matrix.<domain>` | new room without encryption, invite the bot | `login` shows a QR code for the Discord app; if Discord asks for a CAPTCHA, `login-token user <token>` instead (below) |

- Join all rooms: the bridges invite `jf` to every new portal. `matrix-accept-invites jf` on NixOS-ServerPublic accepts all pending invites at once (asks for the password, logs in, joins, logs out). Run it again after a while, large backfills create portals over minutes.
- History: new portal rooms get up to 10000 messages (`backfillMessages` in `matrix.nix`). Older messages can only go into empty rooms, existing portals keep their state. Signal and WhatsApp send their history only at login: Signal asks on the phone after the QR code whether to transfer the message history (all messages, media of the last 45 days), WhatsApp sends a year (`request_full_sync`). Telegram creates portals for all chats at login, direct chats included. Discord fills new channel portals.
- Discord servers: `guilds status` lists them with their id, `guilds bridge <id> --entire` creates rooms for all channels at once (grouped as a space), `guilds unbridge <id>` removes it.
- Start over with history (all bridged rooms are recreated): on NixOS-ServerPublic `sudo systemctl stop mautrix-discord mautrix-signal mautrix-telegram mautrix-whatsapp`, `sudo find /var/lib/mautrix-discord /var/lib/mautrix-signal /var/lib/mautrix-telegram /var/lib/mautrix-whatsapp -mindepth 1 -delete`, `sudo systemctl start mautrix-discord mautrix-signal mautrix-telegram mautrix-whatsapp` (they write new registrations), then `sudo systemctl restart matrix-synapse` (it reads them only at start). Leave the old bridge rooms in Element, open new rooms with the bots and log in again.
- Telegram and Discord are bridged without encryption. In an encrypted room their bot only answers "This bridge has not been configured to support encryption". Encryption cannot be turned off in a room, leave it and create a new one.
- Permissions: `matrix.<domain>` may log in (`user`, for Telegram `full`), `@admin:matrix.<domain>` administers the bridges.
- Discord token: open discord.com in a browser and log in, developer tools (F12), Network, reload, select a request to `api`, copy the request header `authorization`. Send `login-token user <token>` to the bot and delete the message afterwards. Using the token of a user account is against the terms of Discord (risk of a ban); the token is invalidated by logging out in Discord or changing the password.

### Miniflux

- Admin: `sudo -u miniflux env DATABASE_URL="user=miniflux host=/run/postgresql dbname=miniflux" miniflux -create-admin`. Then, as admin, Settings, Users, "Add user" `jf` without admin rights; feeds are read as `jf`.
- API keys belong to a user and show that user's feeds, create them as `jf`: Settings, API Keys, "Create a new API key", one per client with its name as description.
  - Glance on NixOS-Server1: line `ENV_MINIFLUX_TOKEN=<key>` in the secret `glance` of `nixos-server1.yaml`, then `nixos.server.management.glance.miniflux.enable = true` (see `nixosModules/server/management/README.md`).
  - Fluent Reader: Settings, Service, Miniflux, `https://rss.<domain>`, the key.
  - Phone apps: see `docs/rss.md`.

### Other services

- CryptPad: close the registration in the admin panel (`/admin/`, User Directory) and invite people with invitation links (one account per link). Guests can open shared links but not create documents or use a drive (`application_config.js`, enforced only in the browser). The admin is set by its public signing key in `nixos.server.public.cryptpad.adminKeys`.
- Briar Mailbox setup code: `journalctl -u podman-briar-mailbox`.
- ntfy admin: `sudo ntfy user add --role=admin <name>` or declarative users (`declarativeAuth`).
