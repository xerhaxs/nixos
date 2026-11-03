# TODO – Schritt-für-Schritt-Anleitung

Stand 02.11.2026 abends: Das Rework liegt auf dem Branch `rework`, noch nicht gepusht. NixOS-Desktop läuft auf der neuen Generation, die Reparatur 4.5a bis 4.5g ist erledigt. Offen auf dem Desktop: einmal neu starten, damit die Prüfungen aus 13.1 und 13.17 greifen. Als Nächstes kommt Server1 (6.2), Secrets der Dienste folgen vor den VPS (8.2 und 8.3), die Clients danach (Phase 5). Die Provider-Daten liegen in der privaten `site.nix`, die Login-Hashes sind gesetzt. Arbeite die Phasen in dieser Reihenfolge ab. Jeder Punkt ist ein Häkchen. Die Abnahme-Checkliste (was wurde geändert und wie prüfe ich es?) steht in [`CHECKLIST.md`](CHECKLIST.md).

Konventionen:

- `$REPO` = `/mount/Data/Datein/Dokumente/nixos`, `$PRIV` = `/mount/Data/Datein/Dokumente/nixos-private`.
- Secrets bearbeiten: `sops <datei>`. Öffentliches Repo: `secrets/secrets.yaml`, privates Repo: `secrets/<hostname>.yaml`.
- Features, die ein noch nicht vorhandenes Secret brauchen, sind eingebaut, aber ausgeschaltet. sops prüft beim Build, ob jedes deklarierte Secret existiert.

---

## Phase 0 – Sichern und Überblick verschaffen

- [X] 0.1 Sicherung beider Repos anlegen, nicht nach `~`, denn das Home liegt auf tmpfs und ist nach einem Reboot weg: `cp -a $REPO /mount/Backup/nixos-backup-$(date +%F)` und `cp -a $PRIV /mount/Backup/nixos-private-backup-$(date +%F)`.
- [X] 0.2 Aktuelle Generation notieren: `nixos-rebuild list-generations | tail -3` (für einen möglichen Rollback).
- [X] 0.3 Änderungen ansehen: `cd $REPO && git status && git diff --stat`. Neue Ordner: `pkgs/`, `docs/`, `hosts/NixOS-Portable/`, `hosts/NixOS-VMServerPublic/`, Hyprland-Module.
- [X] 0.4 [`CHECKLIST.md`](CHECKLIST.md) einmal komplett durchlesen.

## Phase 1 – Privates Repository vorbereiten

- [X] 1.1 `cd $PRIV && git status`. Neu bzw. geändert sind `site.nix` (initiale Passwort-Hashes), `secrets/.sops.yaml` (Regeln für `initial-passwords.yaml` und `nixos-portable.yaml`), `secrets/initial-passwords.yaml` und `secrets/nixos-portable.yaml`.
- [X] 1.2 Eigene Login-Passwörter in KeePassXC anlegen. Klartext liegt nur dort, die Hashes (sha512crypt, 500 000 Runden) stehen in `site.nix` unter `initialHashedPasswords`, bei ServerPublic und ServerGaming in sops. `secrets/initial-passwords.yaml` ist gelöscht (02.11.2026).
- [ ] 1.3 In `site.nix` ergänzen:
  - [X] `mailAddress = "<du>@<mailDomain>";` und `mailRealName = "<Name>";` (Thunderbird-Konto, CalDAV/CardDAV von Stalwart)
  - [ ] `pgpFingerprint = "<40 Zeichen>";` (sobald der PGP-Schlüssel existiert, siehe Phase 11)
  - [X] `serverPublic`: Daten aus dem Contabo Customer Panel unter Network Services → IP Assignment, Button (i): `ipv4`, `ipv4Gateway`, `ipv4PrefixLength` (aus der Netzmaske, 255.255.240.0 ist 20), `ipv6` (eine Adresse aus dem Netz, z. B. `<Präfix>::1`) und `ipv6PrefixLength`. Die Einträge `interface` und `storageBox` löschen, beide werden nicht mehr gelesen.
  - [X] `serverGaming`: dasselbe für den Gaming-Server
  - [X] `mailAccounts`: Adressen von Proton, DLRG und 1&1
- [ ] 1.4 Optional: Den öffentlichen PGP-Schlüssel ablegen: `mkdir -p pgp && gpg --armor --export <adresse> > pgp/public.asc`. Er wird per WKD veröffentlicht und in GnuPG importiert.
- [X] 1.5 In `secrets/nixos-portable.yaml` die Platzhalter `REPLACE_ME` ersetzen (`sops secrets/nixos-portable.yaml`): WLAN, Mullvad, NAS-SMB-Zugang, Alpha-Vantage-Key, `glance` → `ENV_LOCATION`. Die Werte kopierst du aus `sops -d secrets/secrets.yaml` im öffentlichen Repo.
- [X] 1.6 Committen: `git add -A && git commit -m "site data, initial passwords, portable host"`.
- [X] 1.7 Im öffentlichen Repo den Lock aktualisieren: `cd $REPO && nix flake update private`.
- [X] 1.8 Die neuen Änderungen im privaten Repo committen: `cd $PRIV && git add -A && git commit -m "gaming server, mail accounts, remove school wifi"`, danach `cd $REPO && nix flake update private`. Geändert sind `site.nix` (`serverGaming`, Vorlage `mailAccounts`), `secrets/.sops.yaml`, `secrets/nixos-portable.yaml` (Schul-WLAN entfernt), neu ist `secrets/nixos-servergaming.yaml` mit Platzhaltern. Ohne diesen Schritt evaluieren NixOS-ServerGaming und NixOS-VMServerGaming nicht.

## Phase 2 – Öffentliches Repository committen

- [X] 2.1 Eigenen Branch anlegen: `git switch -c rework`.
- [X] 2.2 Alle Dateien hinzufügen (Flakes ignorieren untracked files): `git add -A`.
- [X] 2.3 Prüfen, dass nichts Privates im öffentlichen Repo landet: `git diff --cached -- . ':!TODO.md' | grep -E '^\+' | grep -iE '<deine Domains>|BEGIN (OPENSSH|PGP) PRIVATE'` darf nichts finden (Ausnahme: die Git-Autoradresse in `homeModules/base/git.nix`, die ohnehin in jedem Commit steht). Einfache Anführungszeichen sind nötig, sonst bricht bash bei `!` mit „event not found“ ab. `^\+` beschränkt die Prüfung auf hinzugefügte Zeilen; entfernte Zeilen (`-`) sind gewollt, denn dort verschwinden die alten Domains.
- [X] 2.4 `git commit -m "rework: hyprland, portable host, dangerzone, hardening, docs"`.
- [X] 2.5 Hinweis: Der Input `private` zeigt fest auf `/home/jf/Documents/nixos-private`. Auf den Laptops liegt das Repo dort, auf NixOS-Desktop führt `~/Documents` per Symlink zu `/mount/Data/Datein/Dokumente`. Das private GitHub-Repo kommt erst in Phase 17. `rework` bis dahin nicht nach `main` mergen, `system.autoUpgrade` ist bewusst aus.
- [X] 2.6 Die zweite Runde committen: `git add -A`, Prüfung aus 2.3 wiederholen, dann `git commit -m "pins in flake.lock, cve scan, glance, gaming server, bluemap, countdown"`.

