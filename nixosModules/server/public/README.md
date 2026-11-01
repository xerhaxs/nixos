# public

## Purpose

Services of the public server (NixOS-ServerPublic).

## How it works

- Mail (Stalwart), cloud (Nextcloud with Nextcloud Office/Collabora, Talk, end-to-end encryption), Matrix (Synapse with Discord/Signal/Telegram/WhatsApp bridges), CryptPad, Mumble, ntfy (UnifiedPush), TURN (coturn), Miniflux, Briar Mailbox, MollySocket.
- All services listen on localhost behind nginx, except the protocols that need own ports (SMTP/IMAP, Mumble, TURN).
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
| `murmur.nix` | Enable Murmur Mumble server. |
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
| `nixos.server.public.murmur.enable` | boolean | `false` | Enable Murmur Mumble server. |
| `nixos.server.public.murmur.passwordProtected` | boolean | `false` | Require the server password from sops (murmur/env, MURMURD_PASSWORD) to join. |
| `nixos.server.public.nextcloud.enable` | boolean | `false` | Enable Nextcloud. |
| `nixos.server.public.ntfy.declarativeAuth` | boolean | `false` | Users, tokens and access rules from sops (ntfy/env with NTFY_AUTH_USERS, NTFY_AUTH_TOKENS, NTFY_AUTH_ACCESS). |
| `nixos.server.public.ntfy.enable` | boolean | `false` | Enable ntfy push server (UnifiedPush). |
| `nixos.server.public.stalwart.enable` | boolean | `false` | Enable stalwart. |

## Notes

- Stalwart: accounts, DKIM and the needed DNS records are managed in the webadmin (`stalwart.<domain>`), login with the fallback admin.
- Matrix users: `register_new_matrix_user -k "$(cat /run/secrets/matrix/registration_shared_secret)" http://127.0.0.1:8008`.
- Miniflux admin: `sudo -u miniflux env DATABASE_URL="user=miniflux host=/run/postgresql dbname=miniflux" miniflux -create-admin`.
- Briar Mailbox setup code: `journalctl -u podman-briar-mailbox`.
- ntfy admin: `sudo ntfy user add --role=admin <name>` or declarative users (`declarativeAuth`).
