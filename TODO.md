# TODO – Schritt-für-Schritt-Anleitung

Stand: Alle Änderungen liegen nur im Working Tree. Es wurde noch nichts committet und kein Rebuild gemacht. Arbeite die Phasen in dieser Reihenfolge ab. Jeder Punkt ist ein Häkchen. Die Abnahme-Checkliste (was wurde geändert und wie prüfe ich es?) steht in [`CHECKLIST.md`](CHECKLIST.md).

Konventionen:

- `$REPO` = `/mount/Data/Datein/Dokumente/nixos`, `$PRIV` = `/mount/Data/Datein/Dokumente/nixos-private`.
- Secrets bearbeiten: `sops <datei>`. Öffentliches Repo: `secrets/secrets.yaml`, privates Repo: `secrets/<hostname>.yaml`.
- Features, die ein noch nicht vorhandenes Secret brauchen, sind eingebaut, aber ausgeschaltet. sops prüft beim Build, ob jedes deklarierte Secret existiert.

---

## Phase 0 – Sichern und Überblick verschaffen

- [X] 0.1 Sicherung beider Repos anlegen: `cp -a $REPO ~/nixos-backup-$(date +%F)` und `cp -a $PRIV ~/nixos-private-backup-$(date +%F)`.
- [X] 0.2 Aktuelle Generation notieren: `nixos-rebuild list-generations | tail -3` (für einen möglichen Rollback).
- [X] 0.3 Änderungen ansehen: `cd $REPO && git status && git diff --stat`. Neue Ordner: `pkgs/`, `docs/`, `hosts/NixOS-Portable/`, `hosts/NixOS-VMServerPublic/`, Hyprland-Module.
- [X] 0.4 [`CHECKLIST.md`](CHECKLIST.md) einmal komplett durchlesen.

## Phase 1 – Privates Repository vorbereiten

- [X] 1.1 `cd $PRIV && git status`. Neu bzw. geändert sind `site.nix` (initiale Passwort-Hashes), `secrets/.sops.yaml` (Regeln für `initial-passwords.yaml` und `nixos-portable.yaml`), `secrets/initial-passwords.yaml` und `secrets/nixos-portable.yaml`.
- [X] 1.2 Initiale Passwörter ansehen und in KeePassXC speichern: `sops -d secrets/initial-passwords.yaml`. Je Host gibt es eine Wort-Passphrase. Die Hashes (sha512crypt, 500 000 Runden) stehen in `site.nix` unter `initialHashedPasswords`.
- [ ] 1.3 In `site.nix` ergänzen:
  - [ ] `mailAddress = "<du>@<mailDomain>";` und `mailRealName = "<Name>";` (Thunderbird-Konto, CalDAV/CardDAV von Stalwart)
  - [ ] `pgpFingerprint = "<40 Zeichen>";` (sobald der PGP-Schlüssel existiert, siehe Phase 11)
  - [ ] `serverPublic`: echte VPS-Daten (Interface, IPv4/IPv6, Gateway, Storage Box)
- [ ] 1.4 Optional: Den öffentlichen PGP-Schlüssel ablegen: `mkdir -p pgp && gpg --armor --export <adresse> > pgp/public.asc`. Er wird per WKD veröffentlicht und in GnuPG importiert.
- [X] 1.5 In `secrets/nixos-portable.yaml` die Platzhalter `REPLACE_ME` ersetzen (`sops secrets/nixos-portable.yaml`): WLAN, Mullvad, NAS-SMB-Zugang, Alpha-Vantage-Key, `glance` → `ENV_LOCATION`. Die Werte kopierst du aus `sops -d secrets/secrets.yaml` im öffentlichen Repo.
- [X] 1.6 Committen: `git add -A && git commit -m "site data, initial passwords, portable host"`.
- [X] 1.7 Im öffentlichen Repo den Lock aktualisieren: `cd $REPO && nix flake update private`.

## Phase 2 – Öffentliches Repository committen

- [ ] 2.1 Eigenen Branch anlegen: `git switch -c rework`.
- [ ] 2.2 Alle Dateien hinzufügen (Flakes ignorieren untracked files): `git add -A`.
- [ ] 2.3 Prüfen, dass nichts Privates im öffentlichen Repo landet: `git diff --cached -- . ":!TODO.md" | grep -iE "<deine Domains>|BEGIN (OPENSSH|PGP) PRIVATE"` darf nichts finden (Ausnahme: die Git-Autoradresse in `homeModules/base/git.nix`, die ohnehin in jedem Commit steht).
- [ ] 2.4 `git commit -m "rework: hyprland, portable host, dangerzone, hardening, docs"`.

## Phase 3 – Bauen und testen, ohne etwas zu aktivieren