## Phase 3 – Bauen und testen, ohne etwas zu aktivieren

- [X] 3.1 Alle Hosts evaluieren: `for h in NixOS-Desktop NixOS-Framework NixOS-Convertible NixOS-Server1 NixOS-ServerGaming NixOS-ServerPublic NixOS-Portable NixOS-VMDesktop NixOS-VMServer NixOS-VMServerGaming NixOS-VMServerPublic; do nix eval --raw .#nixosConfigurations.$h.config.system.build.toplevel.drvPath >/dev/null && echo "OK $h"; done`
- [X] 3.2 Den Desktop bauen: `nixos-rebuild build --flake .#NixOS-Desktop`. Das dauert, DangerZone und hyprgrass werden lokal gebaut.
- [X] 3.3 Unterschiede ansehen: `nix run nixpkgs#nvd -- diff /run/current-system ./result`.
- [ ] 3.4 Optional in einer VM testen: `nixos-rebuild build-vm --flake .#NixOS-VMDesktop && ./result/bin/run-NixOS-VMDesktop-vm`. Darin Hyprland (SDDM → Hyprland) und Plasma starten.
- [X] 3.5 Die Hyprland-Konfiguration prüfen: `Hyprland --verify-config -c ./result/...` (oder nach dem Switch `Hyprland --verify-config -c ~/.config/hypr/hyprland.lua`).

## Phase 4 – NixOS-Desktop umstellen (dieser Rechner)

Vorbereitung (vor dem Rebuild):

- [X] 4.1 machine-id dauerhaft machen (sonst bekommt jeder Boot eine neue ID): `sudo mkdir -p /persistent/etc && sudo cp /etc/machine-id /persistent/etc/machine-id`.
- [X] 4.2 Dateien wegräumen, die Home Manager jetzt selbst verwaltet. Sonst bricht die Aktivierung mit "would be clobbered" ab (auf NixOS-Desktop gab es am 01.11.2026 keine dieser Dateien):
  - [X] `mv ~/.ssh/config ~/.ssh/config.bak` (falls vorhanden; eigene Einträge später nach `homeModules/base/ssh.nix` übernehmen)
  - [X] `mv ~/.gnupg/gpg.conf ~/.gnupg/gpg.conf.bak; mv ~/.gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf.bak` (falls vorhanden)
  - [X] EasyEffects: falls `~/.local/share/easyeffects/input/microphone.json` existiert, umbenennen
- [X] 4.3 Secure Boot: `secureBoot.autoGenerateKeys` erzeugt fehlende Keys jetzt automatisch beim Bootloader-Install. Sind schon Keys in `/var/lib/sbctl`, bleiben sie.

Umstellen:

- [X] 4.4 Nicht `switch`, sondern `boot` verwenden (Kernel-Parameter, initrd und Zeitdienst ändern sich): `sudo nixos-rebuild boot --flake .#NixOS-Desktop`.
- [X] 4.5 Neu starten. LUKS fragt wie bisher nach der Passphrase. Die Fehlermeldung `key file '/tmp/secret.key' missing` ist jetzt weg.
- [X] 4.6 Nach dem Boot: `journalctl -b -p err` ansehen und mit dem alten Stand vergleichen (siehe Phase 13.1).

Reparatur nach dem ersten Boot (vor den Nacharbeiten erledigen):

Befund vom 01.11.2026: `home-manager-jf.service` brach beim Boot mit `mkdir: Permission denied` in `~/.local/share/easyeffects` ab. Deshalb fehlten alle Links im Home (Hyprland-Konfiguration, Autostart-Skripte von plasma-manager, VSCodium-Erweiterungen). `/persistent/home` war im initrd nicht gemountet: Neue persistierte Ordner landeten verdeckt im root-Subvolume, systemd legte die echten als `root:root` an. `neededForBoot` ist jetzt gesetzt, die 11 betroffenen leeren Ordner müssen einmalig umgestellt werden. Zusätzlich sind `~/.claude`, `~/.claude.json` und `~/.vscode-oss/extensions` persistiert, damit Erweiterung, Anmeldung und Speicher von Claude Code den Neustart überleben.

- [X] 4.5a Eigentümer reparieren: `sudo find /persistent/home/jf -xdev -user root -exec chown jf:users {} +`. Danach darf `find /persistent/home/jf -xdev -user root` nichts mehr finden.
- [X] 4.5b Neue Generation setzen (`boot`, nicht `switch`, sonst legt sich der Mount über die laufende VSCodium-Erweiterung): `cd $REPO && sudo nixos-rebuild boot --flake .#NixOS-Desktop`.
- [X] 4.5c VSCodium schließen, dann in einem Terminal den aktuellen Stand von Claude Code sichern: `mkdir -p /persistent/home/jf/.vscode-oss/extensions && cp -a ~/.claude ~/.claude.json /persistent/home/jf/ && cp -a ~/.vscode-oss/extensions/anthropic.claude-code-* /persistent/home/jf/.vscode-oss/extensions/`.
- [X] 4.5d Neu starten.
- [X] 4.5e Prüfen: `systemctl status home-manager-jf` ist erfolgreich, `systemctl --failed` und `systemctl --user --failed` sind leer, `grep " /persistent/home " /etc/fstab` enthält `x-initrd.mount` (`findmnt` zeigt `x-`-Optionen nicht), `ls -la ~/.config/hypr ~/.claude.json` zeigt die Konfiguration und den Symlink.
- [X] 4.5f Sichtprüfung: Plasma hat wieder Panels, Theme und Wallpaper. Nach 10 Minuten ohne Eingabe darf in Plasma kein `hyprlock` erscheinen.
- [X] 4.5g Optional aufräumen: Unter dem Mountpunkt liegt im root-Subvolume noch ein alter verdeckter Baum. Er stört nicht. Wegräumen: `sudo mount -o subvol=/root /dev/mapper/system /mnt`, prüfen mit `findmnt /mnt`, `/mnt/home` ansehen und nur dessen Inhalt löschen, dann `sudo umount /mnt`. Das echte Home liegt im Subvolume `/home` und ist davon nicht betroffen. **Das Ziel `/mnt` darf nicht fehlen:** Ohne Ziel nimmt `mount` den Eintrag aus der `fstab`, das Subvolume landet dann auf `/nix` und verdeckt den Store (am 02.11.2026 passiert: alle Programme und Icons weg, auch `sudo`, nur ein Neustart hilft). Im Subvolume liegt der gesamte persistente Systemzustand, außerhalb von `/mnt/home` nichts löschen.

Nacharbeiten:

- [ ] 4.7 Der erste Lauf über cron startete am 02.11.2026 um 17:07, der letzte fertige Snapshot war vom 26.08.2026. Abgeschlossen, wenn `last_snapshot` auf einen Snapshot von November zeigt. Back In Time läuft jetzt über cron: Ein Eintrag im System-Crontab startet stündlich `backup-job`, das Profil steht auf Modus 25 (anacron) und Back In Time sichert, sobald ein Tag vergangen ist. So holt es eine Sicherung nach, wenn der Rechner aus war. Der System-Crontab kommt aus der Konfiguration und übersteht den tmpfs, die Zeitstempel liegen im persistierten `~/.local/share/backintime`. Prüfen: `sudo grep backintime /etc/crontab`, `grep schedule.mode=25 ~/.config/backintime/config`, Back In Time öffnen (kein Fehler `cannot chdir(/var/cron)`). Nach spätestens einer Stunde: `ls -la /mount/Backup/backintime/*/*/*/ | tail` zeigt einen neuen Snapshot. Der alte Timer lief nie, weil `bin/backintime` im Paket fehlte, der letzte Snapshot kann also alt sein.
- [X] 4.8 KeePassXC-SSH-Agent einrichten: [`docs/keepassxc-ssh-agent.md`](docs/keepassxc-ssh-agent.md). Danach `ssh-add -l`. Bis dahin nutzt ssh die Datei `~/.ssh/id_ed25519`. Diese ist ohne Passphrase, nach der Einrichtung also aus `~/.ssh` löschen, `id_ed25519.pub` bleibt.
- [X] 4.9 DangerZone einmal starten. Beim ersten Start lädt es das Container-Image und prüft es mit cosign. Danach eine Test-PDF umwandeln.
- [ ] 4.10 Fluent Reader: In Miniflux unter Einstellungen → API-Schlüssel einen Key anlegen und ihn in Fluent Reader unter Einstellungen → Dienst eintragen. Funktioniert erst, wenn ServerPublic läuft.
- [ ] 4.11 EasyEffects: Das Preset `microphone` ist auf Rode Procaster und Behringer UMC22 abgestimmt (Eingang 1, 48V aus). Den Gain am UMC22 so einstellen, dass normale Sprache bei -18 bis -12 dBFS liegt, dann Probeaufnahme machen. Die Werte stammen aus den Datenblättern und sind nicht gemessen, Feinabstimmung siehe [`docs/microphone.md`](docs/microphone.md).
- [ ] 4.12 Hyprland ausprobieren: Abmelden → SDDM → Session „Hyprland“. Der Wetterort kommt aus sops (`weather-location`: Name, Breite, Länge als JSON, in `secrets/secrets.yaml` und `$PRIV/secrets/nixos-portable.yaml`). Tastenkürzel: Super+X → System → Keybindings oder `homeModules/desktop/windowManager/hyprland/README.md`.
- [ ] 4.13 Fusion 360: Die Installation ist fertig (02.11.2026, 11 GB im Prefix). `fusion360` starten und anmelden, die Anmeldung läuft über den Browser. Im Menü den Eintrag „Autodesk Fusion 360“ verwenden, nicht den von Wine erzeugten „Autodesk Fusion“ (Status 127, verschwindet beim Neustart). Startet es unter Wine nicht, ist die Alternative eine Windows-VM (siehe [`docs/virtual-machines.md`](docs/virtual-machines.md)).
- [X] 4.14 VRR/HDR wird beim Login per `kscreen-doctor` gesetzt. Den AVR-Monitor als Spiegel des Hauptmonitors einmalig in den KDE-Bildschirmeinstellungen einrichten (der Ausgabename ist unbekannt).

## Phase 5 – Laptops (NixOS-Framework, NixOS-Convertible)

- [ ] 5.1 Pro Laptop: Phase 4.1 bis 4.6 wiederholen. Am einfachsten direkt auf dem Laptop, beide Repos liegen dort durch Syncthing in `~/Documents`. `cd ~/Documents/nixos && sudo nixos-rebuild boot --flake .#NixOS-Framework` (bzw. `.#NixOS-Convertible`). Vorher prüfen, dass beide Repos samt `.git` aktuell sind (`git log -1`). Vom Desktop aus geht es mit der IP (`ip -br a` auf dem Laptop, die Laptops haben im Netz keinen Namen) und `--build-host jf@<IP> --target-host jf@<IP> --sudo --ask-sudo-password`, ohne `--build-host` kommt derselbe Signaturfehler wie auf dem Server.
- [ ] 5.1b Pro Laptop: SSH-Schlüssel in KeePassXC übernehmen. Der Agent selbst kommt mit dem Rollout aus der Konfiguration, die Einstellungen am Eintrag liegen in der Datenbank. Jeder Host hat einen eigenen Schlüssel, nur `~/.ssh/id_ed25519.pub` entscheidet, welcher angeboten wird. Deshalb pro Laptop: Eintrag „SSH id_ed25519 <Host>“ mit dem privaten Schlüssel dieses Laptops als Anhang anlegen, im Eintrag unter „SSH Agent“ Private key auf Attachment stellen, beide Haken setzen, Datenbank speichern. Prüfen mit `ssh-add -l` und `ssh admin@NixOS-Server1`, danach `rm ~/.ssh/id_ed25519`, die `.pub` bleibt. Liegt die Datenbank nicht auf dem Laptop, zuerst dorthin kopieren, sonst fehlt der Schlüssel im Agenten. NixOS-Portable hat noch keinen Schlüssel in `authorizedKeys`, das erledigt Tabelle 7B.
- [ ] 5.1a Pro Client (Framework, Convertible, Portable): Journal abarbeiten wie auf dem Desktop. Einmal in Plasma und in Hyprland an- und abmelden, neu starten, dann `journalctl -b -p err` und `coredumpctl list -S today`. Jede Meldung bewerten und in 13.1 eintragen. Erwartet: keine Coredumps nach dem Abmelden, kein `ordering cycle`, kein `kauditd hold queue overflow`, `systemctl --failed` und `systemctl --user --failed` sind leer. Eine einzelne Meldung `Failed to activate with specified passphrase` ist nur ein Tippfehler bei der LUKS-Eingabe.
- [ ] 5.2 Convertible: In Hyprland Touch-Gesten, die Bildschirmtastatur (Wisch vom unteren Rand nach oben) und die automatische Drehung (Tablet-Modus) testen.
- [ ] 5.3 Laptops: kanshi-Profile prüfen (Laptop allein / mit externem Monitor). Positionen bei Bedarf in `hosts/<host>/home/hyprland.nix` anpassen.

## Phase 6 – NixOS-Server1

