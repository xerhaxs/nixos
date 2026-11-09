# Mail: OpenPGP with Stalwart, Thunderbird and JMAP

## Where the OpenPGP key goes

| Place | What it does | Declarative |
|---|---|---|
| Private repository `pgp/public.asc` | Source of the own public key | the file itself |
| Private `site.nix`: `pgpFingerprint` and `mailAddress` | Thunderbird identity, GnuPG default key | yes |
| Stalwart: Web Key Directory | Other mail clients find your key automatically by your address (`https://openpgpkey.<domain>/.well-known/openpgpkey/<domain>/hu/<hash>`) | yes, built from `pgp/public.asc` (`nixosModules/server/public/stalwart.nix`) |
| Stalwart: encryption at rest | Incoming mail is encrypted with your public key before Stalwart stores it | no, per account in the web interface |
| GnuPG (`homeModules/base/gpg.nix`) | Imports the public key (ultimate trust), WKD first for lookups, gpg-agent with pinentry | yes |
| Thunderbird | Signs with the key of `pgpFingerprint`, can use the secret key from GnuPG (`withExternalGnupg`) or its own key manager | identity yes, secret key import no |

The secret key is never part of the repositories.

## Steps

1. Create or export the key pair: `gpg --quick-gen-key "Name <you@domain>" ed25519 sign,cert 2y` and `gpg --quick-add-key <fpr> cv25519 encr 2y`, or use the existing one.
2. Public key: `gpg --armor --export you@domain > nixos-private/pgp/public.asc`; in `nixos-private/site.nix` set `mailAddress`, `mailRealName`, `pgpFingerprint`. Commit, `nix flake update private`.
3. DNS: A/AAAA record `openpgpkey.<domain>` pointing to NixOS-ServerPublic. Rebuild NixOS-ServerPublic, the certificate is issued with http-01.
4. Check WKD: `gpg --auto-key-locate clear,wkd --locate-keys you@domain` from another machine, or https://metacode.biz/openpgp/web-key-directory.
5. Stalwart encryption at rest: log in at `https://stalwart.<domain>` with the mail account, open "Encryption at rest" (account settings), paste the public key, choose OpenPGP and AES256, save. From then on stored mail can only be read with your secret key; the Stalwart web interface and server-side full-text search no longer see the content of new mail.
6. Thunderbird: the identity is configured by Home Manager. For the secret key either import it in Thunderbird (Account settings > End-to-end encryption > Add key > import), or keep it in GnuPG / on a smartcard (Thunderbird uses it through GPGME because `withExternalGnupg` is set; choose "Use external key through GnuPG" with the key id).
7. Contacts and calendar of Stalwart are added to Thunderbird declaratively (CalDAV/CardDAV of the same account); the password is asked once.

## JMAP

Stalwart also speaks JMAP. Thunderbird on the clients uses IMAP/SMTP and CalDAV/CardDAV (it has no JMAP yet, watch item in `TODO.md` phase 24). On the phone Sterna Mail (F-Droid) uses JMAP: add an account with the address, an app password of Stalwart and the server `https://mail.<domain>`.