- [ ] 3.1 Alle Hosts evaluieren: `for h in NixOS-Desktop NixOS-Framework NixOS-Convertible NixOS-Server1 NixOS-ServerPublic NixOS-Portable NixOS-VMDesktop NixOS-VMServer NixOS-VMServerPublic; do nix eval --raw .#nixosConfigurations.$h.config.system.build.toplevel.drvPath >/dev/null && echo "OK $h"; done`
- [ ] 3.2 Den Desktop bauen: `nixos-rebuild build --flake .#NixOS-Desktop`. Das dauert, DangerZone und hyprgrass werden lokal gebaut.
- [ ] 3.3 Unterschiede ansehen: `nix run nixpkgs#nvd -- diff /run/current-system ./result`.
- [ ] 3.4 Optional in einer VM testen: `nixos-rebuild build-vm --flake .#NixOS-VMDesktop && ./result/bin/run-NixOS-VMDesktop-vm`. Darin Hyprland (SDDM → Hyprland) und Plasma starten.
- [ ] 3.5 Die Hyprland-Konfiguration prüfen: `Hyprland --verify-config -c ./result/...` (oder nach dem Switch `Hyprland --verify-config -c ~/.config/hypr/hyprland.lua`).

## Phase 4 – NixOS-Desktop umstellen (dieser Rechner)

Vorbereitung (vor dem Rebuild):

- [ ] 4.1 machine-id dauerhaft machen (sonst bekommt jeder Boot eine neue ID): `sudo mkdir -p /persistent/etc && sudo cp /etc/machine-id /persistent/etc/machine-id`.
- [ ] 4.2 Dateien wegräumen, die Home Manager jetzt selbst verwaltet. Sonst bricht die Aktivierung mit "would be clobbered" ab:
  - [ ] `mv ~/.ssh/config ~/.ssh/config.bak` (falls vorhanden; eigene Einträge später nach `homeModules/base/ssh.nix` übernehmen)
  - [ ] `mv ~/.gnupg/gpg.conf ~/.gnupg/gpg.conf.bak; mv ~/.gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf.bak` (falls vorhanden)
  - [ ] EasyEffects: falls `~/.local/share/easyeffects/input/microphone.json` existiert, umbenennen
- [ ] 4.3 Secure Boot: `secureBoot.autoGenerateKeys` erzeugt fehlende Keys jetzt automatisch beim Bootloader-Install. Sind schon Keys in `/var/lib/sbctl`, bleiben sie.

Umstellen:

- [ ] 4.4 Nicht `switch`, sondern `boot` verwenden (Kernel-Parameter, initrd und Zeitdienst ändern sich): `sudo nixos-rebuild boot --flake .#NixOS-Desktop`.
- [ ] 4.5 Neu starten. LUKS fragt wie bisher nach der Passphrase. Die Fehlermeldung `key file '/tmp/secret.key' missing` ist jetzt weg.
- [ ] 4.6 Nach dem Boot: `journalctl -b -p err` ansehen und mit dem alten Stand vergleichen (siehe Phase 13.1).

Nacharbeiten:

- [ ] 4.7 Back In Time: In `~/.config/backintime/config` den Wert `profile1.schedule.mode=1` auf `0` setzen und den alten Cron-Eintrag löschen: `crontab -r`. Der systemd-User-Timer übernimmt jetzt das tägliche Backup (`systemctl --user list-timers | grep backintime`).
- [ ] 4.8 KeePassXC-SSH-Agent einrichten: [`docs/keepassxc-ssh-agent.md`](docs/keepassxc-ssh-agent.md). Danach `ssh-add -l`.
- [ ] 4.9 DangerZone einmal starten. Beim ersten Start lädt es das Container-Image und prüft es mit cosign. Danach eine Test-PDF umwandeln.
- [ ] 4.10 Fluent Reader: In Miniflux unter Einstellungen → API-Schlüssel einen Key anlegen und ihn in Fluent Reader unter Einstellungen → Dienst eintragen. Funktioniert erst, wenn ServerPublic läuft.
- [ ] 4.11 EasyEffects: Das Mikrofon-Preset ist geladen. Feinabstimmung pro Mikrofon: Gate-Schwelle, EQ, Kompressor. Wenn das Mikro nur links ankommt, Stereo Tools mit `LR>LL` ergänzen.
- [ ] 4.12 Hyprland ausprobieren: Abmelden → SDDM → Session „Hyprland“. Tastenkürzel siehe `homeModules/desktop/windowManager/hyprland/README.md`.
- [ ] 4.13 Fusion 360: `fusion360-install` einmal ausführen (braucht Internet und Autodesk-Konto), danach `fusion360` starten. Funktioniert es unter Wine nicht, ist die Alternative eine Windows-VM (siehe [`docs/virtual-machines.md`](docs/virtual-machines.md)).
- [ ] 4.14 VRR/HDR wird beim Login per `kscreen-doctor` gesetzt. Den AVR-Monitor als Spiegel des Hauptmonitors einmalig in den KDE-Bildschirmeinstellungen einrichten (der Ausgabename ist unbekannt).

## Phase 5 – Laptops (NixOS-Framework, NixOS-Convertible)

- [ ] 5.1 Pro Laptop: Phase 4.1 bis 4.6 wiederholen (`.#NixOS-Framework` bzw. `.#NixOS-Convertible`).
- [ ] 5.2 Convertible: In Hyprland Touch-Gesten, die Bildschirmtastatur (Wisch vom unteren Rand nach oben) und die automatische Drehung (Tablet-Modus) testen.
- [ ] 5.3 Laptops: kanshi-Profile prüfen (Laptop allein / mit externem Monitor). Positionen bei Bedarf in `hosts/<host>/home/hyprland.nix` anpassen.