- [X] 6.1 machine-id sichern: `ssh admin@NixOS-Server1 'sudo mkdir -p /persistent/etc && sudo cp /etc/machine-id /persistent/etc/machine-id'`.
- [X] 6.1a Mullvad-Gerät vor dem Neustart sichern, sonst braucht der erste Boot noch einmal einen freien Geräteplatz: `ssh admin@NixOS-Server1 'sudo mkdir -p /persistent/etc/mullvad-vpn && sudo cp -a /etc/mullvad-vpn/. /persistent/etc/mullvad-vpn/'`. Bisher lag `device.json` auf tmpfs, jeder Boot belegte einen neuen der fünf Plätze.
- [X] 6.1b Verwaiste Geräte entfernen: `ssh admin@NixOS-Server1 'mullvad account get; mullvad account list-devices'` zeigt das aktuelle Gerät und alle anderen. Geräte, die zu keinem aktiven Rechner gehören, mit `mullvad account revoke-device "<Name>"` entfernen. Nicht das eigene Gerät und nicht die der Clients entfernen.
- [ ] 6.2 Bauen und als Boot-Generation setzen: `nixos-rebuild boot --flake .#NixOS-Server1 --build-host admin@NixOS-Server1 --target-host admin@NixOS-Server1 --sudo --ask-sudo-password`, dann neu starten (Remote-Unlock per initrd-ssh). `sudo` fragt dabei noch nach dem bisherigen Passwort. `--build-host` ist nötig: `admin` ist kein `trusted-user`, der Server lehnt lokal gebaute, unsignierte Pakete ab (`lacks a signature by a trusted key`), baut sie aber selbst. Der erste Build dauert länger als 10 Minuten. Nach dem Neustart gilt für `admin` das neue Passwort aus KeePassXC (Hash in `site.nix`), das alte nicht mehr. `mutableUsers` ist aus.
- [ ] 6.2a Mullvad prüfen: Nach zwei Neustarts zeigt `mullvad account get` denselben `Device name`, `mullvad account list-devices` hat keinen neuen Eintrag, und `journalctl -b -u mullvad-daemon | grep login_account` ist leer.
- [ ] 6.3 Intel-GPU für Ollama prüfen: `ssh admin@NixOS-Server1 'nix shell nixpkgs#vulkan-tools -c vulkaninfo --summary'` muss die Intel-GPU zeigen. Danach im Log `journalctl -u ollama | grep -i vulkan`.
- [ ] 6.4 ComfyUI: `systemctl status podman-comfyui`. Der erste Start lädt das Image (mehrere GB). Danach `https://comfyui.<homeDomain>` öffnen und ein Modell (z. B. SDXL oder Flux) in `/pool01/applications/comfyui/models/checkpoints` legen. Falls der Container nach einem Neustart nicht startet: `podman-comfyui` ist in `hosts/NixOS-Server1/services.nix` noch nicht hinter `zfs-mounts-ready` eingereiht, dann dort ergänzen.
- [ ] 6.5 Neue DNS-Namen im Pi-hole: `comfyui`, `grafana`, `homebox` (kommen automatisch aus `lan.hosts`).
- [ ] 6.6 Externe Sicherung per Skript (erst nach 6.2 vorhanden, Anleitung in der README unter Operation): `sudo backup-external`. Der Lauf vom 03.11.2026 endete mit Code 23 (alte Windows-Streams als xattrs, FreeTube-Cache), beides ist jetzt ausgenommen. Nach dem nächsten Lauf prüfen: `sudo grep -c "rsync error" /root/.local/share/backintime/takesnapshot_.log` ist 0. Fortschritt: `sudo tail -f /root/.local/share/backintime/takesnapshot_.log`.
- [ ] 6.7 Loki-Alarm „ExecOutsideNixStore“ testen: per ssh eine Kopie von `/run/current-system/sw/bin/true` nach `/tmp` legen und ausführen. Innerhalb von 5 Minuten muss ein Alarm kommen (nach Phase 10).
- [ ] 6.8 Glance prüfen: Seite „Server“ mit den Abschnitten pro Server. Die externen Server zeigen erst Daten, wenn WireGuard steht (Phase 9).
- [ ] 6.9 Grafana: Dashboard „Security und Updates“ öffnen. Den ersten Scan von Hand starten: `sudo systemctl start vulnscan update-check` (lädt rund 3 GB Datenbank). Treffer sind Kandidaten, siehe [`docs/updates-and-vulnerabilities.md`](docs/updates-and-vulnerabilities.md).

## Phase 7 – Passwörter, Schlüssel und sops neu aufsetzen

Hintergrund: Die alte `secrets/secrets.yaml` und die alten Passwort-Hashes sind in der öffentlichen Git-Historie. Ändere deshalb alles, was dort stand.

7A – sops pro Host (siehe auch README → „Host keys for sops“):

- [ ] 7.1 Pro Host einen neuen age-Key erzeugen: `sudo nix shell nixpkgs#age -c age-keygen -o /secrets/keys.txt && sudo chmod 400 /secrets/keys.txt`. Den Public Key zeigt `age-keygen -y /secrets/keys.txt`.
- [ ] 7.2 Die Public Keys in `$PRIV/secrets/.sops.yaml` eintragen und die auskommentierten Zeilen (`#- *sops_desktop` usw.) aktivieren.
- [ ] 7.3 Pro Host eine Datei `$PRIV/secrets/<hostname>.yaml` anlegen und die Werte aus `sops -d $REPO/secrets/secrets.yaml` übernehmen, aber nur die des jeweiligen Hosts (Schlüsselliste unten).
- [ ] 7.4 Auf jedem Host `nixos.system.sops.perHostFile = true;` setzen (Portable, ServerPublic und ServerGaming haben das schon).
- [ ] 7.5 Wenn alle Hosts umgestellt sind: `git rm secrets/secrets.yaml secrets/.sops.yaml` im öffentlichen Repo.

7B – Was neu gesetzt werden muss und wo es eingetragen wird:

| Was | Neu erzeugen mit | Eintragen in |
|---|---|---|
| Login-Passwort pro Host | `mkpasswd -m sha-512 -R 500000` (Hash) | sops `user/<hostname>/<user>`, dann `nixos.system.user.passwordFromSops = true;` |
| Login-Passwort vor sops | erledigt (Phase 1.2), Hash mit `mkpasswd` | `$PRIV/site.nix` → `initialHashedPasswords` |
| LUKS-Passphrase | `sudo cryptsetup luksChangeKey /dev/disk/by-partlabel/disk-NIXOS-LUKS` (Mirror: `disk-NIXOS2-LUKS`) | nur KeePassXC |
| TPM2 + PIN neu binden | `systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto --tpm2-with-pin=yes --tpm2-pcrs=7 <luks>` | – |
| Recovery-Key | `systemd-cryptenroll --recovery-key <luks>` | Papier / KeePassXC |
| SSH-Benutzerschlüssel | `ssh-keygen -t ed25519 -C jf@<host>` | KeePassXC; Public Key in `authorizedKeys` in `nixosModules/system/ssh.nix` und `nixos.system.initrdssh.authorizedKeys` in `hosts/NixOS-Server1/machine.nix` |
| SSH-Hostkeys | `sudo rm /etc/ssh/ssh_host_*; sudo systemctl restart sshd` | `known_hosts` der Clients aktualisieren |
| initrd-Hostkey (Server) | `ssh-keygen -t ed25519 -N "" -f /etc/ssh/initrd_host_key` | – |
| WireGuard | `wg genkey \| tee priv \| wg pubkey` | sops `wireguard/<hostname>/private`, Public Key in `nixosModules/system/wireguard.nix` |
| Syncthing-Gerät | `syncthing generate --home /tmp/st` | sops `syncthing/<hostname>/cert` und `/key`; die neue Geräte-ID in `hosts/NixOS-Server1/syncthing.nix` |
| WLAN | im Router ändern | sops `wifi` (`ENV_HOME_SSID`, `ENV_HOME_PSK`, …) |
| NAS (SMB) | `smbpasswd` auf Server1 erfolgt per Aktivierung | sops `smb-share/user-jf`, `smb-share/user-meli` (Server1) und `nas-smb/user` (`username=`/`password=`, Clients) |
| WebDAV | Zufallswert | sops `webdav-share/user-jf` (`ENV_PASSWORD=`, Server1), Clients: `webdav-share/davfs` (`https://dav.<homeDomain>/ jf <passwort>`) |
| Radicale | Zufallswert | sops `radicale/htpasswd` (`jf:<passwort>`) |
| Forgejo | `openssl rand -hex 32` | sops `forgejo/secret`, `forgejo/token` |
| Linkwarden | Zufallswert | sops `linkwarden/postgres`, `linkwarden/secret` |
| SearXNG | `openssl rand -hex 32` | sops `searxng/secret` (`SEARXNG_SECRET=`) |
| Glance | – | sops `glance` (`ENV_PIHOLE_PASSWORD`, `ENV_LOCATION`, optional siehe 13.12) |
| Pi-hole-Weboberfläche | `sudo pihole setpassword`, danach `pwhash` aus `/etc/pihole/pihole.toml` kopieren | steht als Hash im öffentlichen Repo (`nixosModules/server/network/pihole.nix`), besser ins private `site.nix` verschieben |
| Grafana-Admin | beim ersten Login (Standard `admin`/`admin`) sofort ändern | nur KeePassXC |
| Syncthing-GUI, code-server, Matrix, coturn, Nextcloud, Stalwart | Zufallswert | sops der jeweiligen Hosts, siehe 7.7 und Phase 8 |
| NixOS-ServerGaming | wie ServerPublic: Login-Hash, DNS-API-Token, WireGuard, restic | `$PRIV/secrets/nixos-servergaming.yaml` |
| SABnzbd, Monero-RPC | in der App | sops `sabnzbd`, `monero/users/*` |
| ZFS-Schlüssel (Server1) | nur bei Neuanlage des Pools | sops `zfs/pool01` |
| Cloudflare / DNS-API | beim Anbieter neu erzeugen, nur Zone:DNS:Edit | sops `nginx/acme/api_key` |
| Mullvad, Alpha Vantage | beim Anbieter | sops `mullvad`, `alphavantage/api_key` |
| Unbenutzte Altlasten | löschen | `changeme`, `changeme_env`, `cloudflare/api_key`, `nginx/acme/email`, `user/nixos-vmdesktop/admin`, `user/nixos-vmserver/admin` |
| Dienst-Konten | in der jeweiligen Web-UI | Home Assistant, Jellyfin, Forgejo, Nextcloud, Stalwart, Matrix, Miniflux, HomeBox, Linkwarden |
| Externe Konten | beim Anbieter, 2FA prüfen | Proton, DLRG, 1&1, Mullvad, Registrar, Contabo, GitHub/Codeberg |

- [ ] 7.6 Danach auf jedem Host: `nixos-rebuild switch` und einmal neu anmelden. Von außen immer mit `--build-host` wie in 6.2.
- [ ] 7.7 Syncthing-GUI-Passwort von Server1 als bcrypt-Hash nach sops verschieben (`services.syncthing.guiPasswordFile`).
- [ ] 7.8 Radicale: htpasswd auf bcrypt umstellen (`htpasswd -B`), dann `htpasswd_encryption = "bcrypt"`.

7C – Alle Passwörter ändern: Ablauf für jeden Eintrag der Tabelle 7B

Jedes Passwort wird in KeePassXC erzeugt und dort zuerst gespeichert. So gibt es keinen Moment, in dem der neue Wert nur im Dienst steht.

- [ ] 7.9 In KeePassXC eine Gruppe `NixOS` mit Untergruppen pro Host anlegen. Für jedes Geheimnis ein Eintrag, Titel = sops-Name, z. B. `user/nixos-desktop/jf`, im Notizfeld die Datei (`secrets/secrets.yaml` oder `$PRIV/secrets/<hostname>.yaml`).
- [ ] 7.10 Passwort erzeugen, Würfel-Symbol im Eintrag:
  - Login, LUKS, alles was du tippst: Reiter „Passphrase“, 7 Wörter
  - Dienste und Tokens: Reiter „Passwort“, 40 Zeichen, nur Buchstaben und Ziffern, weil Sonderzeichen in Env-Dateien und YAML Probleme machen
  - Eintrag speichern, erst dann weitermachen
- [ ] 7.11 Wert eintragen, je nach Spalte in 7B:
  - Klartext-Secret: `sops <datei>`, den Schlüssel ersetzen, Format beibehalten (`ENV_PASSWORD=<wert>`, `jf:<wert>`, `username=` und `password=`)
  - Login-Passwort: Hash erzeugen mit `mkpasswd -m sha-512 -R 500000`, das Passwort aus KeePassXC einfügen, den Hash in sops unter `user/<hostname>/<user>` speichern. Nur der Hash kommt in sops.
  - Nur in der App oder Web-UI (Spalte „nur KeePassXC“, Dienst-Konten, externe Konten): dort ändern, sops bleibt unberührt
- [ ] 7.12 Dienste mit Klartext-Secret: Passwort zuerst im Dienst ändern, dann sops, dann `nixos-rebuild switch`. Dienst danach neu anmelden und testen.
- [ ] 7.13 Liste abarbeiten: In KeePassXC im Eintrag das Ablaufdatum auf ein Jahr setzen, dann erinnert KeePassXC an die nächste Rotation.
- [ ] 7.14 Abschluss: `git add` im jeweiligen Repo, committen, altes Passwort aus dem KeePassXC-Verlauf nur behalten, bis alle Geräte neu angemeldet sind. Danach sind die Werte in der alten Git-Historie wertlos.

## Phase 8 – NixOS-ServerPublic installieren

- [X] 8.1 Den VPS bestellen (Contabo, Anbieter siehe [`docs/providers.md`](docs/providers.md)) und die Daten in `$PRIV/site.nix` → `serverPublic` eintragen, committen, `nix flake update private`.
- [ ] 8.2 Den Host-Key vor der Installation erzeugen, Datei `keys.txt` außerhalb beider Repos ablegen: `nix shell nixpkgs#age -c age-keygen -o keys.txt`, den Public Key in `.sops.yaml` als `sops_serverpublic` eintragen, dann `sops updatekeys secrets/nixos-serverpublic.yaml`.
- [ ] 8.3 Die Platzhalter in `nixos-serverpublic.yaml` ersetzen (`cd $PRIV/secrets && sops nixos-serverpublic.yaml`). Der Login ist erledigt. Hash statt Klartext: `stalwart/admin` (`mkpasswd -m sha-512 -R 500000`), `codeserver/env` (`HASHED_PASSWORD=<argon2-Hash>`). Klartext nötig: `nextcloud/admin` (nach der Einrichtung in der Weboberfläche ändern), `restic/password`, `restic/home-env`, `nginx/acme/api_key` (DNS-API-Token), `mautrix-telegram/env` (API-ID und Hash von my.telegram.org), `mautrix-signal/env`, `mautrix-whatsapp/env`. Zufallswerte (`openssl rand -hex 32`): `matrix/*`, `coturn/secret`. WireGuard: `wireguard/nixos-serverpublic/private` (`wg genkey`). Nicht mehr gelesen, löschen: `codeserver/password`, `restic/storagebox-ssh-key`. Danach committen und `nix flake update private`.
- [ ] 8.4 Firewall im Contabo-Panel: Network Services → Firewall, Firewall pro Server anlegen, unter Inbound Rules die Regeln unten als Accept Rule mit Source „Any“ (IPv4 und IPv6) anlegen und den VPS unter Active VPS/VDS zuweisen. Eingehend bleibt alles andere gesperrt, ausgehend ist alles frei. Die Regeln greifen vor NixOS, dessen eigene Firewall bleibt zusätzlich aktiv. Prometheus-Ports (9100 usw.) laufen über WireGuard und brauchen keine Regel. Zuerst nur 22 und 2222 anlegen und installieren, die Dienste danach freigeben. Danach prüfen, ob ausgehende Verbindungen gehen (`curl -I https://nixos.org`, `chronyc sources`), die Doku von Contabo sagt nicht, ob die Regeln zustandsbehaftet sind.