## Phase 6 – NixOS-Server1

- [ ] 6.1 machine-id sichern: `ssh admin@NixOS-Server1 'sudo mkdir -p /persistent/etc && sudo cp /etc/machine-id /persistent/etc/machine-id'`.
- [ ] 6.2 Bauen und als Boot-Generation setzen: `nixos-rebuild boot --flake .#NixOS-Server1 --target-host admin@NixOS-Server1 --sudo`, dann neu starten (Remote-Unlock per initrd-ssh).
- [ ] 6.3 Intel-GPU für Ollama prüfen: `ssh admin@NixOS-Server1 'nix shell nixpkgs#vulkan-tools -c vulkaninfo --summary'` muss die Intel-GPU zeigen. Danach im Log `journalctl -u ollama | grep -i vulkan`.
- [ ] 6.4 ComfyUI: `systemctl status podman-comfyui`. Der erste Start lädt das Image (mehrere GB). Danach `https://comfyui.<homeDomain>` öffnen und ein Modell (z. B. SDXL oder Flux) in `/pool01/applications/comfyui/models/checkpoints` legen. Später das Image-Digest in `nixosModules/server/tools/comfyui.nix` regelmäßig aktualisieren.
- [ ] 6.5 Neue DNS-Namen im Pi-hole: `comfyui`, `grafana`, `homebox` (kommen automatisch aus `lan.hosts`).
- [ ] 6.6 Externe Sicherung jetzt per Skript: Platte anstecken, dann `sudo backup-external /dev/sdX1`. Fortschritt: `sudo tail -f /root/.local/share/backintime/takesnapshot_.log`.
- [ ] 6.7 Loki-Alarm „ExecOutsideNixStore“ testen: per ssh eine Kopie von `/run/current-system/sw/bin/true` nach `/tmp` legen und ausführen. Innerhalb von 5 Minuten muss ein Alarm kommen (nach Phase 10).

## Phase 7 – Passwörter, Schlüssel und sops neu aufsetzen

Hintergrund: Die alte `secrets/secrets.yaml` und die alten Passwort-Hashes sind in der öffentlichen Git-Historie. Ändere deshalb alles, was dort stand.

7A – sops pro Host (siehe auch README → „Host keys for sops“):

- [ ] 7.1 Pro Host einen neuen age-Key erzeugen: `sudo nix shell nixpkgs#age -c age-keygen -o /secrets/keys.txt && sudo chmod 400 /secrets/keys.txt`. Den Public Key zeigt `age-keygen -y /secrets/keys.txt`.
- [ ] 7.2 Die Public Keys in `$PRIV/secrets/.sops.yaml` eintragen und die auskommentierten Zeilen (`#- *sops_desktop` usw.) aktivieren.
- [ ] 7.3 Pro Host eine Datei `$PRIV/secrets/<hostname>.yaml` anlegen und die Werte aus `sops -d $REPO/secrets/secrets.yaml` übernehmen, aber nur die des jeweiligen Hosts (Schlüsselliste unten).
- [ ] 7.4 Auf jedem Host `nixos.system.sops.perHostFile = true;` setzen (Portable und ServerPublic haben das schon).
- [ ] 7.5 Wenn alle Hosts umgestellt sind: `git rm secrets/secrets.yaml secrets/.sops.yaml` im öffentlichen Repo.

7B – Was neu gesetzt werden muss und wo es eingetragen wird:

| Was | Neu erzeugen mit | Eintragen in |
|---|---|---|
| Login-Passwort pro Host | `mkpasswd -m sha-512 -R 500000` (Hash) | sops `user/<hostname>/<user>`, dann `nixos.system.user.passwordFromSops = true;` |
| Initiales Passwort (vor sops) | erledigt (Phase 1.2) | `$PRIV/site.nix` → `initialHashedPasswords` |
| LUKS-Passphrase | `sudo cryptsetup luksChangeKey /dev/disk/by-partlabel/disk-NIXOS-LUKS` (Mirror: `disk-NIXOS2-LUKS`) | nur KeePassXC |
| TPM2 + PIN neu binden | `systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto --tpm2-with-pin=yes --tpm2-pcrs=7 <luks>` | – |
| Recovery-Key | `systemd-cryptenroll --recovery-key <luks>` | Papier / KeePassXC |
| SSH-Benutzerschlüssel | `ssh-keygen -t ed25519 -C jf@<host>` | KeePassXC; Public Key in `nixos.system.ssh.authorizedKeys` und `nixos.system.initrdssh.authorizedKeys` (`hosts/*/machine.nix`) |
| SSH-Hostkeys | `sudo rm /etc/ssh/ssh_host_*; sudo systemctl restart sshd` | `known_hosts` der Clients aktualisieren |
| initrd-Hostkey (Server) | `ssh-keygen -t ed25519 -N "" -f /etc/secrets/initrd/ssh_host_ed25519_key` | – |
| WireGuard | `wg genkey \| tee priv \| wg pubkey` | sops `wireguard/<hostname>/private`, Public Key in `nixosModules/system/wireguard.nix` |
| Syncthing-Gerät | `syncthing generate --home /tmp/st` | sops `syncthing/<hostname>/cert` und `/key`; die neue Geräte-ID in `hosts/NixOS-Server1/syncthing.nix` |
| WLAN | im Router ändern | sops `wifi` (`ENV_HOME_SSID`, `ENV_HOME_PSK`, …) |
| NAS (SMB) | `smbpasswd` auf Server1 erfolgt per Aktivierung | sops `smb-share/user-jf`, `smb-share/user-meli` (Server1) und `nas-smb/user` (`username=`/`password=`, Clients) |
| WebDAV | Zufallswert | sops `webdav-share/user-jf` (`ENV_PASSWORD=`, Server1), Clients: `webdav-share/davfs` (`https://dav.<homeDomain>/ jf <passwort>`) |
| Radicale | Zufallswert | sops `radicale/htpasswd` (`jf:<passwort>`) |
| Forgejo | `openssl rand -hex 32` | sops `forgejo/secret`, `forgejo/token` |
| Linkwarden | Zufallswert | sops `linkwarden/postgres`, `linkwarden/secret` |
| SearXNG | `openssl rand -hex 32` | sops `searxng/secret` (`SEARXNG_SECRET=`) |
| Glance | – | sops `glance` (`ENV_PIHOLE_PASSWORD`, `ENV_LOCATION`) |
| SABnzbd, Monero-RPC | in der App | sops `sabnzbd`, `monero/users/*` |
| ZFS-Schlüssel (Server1) | nur bei Neuanlage des Pools | sops `zfs/pool01` |
| Cloudflare / DNS-API | beim Anbieter neu erzeugen, nur Zone:DNS:Edit | sops `nginx/acme/api_key` |
| Mullvad, Alpha Vantage | beim Anbieter | sops `mullvad`, `alphavantage/api_key` |
| Unbenutzte Altlasten | löschen | `changeme`, `changeme_env`, `cloudflare/api_key`, `nginx/acme/email`, `user/nixos-vmdesktop/admin`, `user/nixos-vmserver/admin` |
| Dienst-Konten | in der jeweiligen Web-UI | Home Assistant, Grafana, Jellyfin, Forgejo, Nextcloud, Stalwart, Matrix, Miniflux, HomeBox, Linkwarden |
| Externe Konten | beim Anbieter, 2FA prüfen | Proton, Mullvad, Registrar, VPS, Storage Box, GitHub/Codeberg |

- [ ] 7.6 Danach auf jedem Host: `nixos-rebuild switch` und einmal neu anmelden.
- [ ] 7.7 Syncthing-GUI-Passwort von Server1 als bcrypt-Hash nach sops verschieben (`services.syncthing.guiPasswordFile`).
- [ ] 7.8 Radicale: htpasswd auf bcrypt umstellen (`htpasswd -B`), dann `htpasswd_encryption = "bcrypt"`.

## Phase 8 – NixOS-ServerPublic installieren

- [ ] 8.1 Den VPS bestellen (Anbieter siehe [`docs/providers.md`](docs/providers.md)) und die Daten in `$PRIV/site.nix` → `serverPublic` eintragen, committen, `nix flake update private`.
- [ ] 8.2 Den Host-Key vor der Installation erzeugen: `age-keygen -o keys.txt`, den Public Key in `.sops.yaml` als `sops_serverpublic` eintragen, dann `sops updatekeys secrets/nixos-serverpublic.yaml`.
- [ ] 8.3 Die Platzhalter in `nixos-serverpublic.yaml` ersetzen: `nginx/acme/api_key` (DNS-API-Token), `mautrix-telegram/env` (API-ID und Hash von my.telegram.org), `user/nixos-serverpublic/admin` (neuer Hash, `mkpasswd -m sha-512 -R 500000`).
- [ ] 8.4 Den Storage-Box-Public-Key (`restic@NixOS-ServerPublic`) in der Storage Box hinterlegen.
- [ ] 8.5 Zuerst in der VM testen: `nixos-rebuild build-vm --flake .#NixOS-VMServerPublic`. Der hardened malloc ist aktiv. Prüfen, ob alle Dienste starten: `systemctl --failed`. Bricht ein Dienst ab, `nixos.system.hardening.hardenedMalloc = false;` setzen und das hier notieren.
- [ ] 8.6 Installieren: `nixos-anywhere --flake .#NixOS-ServerPublic --disk-encryption-keys /tmp/secret.key <passphrase-datei> --disk-encryption-keys /tmp/keyfile.key <keyfile> --extra-files <dir mit secrets/keys.txt und etc/ssh/initrd_host_key> root@<ip>`.
- [ ] 8.7 DNS-Einträge anlegen: A/AAAA für alle Dienstnamen, dazu `openpgpkey.<mailDomain>`. Für die Mail-Domain MX, SPF, DKIM, DMARC, MTA-STS und TLS-RPT (die Werte zeigt die Stalwart-Weboberfläche), außerdem CAA und PTR beim Anbieter. Port 25 beim Anbieter freischalten lassen.
- [ ] 8.8 Ersteinrichtung: Stalwart-Konten, Matrix-Nutzer (`register_new_matrix_user`), Bridge-Logins, Miniflux-Admin (`sudo -u miniflux env DATABASE_URL="user=miniflux host=/run/postgresql dbname=miniflux" miniflux -create-admin`), CryptPad `adminKeys`, ntfy-Admin, QR-Code der Briar-Mailbox (`journalctl -u podman-briar-mailbox`).
- [ ] 8.9 Ping ist absichtlich deaktiviert (`icmp_echo_ignore_all`). Monitoring per Ping funktioniert deshalb nicht, IPv6/ICMPv6 bleibt erlaubt.