| Port | Protokoll | ServerPublic | ServerGaming | Wofür |
|---|---|---|---|---|
| 22 | TCP | bis WireGuard steht | bis WireGuard steht | SSH, danach Regel löschen (8.17) |
| 2222 | TCP | ja | ja | LUKS-Entsperrung im initrd bei jedem Neustart, nie löschen |
| 80, 443 | TCP | ja | ja | Webdienste, BlueMap, Countdown |
| 25 | TCP | ja | nein | Mail von anderen Servern |
| 465, 587 | TCP | ja | nein | Mail senden |
| 993 | TCP | ja | nein | IMAP |
| 3478, 5349 | TCP und UDP | ja | nein | STUN/TURN (coturn) |
| 49152-49999 | UDP | ja | nein | TURN-Relay für Anrufe |
| 64738 | TCP und UDP | ja | nein | Mumble |
| 51820 | UDP | ja | nein | WireGuard-Hub |
| 25565 | TCP | nein | ja | Minecraft |
| ICMP | ICMP | ja | ja | IPv6 braucht ICMP, Ping beantwortet der Server trotzdem nicht |

- [ ] 8.5 Zuerst in der VM testen: `nixos-rebuild build-vm --flake .#NixOS-VMServerPublic`. Der hardened malloc und `security.lockKernelModules` sind aktiv. Die VM hat keinen age-Key, Dienste mit Secrets können deshalb unabhängig davon scheitern. Prüfen, ob die übrigen Dienste starten: `systemctl --failed`. Bricht ein Dienst ab, `nixos.system.hardening.hardenedMalloc = false;` setzen und das hier notieren.
- [ ] 8.5a Vor der Installation im Rescue-System von Contabo prüfen: `lsblk` (die Hosts erwarten `/dev/sda`, sonst `hosts/<Host>/disko.nix` anpassen) und `ls /sys/firmware/efi` (fehlt der Ordner, bootet der VPS per BIOS, dann `nixos.system.bootloader.biosDevice` setzen). Das konnte ich nicht testen.
- [ ] 8.6 Installieren: `nixos-anywhere --flake .#NixOS-ServerPublic --disk-encryption-keys /tmp/secret.key <passphrase-datei> --disk-encryption-keys /tmp/keyfile.key <keyfile> --extra-files <dir mit secrets/keys.txt, etc/ssh/initrd_host_key und persistent/etc/ssh/initrd_host_key> root@<ip>`. Den Hostkey in beide Pfade legen: Die Installation liest ihn unter `/etc/ssh`, nach dem ersten Boot kommt `/etc/ssh` aus `/persistent` (noch nicht getestet).
- [ ] 8.7 DNS-Einträge anlegen: A/AAAA für alle Dienstnamen, dazu `openpgpkey.<mailDomain>`. Für die Mail-Domain MX, SPF, DKIM, DMARC, MTA-STS und TLS-RPT (die Werte zeigt die Stalwart-Weboberfläche), außerdem CAA und PTR beim Anbieter. Port 25 beim Anbieter freischalten lassen.
- [ ] 8.8 Ersteinrichtung: Stalwart-Konten, Matrix-Nutzer (`register_new_matrix_user`), Bridge-Logins, Miniflux-Admin (`sudo -u miniflux env DATABASE_URL="user=miniflux host=/run/postgresql dbname=miniflux" miniflux -create-admin`), CryptPad `adminKeys`, ntfy-Admin, QR-Code der Briar-Mailbox (`journalctl -u podman-briar-mailbox`).
- [ ] 8.9 Ping ist absichtlich deaktiviert (`icmp_echo_ignore_all`). Monitoring per Ping funktioniert deshalb nicht, IPv6/ICMPv6 bleibt erlaubt.

8B – NixOS-ServerGaming installieren (Minecraft, BlueMap, Countdown)

- [X] 8.10 Eigener VPS bei Contabo (200 GB), Daten stehen in `$PRIV/site.nix`. Minecraft nutzt bis zu 12 GB RAM, der VPS braucht also 16 GB oder mehr.
- [ ] 8.11 Host-Key erzeugen wie in 8.2, in `$PRIV/secrets/.sops.yaml` als `sops_servergaming` eintragen, Zeilen aktivieren, `sops updatekeys nixos-servergaming.yaml`.
- [ ] 8.12 Die Platzhalter in `nixos-servergaming.yaml` ersetzen: `nginx/acme/api_key`, `wireguard/nixos-servergaming/private`, `restic/password`, `restic/home-env`. Der Login ist erledigt, `restic/storagebox-ssh-key` wird nicht mehr gelesen.
- [ ] 8.13 Countdown: In `hosts/NixOS-ServerGaming/server.nix` das echte Datum bei `target` eintragen (jetzt Platzhalter 01.01.2027) und die Texte prüfen. Der Name steht damit im öffentlichen Repo.
- [ ] 8.14 Testen in der VM (`nixos-rebuild build-vm --flake .#NixOS-VMServerGaming`), dann installieren wie in 8.6 mit `.#NixOS-ServerGaming`.
- [ ] 8.15 DNS: A/AAAA für `bluemap`, `countdown` und `flolserver` auf den Gaming-VPS.
- [ ] 8.16 Die Welt und die Mods vom alten Server nach `/srv/minecraft/flolserver` kopieren. BlueMap und Fabric API kommen aus dem Flake, gleichnamige alte Jars in `mods/` löschen. Prüfen: `https://bluemap.<domain>` (das erste Rendern dauert lange), `https://countdown.<domain>`.
- [ ] 8.17 WireGuard: Key erzeugen (Tabelle 7B), Public Key in `nixosModules/system/wireguard.nix` bei `NixOS-ServerGaming` eintragen, beide VPS neu bauen. Erst dann ist ssh nur noch über WireGuard erreichbar. Vorher `ssh admin@10.100.0.6` über den Tunnel testen, sonst bleibt nur initrd-ssh und die VNC-Konsole des Anbieters.
- [ ] 8.18 Restic-Benutzer `nixos-servergaming` in `resticserver/htpasswd` von Server1 ergänzen.

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
- [ ] 11.5 Thunderbird: Proton (Hauptkonto über die Bridge), Stalwart, DLRG und 1&1 kommen deklarativ aus `mailAccounts` und `mailAddress`, angezeigt werden sie mit ihrer Adresse. Einmalig: Bridge einrichten (`systemctl --user stop protonmail-bridge`, `protonmail-bridge --cli`, `login`, `info` zeigt das Bridge-Passwort) und deren Zertifikat in Thunderbird bestätigen, je Konto das Passwort eingeben. Zu prüfen: DLRG `mail.dlrg.de` (Quelle ist das DLRG-Wiki) und 1&1 `imap.1und1.de`/`smtp.1und1.de`, beide nicht getestet. Die Add-ons LanguageTool und CardBook bleiben manuell (siehe `Notes/Post-Installation.md`).
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
- [ ] 12.3a Journal prüfen wie in 5.1a.
- [ ] 12.4 Testen: Einen UEFI-Rechner (Secure Boot aus) und einen alten BIOS-Rechner davon booten. In der Bootauswahl den Eintrag mit `server` wählen: Die Dienste sind dann unter `https://<dienst>.portable.internal` erreichbar (selbstsigniertes Zertifikat einmal akzeptieren).
- [ ] 12.5 Kiwix-ZIMs, Jellyfin-Medien und die Ollama-/ComfyUI-Modelle (im Server-Modus `qwen3.5:4b`) nach `/persistent/server/...` kopieren.
- [ ] 12.6 Regelmäßig aktualisieren: `nixos-rebuild switch --flake .#NixOS-Portable --target-host` ist nicht möglich, wenn die SSD steckt. Stattdessen von ihr booten und `sudo nixos-rebuild switch --flake .#NixOS-Portable` ausführen.

## Phase 13 – Fehler, offene Prüfungen

- [ ] 13.1 Boot-Log auf jedem Host prüfen: `journalctl -b 0 -p err` (nur Fehler) und `journalctl -b 0 -p warning`. Auf den Clients ist das Punkt 5.1a. Befund auf NixOS-Desktop (18.10. und 02.11.2026):
  - [x] `systemd-cryptsetup: key file '/tmp/secret.key' missing`: behoben (disko `passwordFile` statt `settings.keyFile`)
  - [x] `bootctl: /boot ... random seed ... world accessible`: behoben (ESP mit `fmask=0077`)
  - [x] Journal zeigt nur den aktuellen Boot: behoben (`/etc/machine-id` persistiert, Phase 4.1)
  - [ ] `dbus-broker-launch: Ignoring duplicate name ...`: Kosmetik (der Dienst kommt doppelt aus system-path und Paket). Für den System-Bus per `LogFilterPatterns` gefiltert (`nixosModules/system/dbus.nix`). Die Meldungen des Session-Busses bleiben, der Filter wirkt nicht in User-Units.
  - [ ] `Invalid framebuffer status: GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT` (16-mal): Prozess finden (`journalctl -b -p err -o verbose | grep -B20 GL_FRAMEBUFFER | grep _COMM`), vermutlich KWin/Plasma mit amdgpu
  - [x] `kauditd hold queue overflow`: behoben, `backlogLimit` ist 8192 (`nixosModules/system/hardening.nix`), am 02.11.2026 nach dem Reboot 0 Treffer.
  - [ ] Coredump-Kette und Einfrieren beim Abmelden aus Hyprland: Die Hooks in `hyprland.shutdown` (auch der von Home Manager) stoppen die Dienste blockierend, der Compositor wartet auf die Dienste und die Dienste auf ihn. `session-logout` stoppt sie jetzt vorher, Super+Shift+Q, wlogout und Waybar nutzen es. Prüfen: Abmelden dauert wenige Sekunden, `coredumpctl list -S today` zeigt nichts Neues.
  - [x] `wallpaper-random: Found ordering cycle`: behoben, der Dienst hängt jetzt an `awww.service` statt am Target.
  - [x] `backintime: cannot chdir(/var/cron)`: behoben, siehe 4.7.
  - [x] `systemd-cryptsetup: Failed to activate with specified passphrase`: einmaliger Tippfehler bei der LUKS-Eingabe (15:01:29), der zweite Versuch 6 Sekunden später war erfolgreich. Keine Konfiguration betroffen.
  - [x] `chronyd: Could not connect ... No route to host`: harmlos. IPv6 ist beim Start von chronyd noch nicht bereit, 15 Sekunden später steht NTS (`chronyc -n sources`).
  - [ ] ddcutil-Meldungen (`dw_start_watch_displays`): von PowerDevil, harmlos
  - [x] `ucsi_acpi USBC000:00: GET_CABLE_PROPERTY failed` (Framework): Firmware meldet die Kabeldaten nicht, harmlos.
  - [ ] `baloo_file_extractor ... App info not found` und `MDB_BAD_RSLOT` (einmal pro Boot, 10 Minuten nach dem Login): harmlos, die Indexierung läuft weiter. Der Index ist 12 GiB groß, ggf. Baloo einschränken (`balooctl6 status`)
  - [ ] Dasselbe auf Framework, Convertible, Server1 und ServerPublic prüfen und hier ergänzen
- [ ] 13.2 nscd: In 128 Boot-Journalen gibt es keinen Startfehler nach dem Reboot. Der einzige Ausfall (18.10. 18:02) kam von einem Netzwerkausfall (IPv6-Präfixwechsel, DNS degradiert): Alle nsncd-Worker hingen an DNS-Anfragen, systemd hat den Dienst neu gestartet. Nach Phase 4 (machine-id) nach dem nächsten Reboot `journalctl -b -1 -u nscd` und `systemctl status nscd` prüfen. Tritt es wieder auf: `journalctl -b -u nscd` und die Zeit mit `journalctl -b -u NetworkManager` vergleichen.
- [ ] 13.4 hyprgrass: Nach dem nächsten `nix flake update` prüfen, ob `pkgs.hyprlandPlugins.hyprgrass` wieder baut. Dann `pkgs/hyprgrass` löschen und in `touch.nix` `pkgs.hyprlandPlugins.hyprgrass` verwenden.
- [ ] 13.5 Ventoy ist mit Version als unsicheres Paket erlaubt (`nixosModules/system/nixos.nix`). Die Version nach nixpkgs-Updates anpassen.
- [X] 13.6 Die Images von networkingtoolbox und ComfyUI sind per Digest in `pkgs/images.json` gepinnt. Aktualisieren: `nix run .#update-images`, siehe [`docs/updates-and-vulnerabilities.md`](docs/updates-and-vulnerabilities.md).
- [ ] 13.7 Den Installer-Download (`curl ... | bash`) auf einen Tag oder Commit pinnen und eine Prüfsumme verifizieren.
- [ ] 13.8 HomeBox: Nach dem Anlegen der Konten `allowRegistration = false` setzen. Linkwarden: `enableRegistration` abschalten.
- [ ] 13.9 Monero: Secret `monero/p2pool-env` (`WALLET_ADDRESS=...`) und `nixos.server.tools.moneronode.p2pool.enable = true`. Bestehende monero-gui-Configs brauchen den Remote-Node `NixOS-Server1:18089` (manuell).
- [ ] 13.10 Optional: MollySocket (`nixos.server.public.mollysocket`, Secret `mollysocket/env`), Murmur-Serverpasswort (`passwordProtected`, Secret `murmur/env`).
- [ ] 13.11 WebDAV-Mount auf den Clients einschalten: Secret `webdav-share/davfs` anlegen und `nixos.userEnvironment.networkshares.webdav.enable = true`.
- [ ] 13.12 Glance-Widgets einschalten: API-Keys in sops `glance` ergänzen, dann in `hosts/NixOS-Server1/server.nix` unter `glance` einschalten:
  - [ ] Jellyfin: Dashboard → API-Schlüssel, `ENV_JELLYFIN_TOKEN=`, `jellyfin.enable`
  - [ ] Sonarr und Radarr: Einstellungen → Allgemein, `ENV_SONARR_KEY=`, `ENV_RADARR_KEY=`, `calendar.enable`
  - [ ] Miniflux: Einstellungen → API-Schlüssel, `ENV_MINIFLUX_TOKEN=`, `miniflux.enable`
  - [ ] Home Assistant: Profil → langlebiges Token, `ENV_HA_TOKEN=`, `homeassistant.enable` und `homeassistant.entities`