## Phase 9 – WireGuard und Backups

- [ ] 9.1 WireGuard-Keys für Server1, Desktop, Framework, Convertible und GrapheneOS erzeugen (Tabelle 7B), `nixos.system.wireguard.enable` setzen.
- [ ] 9.2 Den Mullvad-Bypass auf Server1 prüfen: `nft list table inet wgMullvadBypass`, `wg show`.
- [ ] 9.3 `nixos.server.sync.resticserver` auf Server1 aktivieren. Secret `resticserver/htpasswd` mit dem Benutzer `nixos-serverpublic` und dem Passwort aus `restic/home-env` von ServerPublic anlegen (`htpasswd -B -n nixos-serverpublic`).
- [ ] 9.4 Proton-Drive-Backup von Server1 (`hosts/NixOS-Server1/backup.nix`): Secrets `restic/password` und `restic/rclone-proton` (rclone-Config mit `[proton]`, Typ `protondrive`, erstellt mit `rclone config`) anlegen, dann `enable = true`. Einen Restore testen (siehe [`docs/proton-drive.md`](docs/proton-drive.md)).
- [ ] 9.5 Disaster-Recovery-Plan umsetzen ([`docs/disaster-recovery.md`](docs/disaster-recovery.md)):
  - [ ] Schlüssel-Liste offline sichern (Papier und zwei USB-Sticks)
  - [ ] LUKS-Header-Backups aller Platten: `cryptsetup luksHeaderBackup <dev> --header-backup-file <datei>`
  - [ ] Speicherlösung für die Videos auswählen (zweite Platte extern, Storage Box BX21 oder Cold Storage)
  - [ ] Zweites Remote für die Repos (Codeberg privat oder Forgejo auf ServerPublic)
  - [ ] Wiederherstellung vierteljährlich testen (Testplan im Dokument)
- [ ] 9.6 ZFS-Auto-Snapshots auf Server1 aktivieren (`hosts/NixOS-Server1/zfsmount.nix`, derzeit auskommentiert).

## Phase 10 – Benachrichtigungen, Killswitch, Monitoring

- [ ] 10.1 Mail-Alarme: In Stalwart das Konto `alerts@<mailDomain>` anlegen, pro Host das Secret `notify/mail-password` setzen und `nixos.system.notify.mail` einschalten.
- [ ] 10.2 ntfy auf ServerPublic: Secret `ntfy/env` mit `NTFY_AUTH_USERS`, `NTFY_AUTH_TOKENS` und `NTFY_AUTH_ACCESS` (muss `*:up*:write-only` enthalten), dann `nixos.server.public.ntfy.declarativeAuth` einschalten.
- [ ] 10.3 ntfy-Alarme pro Host: Secret `notify/ntfy-env` (`NTFY_TOKEN`, `ALERT_TOPIC`), dann `nixos.system.notify.ntfy` einschalten.
- [ ] 10.4 Killswitch: Pro Host das Secret `killswitch/env` (`NTFY_TOKEN` mit Leserecht, `KILLSWITCH_TOPIC`), dann `nixos.system.killswitch` einschalten (Server1 mit `delay = 60`). Dazu `killswitch/ha-env` (Schreib-Token) und `nixos.server.management.homeassistant.killswitch = true`, außerdem eine Button-Karte für `script.killswitch` mit Bestätigung im Dashboard.
- [ ] 10.5 Grafana/Alertmanager: `nixos.server.management.monitoring.alerts.{ntfy,mail}` mit den Secrets `monitoring/ntfy-url` (`https://push.<domain>/<topic>?template=alertmanager`) und `monitoring/ntfy-token`. Pi-hole-Metriken mit `monitoring/pihole-env`.
- [ ] 10.6 Den Loki-Alarm aus 6.7 testen.

## Phase 11 – Mail, PGP, JMAP

Ausführlich in [`docs/mail-pgp-jmap.md`](docs/mail-pgp-jmap.md).