- [ ] 13.13 Blocklisten aktualisiert `nix flake update` (`blocklistproject`, `perflyst`, `stevenBlack` sind `github:`-Inputs). Die Grafana-Dashboards haben kein Repo, ihre Revision steht als Zahl in `flake.nix` und wird dort von Hand erhöht, `revisions/latest` bricht auf frischen Hosts mit `mismatch in field narHash` ab. Pins aktuell halten: Der Update-Check meldete am 01.11.2026 Dangerzone v0.11.1 (gepinnt ist v0.11.0), dazu neuere Commits und Images. Ablauf in [`docs/updates-and-vulnerabilities.md`](docs/updates-and-vulnerabilities.md).
- [ ] 13.14 CVE-Kandidaten sichten: Dashboard „Security und Updates“. Geprüfte False Positives in `nixos.system.vulnscan.ignore` eintragen.
- [ ] 13.15 hypr-dynamic-cursors: Die Version aus nixpkgs (2026-07-21) wirft auf Hyprland 0.56.2 beim Laden eine Exception und ist deshalb aus `plugins` in `homeModules/desktop/windowManager/hyprland/hyprland.nix` entfernt. Nach einem `nix flake update` wieder eintragen und mit `hyprctl plugin list` prüfen, die Einstellungen in `config/hyprland.lua` sind noch da.
- [ ] 13.17 Titelleisten in Plasma prüfen: Unter Hyprland gesetzte Variablen (`NIXOS_OZONE_WL`, `QT_WAYLAND_DISABLE_WINDOWDECORATION`) landeten über `variables = --all` im User-Manager und damit in der nächsten Plasma-Sitzung. Electron-Programme liefen dadurch nativ auf Wayland mit eigener Titelleiste. Jetzt werden nur noch die nötigen Variablen exportiert. Nach dem Neustart prüfen: `systemctl --user show-environment | grep -c NIXOS_OZONE_WL` ist 0, auch nach einem Wechsel von Hyprland zu Plasma.
- [ ] 13.18 Server nach dem Einspielen von Updates neu starten. Kernel und initrd greifen erst dann, Server1 und die VPS warten danach auf die LUKS-Entsperrung per SSH.
- [ ] 13.19 `flake.lock` aktualisieren, sobald `hyprtasking` und `hyprgrass` Hyprland 0.57 unterstützen, heute bauen beide nicht (Stand 02.11.2026, auch nicht in der neuesten Version). Beim Update nötig: `boot.initrd.systemd.enable` und `preLVM` entfernen, Nextcloud-Admin per `nextcloud-occ` statt `adminuser`/`adminpassFile`, Ventoy-Version anpassen, Lutris auf Portable braucht das kaputte GTK2. Danach alle Hosts bauen, Popups testen, Waybar-Patch prüfen.
- [ ] 13.16 Hyprland: Lag beim Klick auf Waybar-Elemente beobachten. In der Sandbox nicht reproduzierbar: rofi, wlogout, pavucontrol und kitty öffnen in 0,06 bis 0,27 s, auch mit den echten 87 `XDG_DATA_DIRS`, Waybar liegt im Leerlauf bei 0 % CPU. Geändert wurden die wahrscheinlichsten Ursachen der echten Session: Unter Hyprland lief das KDE-Portal (`portals.conf` mit `default=kde` hatte Vorrang), jetzt `hyprland;gtk`. Außerdem keine CSS-Übergänge mehr in Waybar und weniger Blur. Tritt es noch auf, zuerst notieren, welches Element es trifft (Tray-Menüs, Tooltips oder alles), dann `hyprctl plugin unload` für hyprtasking testen (das Plugin hängt an den Mausklicks) und `journalctl --user -b | grep -iE "portal|timeout"` ansehen.

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
- [ ] 15.10 Wiki: In Forgejo das Repository `wiki` anlegen und das Wiki aktivieren. Die Inhalte stehen in [`WIKI-TODO.md`](WIKI-TODO.md).

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

## Phase 17 – Privates Repo auf GitHub, Merge nach `main` und automatische Updates

Erst wenn die Hosts auf dem neuen Stand laufen. Bis dahin ist `system.autoUpgrade` aus, sonst würden die Server nachts auf den alten Stand von `main` zurückspringen.

- [ ] 17.1 Privates Repository anlegen. `site.nix` enthält Domains und Passwort-Hashes, die YAML-Dateien sind verschlüsselt:
  - [ ] `cd $PRIV && gh auth login` (GitHub.com, Protokoll SSH, `~/.ssh/id_ed25519.pub` hochladen)
  - [ ] `gh repo create xerhaxs/nixos-private --private --source=. --remote=origin --push`
  - [ ] `gh repo view xerhaxs/nixos-private --json visibility` muss `PRIVATE` zeigen
- [ ] 17.2 In `flake.nix` umstellen: `url = "git+ssh://git@github.com/xerhaxs/nixos-private.git";`, dann `nix flake update private`, `nix flake metadata | grep private`, committen.
- [ ] 17.3 Ab jetzt lokal `nixos-rebuild boot --sudo --flake .#<host>` statt `sudo nixos-rebuild ...` verwenden, dann läuft die Evaluation als `jf` mit deinem SSH-Key. root hat keinen.
- [ ] 17.4 Deploy-Keys für Server1, ServerPublic und ServerGaming: pro Host `ssh-keygen -t ed25519 -N "" -f deploy`, den Public Key in GitHub unter Repo → Settings → Deploy keys eintragen (nur Lesezugriff), den Private Key in sops als `github/deploy-key`. Dafür fehlt noch ein Modul: Secret deklarieren, System-SSH für `github.com` darauf zeigen, `programs.ssh.knownHosts` setzen. `/root` liegt auf tmpfs, der Key kann also nicht dort liegen.
- [ ] 17.5 Installer: Das Live-System braucht ebenfalls Zugriff auf das private Repo, in `NixOSInstaller.sh` ergänzen (Key abfragen wie den age-Key).
- [ ] 17.6 `rework` nach `main` mergen und pushen, vorher Prüfung aus 2.3 auf dem gesamten Diff.
- [ ] 17.7 In `hosts/NixOS-Server1/configuration.nix`, `hosts/NixOS-ServerPublic/configuration.nix` und `hosts/NixOS-ServerGaming/configuration.nix` wieder `system.autoUpgrade.enable = true;` setzen, committen, einmal deployen. Am nächsten Morgen `systemctl status nixos-upgrade` prüfen.