- [ ] 11.1 Den PGP-Schlüssel erzeugen oder den vorhandenen verwenden. Den Public Key nach `$PRIV/pgp/public.asc` legen und `pgpFingerprint` in `site.nix` setzen (Phase 1.3/1.4).
- [ ] 11.2 Den DNS-Eintrag `openpgpkey.<mailDomain>` anlegen, ServerPublic neu bauen und WKD prüfen: `gpg --auto-key-locate clear,wkd --locate-keys <adresse>`.
- [ ] 11.3 Stalwart Encryption at Rest: Auf `https://stalwart.<domain>` mit dem Mailkonto anmelden → Encryption at rest → Public Key einfügen → OpenPGP/AES256.
- [ ] 11.4 Thunderbird: Den geheimen Schlüssel importieren oder per GnuPG/Smartcard nutzen. Das Konto, die Signatur und CalDAV/CardDAV kommen deklarativ.
- [ ] 11.5 Die alten Konten (Proton Bridge, DLRG, Papa) sowie die Add-ons LanguageTool und CardBook bleiben manuell (siehe `Notes/Post-Installation.md`).
- [ ] 11.6 JMAP: Thunderbird Desktop kann noch kein JMAP. Auf dem Handy Sterna Mail (F-Droid) verwenden, optional Bulwark als Webmail auf ServerPublic. Sobald Thunderbird JMAP unterstützt: Konto umstellen.
- [ ] 11.7 Die JMAP-Unterstützung von Thunderbird regelmäßig prüfen: roadmaps.thunderbird.net (Desktop, Android, iOS).

## Phase 12 – Portable SSD (NixOS-Portable)

- [ ] 12.1 SSD anstecken, die ID ermitteln: `ls -l /dev/disk/by-id/ | grep -v part`. Die ID in `hosts/NixOS-Portable/disko.nix` statt `REPLACE-WITH-SSD-ID` eintragen und committen.
- [ ] 12.2 Den age-Key erzeugen (siehe 7.1), in `.sops.yaml` als `sops_portable` eintragen und `sops updatekeys secrets/nixos-portable.yaml`.
- [ ] 12.3 Installieren (von diesem Rechner aus, die SSD ist angesteckt):
  - [ ] Passphrase-Datei: `echo -n '<passphrase>' > /tmp/secret.key`, Keyfile: `dd if=/dev/urandom of=/tmp/keyfile.key bs=64 count=1`
  - [ ] `sudo nix run github:nix-community/disko -- --mode destroy,format,mount --flake .#NixOS-Portable`
  - [ ] `sudo nixos-install --flake .#NixOS-Portable --root /mnt --no-root-passwd`
  - [ ] `sudo install -m 400 keys.txt /mnt/secrets/keys.txt; sudo install -m 400 /tmp/keyfile.key /mnt/secrets/keyfile.key; shred -u /tmp/secret.key /tmp/keyfile.key`
- [ ] 12.4 Testen: Einen UEFI-Rechner (Secure Boot aus) und einen alten BIOS-Rechner davon booten. In der Bootauswahl den Eintrag mit `server` wählen: Die Dienste sind dann unter `https://<dienst>.portable.internal` erreichbar (selbstsigniertes Zertifikat einmal akzeptieren).
- [ ] 12.5 Kiwix-ZIMs, Jellyfin-Medien und die Ollama-/ComfyUI-Modelle (im Server-Modus `qwen3.5:4b`) nach `/persistent/server/...` kopieren.
- [ ] 12.6 Regelmäßig aktualisieren: `nixos-rebuild switch --flake .#NixOS-Portable --target-host` ist nicht möglich, wenn die SSD steckt. Stattdessen von ihr booten und `sudo nixos-rebuild switch --flake .#NixOS-Portable` ausführen.

## Phase 13 – Fehler, offene Prüfungen

- [ ] 13.1 Boot-Log auf jedem Host prüfen: `journalctl -b 0 -p err` (nur Fehler) und `journalctl -b 0 -p warning`. Befund auf NixOS-Desktop (18.10.2026):
  - [x] `systemd-cryptsetup: key file '/tmp/secret.key' missing`: behoben (disko `passwordFile` statt `settings.keyFile`)
  - [x] `bootctl: /boot ... random seed ... world accessible`: behoben (ESP mit `fmask=0077`)
  - [x] Journal zeigt nur den aktuellen Boot: behoben (`/etc/machine-id` persistiert, Phase 4.1)
  - [ ] `dbus-broker-launch: Ignoring duplicate name ...`: Kosmetik (der Dienst kommt doppelt aus system-path und Paket), nicht schädlich. Nach nixpkgs-Updates erneut ansehen.
  - [ ] `Invalid framebuffer status: GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT` (16-mal): Prozess finden (`journalctl -b -p err -o verbose | grep -B20 GL_FRAMEBUFFER | grep _COMM`), vermutlich KWin/Plasma mit amdgpu
  - [ ] ddcutil-Meldungen (`dw_start_watch_displays`): von PowerDevil, harmlos
  - [ ] `baloo_file_extractor ... App info not found`: harmlos, ggf. Baloo-Indexierung einschränken
  - [ ] Dasselbe auf Framework, Convertible, Server1 und ServerPublic prüfen und hier ergänzen
- [ ] 13.2 nscd: In 128 Boot-Journalen gibt es keinen Startfehler nach dem Reboot. Der einzige Ausfall (18.10. 18:02) kam von einem Netzwerkausfall (IPv6-Präfixwechsel, DNS degradiert): Alle nsncd-Worker hingen an DNS-Anfragen, systemd hat den Dienst neu gestartet. Nach Phase 4 (machine-id) nach dem nächsten Reboot `journalctl -b -1 -u nscd` und `systemctl status nscd` prüfen. Tritt es wieder auf: `journalctl -b -u nscd` und die Zeit mit `journalctl -b -u NetworkManager` vergleichen.
- [ ] 13.3 JetBrains: Die OSS-Editionen sind in nixpkgs unsicher und ungepflegt. Entscheiden, ob `idea` und `pycharm` (unfree) ins Unfree-Prädikat in `nixosModules/system/nixos.nix` sollen, dann `homeManager.applications.development.jetbrains.enable` setzen.
- [ ] 13.4 hyprgrass: Nach dem nächsten `nix flake update` prüfen, ob `pkgs.hyprlandPlugins.hyprgrass` wieder baut. Dann `pkgs/hyprgrass` löschen und in `touch.nix` `pkgs.hyprlandPlugins.hyprgrass` verwenden.
- [ ] 13.5 Ventoy ist mit Version als unsicheres Paket erlaubt (`nixosModules/system/nixos.nix`). Die Version nach nixpkgs-Updates anpassen.
- [ ] 13.6 Das Image von networkingtoolbox auf ein Digest pinnen statt `:latest` mit `--pull=always`. Ebenso das ComfyUI-Image regelmäßig aktualisieren.
- [ ] 13.7 Den Installer-Download (`curl ... | bash`) auf einen Tag oder Commit pinnen und eine Prüfsumme verifizieren.
- [ ] 13.8 HomeBox: Nach dem Anlegen der Konten `allowRegistration = false` setzen. Linkwarden: `enableRegistration` abschalten.
- [ ] 13.9 Monero: Secret `monero/p2pool-env` (`WALLET_ADDRESS=...`) und `nixos.server.tools.moneronode.p2pool.enable = true`. Bestehende monero-gui-Configs brauchen den Remote-Node `NixOS-Server1:18089` (manuell).
- [ ] 13.10 Optional: MollySocket (`nixos.server.public.mollysocket`, Secret `mollysocket/env`), Murmur-Serverpasswort (`passwordProtected`, Secret `murmur/env`).
- [ ] 13.11 WebDAV-Mount auf den Clients einschalten: Secret `webdav-share/davfs` anlegen und `nixos.userEnvironment.networkshares.webdav.enable = true`.

## Phase 14 – Security, später entschieden

- [ ] 14.1 Pi-hole-Privatsphäre: `privacyLevel` 1 oder 3, kurze Aufbewahrung des Query-Logs.
- [ ] 14.2 Firewall auf nftables umstellen (die iptables-`extraCommands` von Monitoring, Monero, Loki und dem NetBIOS-Helper umschreiben).
- [ ] 14.3 SMT auf den Servern deaktivieren (`security.allowSimultaneousMultithreading = false`).
- [ ] 14.4 AppArmor mit eigenen Profilen.
- [ ] 14.5 USBGuard (Server: das Thread-Funkmodul von Server1 erlauben).
- [ ] 14.6 Firejail/Bubblewrap für Messenger und Browser.
- [ ] 14.7 Gehärteter Kernel: `linuxPackages_hardened` gibt es nicht mehr. Alternative: eigener Kernel-Build (kein Binary Cache).
- [ ] 14.8 Clients: auch `udf` blockieren, falls nicht gebraucht.
- [ ] 14.9 Isolation der öffentlichen Dienste: zuerst NixOS-Container (Minecraft, Bridges), danach microVMs für Nextcloud und Synapse ([`docs/isolation.md`](docs/isolation.md)). Vorher in VMServerPublic testen.
- [ ] 14.10 Secure Boot auf allen Clients und Server1 (Keys enrollen: Setup-Mode, `sudo sbctl enroll-keys --microsoft --firmware-builtin`), danach TPM2 + PIN (README).
- [ ] 14.11 Laptops: DNS läuft über Quad9 mit TLS, bis WireGuard steht. Captive Portals brauchen `nmcli` mit temporärem DNS.
- [ ] 14.12 Lynis und kernel-hardening-checker einmal pro Host laufen lassen (`sudo lynis audit system`, `kernel-hardening-checker -c /proc/config.gz -l /proc/cmdline -s <(sysctl -a)`) und die Ergebnisse auswerten.

## Phase 15 – Neue Dienste und Projekte (optional, nach Priorität)

- [ ] 15.1 Ente Photos auf ServerPublic (E2EE-Fotos, mit Garage als S3), Abwägung in [`docs/e2ee-and-runtime-protection.md`](docs/e2ee-and-runtime-protection.md).
- [ ] 15.2 Syncthing mit ServerPublic als „untrusted“ Gerät (nur verschlüsselte Daten auf dem VPS).
- [ ] 15.3 Lokaler Binary Cache (harmonia auf Server1, nächtliche Builds) und Offline-Installer ([`docs/offline-installation.md`](docs/offline-installation.md)).
- [ ] 15.4 Deklarative VMs mit NixVirt (z. B. Windows für Fusion 360) ([`docs/virtual-machines.md`](docs/virtual-machines.md)).
- [ ] 15.5 Cloudflare ersetzen: Registrar, DNS (deSEC) und DDoS-Schutz auswählen ([`docs/providers.md`](docs/providers.md)), dann `dnsProvider` und `nginx/acme/api_key` anpassen.
- [ ] 15.6 SMS-Gateway nur, wenn ein Alarmkanal ohne Internet gewünscht ist ([`docs/sms-gateway.md`](docs/sms-gateway.md)).
- [ ] 15.7 Forgejo-Spiegel aller genutzten Software inklusive Abhängigkeiten auf Server1 einrichten (Forgejo → New Migration → Mirror). Liste:
  - Basis: nixpkgs, home-manager, nix (NixOS/nix), disko, impermanence, sops-nix, nixos-hardware, plasma-manager, catppuccin/nix, catppuccin/heroic, nix-minecraft, nixos-generators, nix-colors, OStrama/weishaupt_modbus, die Blocklisten (blocklistproject, oisd, StevenBlack, Perflyst)
  - Eigene Pakete: freedomofpress/dangerzone, horriblename/hyprgrass, WayfireWM/wf-touch
  - Desktop: hyprwm/Hyprland, hyprwm/hyprlock, hyprwm/hypridle, hyprwm/hyprsunset, hyprwm/contrib, Alexays/Waybar, ErikReider/SwayNotificationCenter, davatorium/rofi, LGFae/awww, anufrievroman/waypaper, ArtsyMacaw/wlogout, hyprland-community/pyprland, raybbian/hyprtasking, VirtCode/hypr-dynamic-cursors, jjtech0130/wvkbd, JeanSchoeller/iio-hyprland, emersion/kanshi, flameshot-org/flameshot, wwmm/easyeffects, yang991178/fluent-reader, keepassxreboot/keepassxc
  - Server: stalwartlabs/stalwart, nextcloud/server, CollaboraOnline/online, element-hq/synapse, mautrix (discord, signal, telegram, whatsapp), cryptpad/cryptpad, mumble-voip/mumble, binwiederhier/ntfy, miniflux/v2, briar/briar-mailbox, mollyim/mollysocket, coturn/coturn, home-assistant/core, sysadminsmedia/homebox, prometheus, grafana, grafana/loki, grafana/alloy, jellyfin, Sonarr/Radarr/Lidarr/Readarr, sabnzbd, theotherp/nzbhydra2, forgejo, linkwarden, Kozea/Radicale, searxng, iv-org/invidious, redlib-org/redlib, kiwix, languagetool-org, LibreTranslate, ollama/ollama, Comfy-Org/ComfyUI, YanWenKun/ComfyUI-Docker, monero-project/monero, SChernykh/p2pool, restic/restic, rclone/rclone, coder/code-server
  - Tools: cryinkfly/Autodesk-Fusion-360-on-Linux (Codeberg), Winetricks/winetricks, ventoy, FreeCAD, SoftFever/OrcaSlicer, flxzt/rnote, xournalpp
- [ ] 15.8 RDP über Plasma KRDP testen: `krdp` in den KDE-Systemeinstellungen → Remote Desktop aktivieren, Benutzer anlegen, mit Remmina oder einem Windows-RDP-Client verbinden. Port 3389 nur im LAN/WireGuard öffnen.
- [ ] 15.9 Handy (GrapheneOS): Capy Reader oder Read You für Miniflux, Sterna Mail für JMAP, ntfy für UnifiedPush (README).

## Phase 16 – Deklarative Konfiguration weiterer Programme (niedrige Priorität, zuletzt)

Ziel: Erst das Programm von Hand einstellen, dann die Konfiguration übernehmen. Bevorzugt deklarativ (Home Manager oder Aktivierungsskript wie bei Clementine/Element), sonst per Impermanence persistieren.

| Programm | Konfiguration | Persistenz heute | Vorgehen |
|---|---|---|---|
| FreeCAD | `~/.config/FreeCAD/user.cfg` (XML), `~/.local/share/FreeCAD` | persistiert (3dprinting.nix) | Einstellungen von Hand setzen, die relevanten Parameter aus `user.cfg` per Aktivierungsskript (`xmlstarlet ed`) setzen |
| OrcaSlicer | `~/.config/OrcaSlicer/` (JSON: Drucker-, Filament- und Prozessprofile) | persistiert | eigene Profile als JSON ins Repo, per `xdg.configFile` (nur die Profile, nicht `OrcaSlicer.conf`) |
| Mumble | `~/.config/Mumble/Mumble/mumble_settings.json`, Zertifikat | prüfen | Settings-JSON per jq-Aktivierung (wie Element), das Zertifikat in KeePassXC sichern, den Server deklarativ in der Favoritenliste |
| rclone | `~/.config/rclone/rclone.conf` (enthält Tokens) | prüfen | Home Manager `programs.rclone.remotes` mit Secrets aus sops, `.config/rclone` persistieren |
| Rnote | GSettings `com.github.flxzt.rnote` (dconf) | dconf persistiert | `dconf watch /` beim Einstellen, Werte nach `dconf.settings` übernehmen |
| Xournal++ | `~/.config/xournalpp/settings.xml` | prüfen | Einstellungen von Hand, danach per Aktivierungsskript (`xmlstarlet`) setzen und `.config/xournalpp` persistieren |

- [ ] 16.1 FreeCAD
- [ ] 16.2 OrcaSlicer
- [ ] 16.3 Mumble
- [ ] 16.4 rclone
- [ ] 16.5 Rnote
- [ ] 16.6 Xournal++
