# TODO – Schritt-für-Schritt-Anleitung

Stand 08.11.2026 abends: Desktop, Laptops, Server1, ServerPublic und ServerGaming laufen auf dem Rework, Phase 7 (alle Secrets neu) ist erledigt. Offen ist zuerst Phase 27: die Änderungen vom 08.11.2026 ausrollen. Danach die Abschnitte in der Reihenfolge dieser Datei abarbeiten. Die frühere Abnahme-Checkliste ist im Funktionstest (Phase 21, Punkt 21.9) aufgegangen.

Aufbau: Teil A ist erledigt und bleibt zum Nachschlagen stehen (die Tabellen in Phase 7 werden später noch gebraucht). Teil B ist die Arbeitsreihenfolge: zuerst, was du allein am Rechner erledigst, danach was andere Geräte oder Personen braucht (Handy, Meli, Heimnetz), am Ende Wartung und Ideen. Die Punktnummern sind feste Kennungen, Verweise wie „siehe 13.29“ bleiben gültig, auch wenn ein Punkt in einen anderen Abschnitt gewandert ist.

Konventionen:

- `$REPO` = `/mount/Data/Datein/Dokumente/nixos`, `$PRIV` = `/mount/Data/Datein/Dokumente/nixos-private`.
- Secrets bearbeiten: `sops <datei>` im privaten Repo, `secrets/clients.yaml` (Desktop, Framework, Convertible) oder `secrets/nixos-<host>.yaml` (Server, Portable). KeePassXC muss entsperrt sein (Admin-Schlüssel).
- Features, die ein noch nicht vorhandenes Secret brauchen, sind eingebaut, aber ausgeschaltet. sops prüft beim Build, ob jedes deklarierte Secret existiert.

---

# Teil A – Erledigt (zum Nachschlagen)

## Phase 0 – Sichern und Überblick verschaffen

- [X] 0.1 Sicherung beider Repos anlegen, nicht nach `~`, denn das Home liegt auf tmpfs und ist nach einem Reboot weg: `cp -a $REPO /mount/Backup/nixos-backup-$(date +%F)` und `cp -a $PRIV /mount/Backup/nixos-private-backup-$(date +%F)`.
- [X] 0.2 Aktuelle Generation notieren: `nixos-rebuild list-generations | tail -3` (für einen möglichen Rollback).
- [X] 0.3 Änderungen ansehen: `cd $REPO && git status && git diff --stat`. Neue Ordner: `pkgs/`, `docs/`, `hosts/NixOS-Portable/`, `hosts/NixOS-VMServerPublic/`, Hyprland-Module.
- [X] 0.4 Die damalige Abnahme-Checkliste einmal komplett durchgelesen (`CHECKLIST.md`, seit 08.11.2026 in 21.9 aufgegangen und gelöscht).

## Phase 1 – Privates Repository vorbereiten

- [X] 1.1 `cd $PRIV && git status`. Neu bzw. geändert sind `site.nix` (initiale Passwort-Hashes), `secrets/.sops.yaml` (Regeln für `initial-passwords.yaml` und `nixos-portable.yaml`), `secrets/initial-passwords.yaml` und `secrets/nixos-portable.yaml`.
- [X] 1.2 Eigene Login-Passwörter in KeePassXC anlegen. Klartext liegt nur dort, die Hashes (sha512crypt, 500 000 Runden) stehen in `site.nix` unter `initialHashedPasswords`, bei ServerPublic und ServerGaming in sops. `secrets/initial-passwords.yaml` ist gelöscht (02.11.2026).
- [X] 1.3 In `site.nix` ergänzen:
  - [X] `mailAddress = "<du>@<domain>";` und `mailRealName = "<Name>";` (Thunderbird-Konto, CalDAV/CardDAV von Stalwart)
  - [X] `serverPublic`: Daten aus dem Contabo Customer Panel unter Network Services → IP Assignment, Button (i): `ipv4`, `ipv4Gateway`, `ipv4PrefixLength` (aus der Netzmaske, 255.255.240.0 ist 20), `ipv6` (eine Adresse aus dem Netz, z. B. `<Präfix>::1`) und `ipv6PrefixLength`. Die Einträge `interface` und `storageBox` löschen, beide werden nicht mehr gelesen.
  - [X] `serverGaming`: dasselbe für den Gaming-Server
  - [X] `mailAccounts`: Adressen von Proton, DLRG und 1&1
- [X] 1.5 In `secrets/nixos-portable.yaml` die Platzhalter `REPLACE_ME` ersetzen (`sops secrets/nixos-portable.yaml`): WLAN, Mullvad, NAS-SMB-Zugang, Alpha-Vantage-Key, `glance` → `ENV_LOCATION`. Die Werte kopierst du aus `sops -d secrets/secrets.yaml` im öffentlichen Repo. Nachtrag 06.11.2026: Die Datei wurde mit Claude angelegt, und die kopierten Werte stammen aus der alten gemeinsamen Datei. Alle Werte werden in 7D-1 neu erzeugt.
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

- [X] 3.1 Alle Hosts evaluieren: `for h in NixOS-Desktop NixOS-Framework NixOS-Convertible NixOS-Server1 NixOS-ServerGaming NixOS-ServerPublic NixOS-Portable NixOS-VMDesktop NixOS-VMServer1 NixOS-VMServerGaming NixOS-VMServerPublic; do nix eval --raw .#nixosConfigurations.$h.config.system.build.toplevel.drvPath >/dev/null && echo "OK $h"; done`
- [X] 3.2 Den Desktop bauen: `nixos-rebuild build --flake .#NixOS-Desktop`. Das dauert, DangerZone und hyprgrass werden lokal gebaut.
- [X] 3.3 Unterschiede ansehen: `nix run nixpkgs#nvd -- diff /run/current-system ./result`.
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

- [X] 4.7 Der erste Lauf über cron startete am 02.11.2026 um 17:07, der letzte fertige Snapshot war vom 26.08.2026. Abgeschlossen, wenn `last_snapshot` auf einen Snapshot von November zeigt. Back In Time läuft jetzt über cron: Ein Eintrag im System-Crontab startet stündlich `backup-job`, das Profil steht auf Modus 25 (anacron) und Back In Time sichert, sobald ein Tag vergangen ist. So holt es eine Sicherung nach, wenn der Rechner aus war. Der System-Crontab kommt aus der Konfiguration und übersteht den tmpfs, die Zeitstempel liegen im persistierten `~/.local/share/backintime`. Prüfen: `sudo grep backintime /etc/crontab`, `grep schedule.mode=25 ~/.config/backintime/config`, Back In Time öffnen (kein Fehler `cannot chdir(/var/cron)`). Nach spätestens einer Stunde: `ls -la /mount/Backup/backintime/*/*/*/ | tail` zeigt einen neuen Snapshot. Der alte Timer lief nie, weil `bin/backintime` im Paket fehlte, der letzte Snapshot kann also alt sein.
- [X] 4.8 KeePassXC-SSH-Agent einrichten: [`docs/keepassxc-ssh-agent.md`](docs/keepassxc-ssh-agent.md). Danach `ssh-add -l`. Bis dahin nutzt ssh die Datei `~/.ssh/id_ed25519`. Diese ist ohne Passphrase, nach der Einrichtung also aus `~/.ssh` löschen, `id_ed25519.pub` bleibt.
- [X] 4.9 DangerZone einmal starten. Beim ersten Start lädt es das Container-Image und prüft es mit cosign. Danach eine Test-PDF umwandeln.
- [X] 4.10 Fluent Reader: In Miniflux unter Einstellungen → API-Schlüssel einen Key anlegen und ihn in Fluent Reader unter Einstellungen → Dienst eintragen. Funktioniert erst, wenn ServerPublic läuft.
- [X] 4.12 Hyprland: nach Phase 18 verschoben.
- [X] 4.14 VRR/HDR wird beim Login per `kscreen-doctor` gesetzt. Den AVR-Monitor als Spiegel des Hauptmonitors einmalig in den KDE-Bildschirmeinstellungen einrichten (der Ausgabename ist unbekannt).
- [X] 4.15 Browser-Erweiterungen entfernen: In LibreWolf CanvasBlocker und „I still don't care about cookies“ von Hand deinstallieren (`about:addons`), beide stehen nicht in der Config. In Brave dasselbe unter `brave://extensions`. „I still don't care about cookies“ war dort per Richtlinie zwangsinstalliert, ist seit 03.11.2026 aus `nixosModules/userEnvironment/chromium-policies.nix` entfernt und verschwindet nach dem Rebuild vermutlich von selbst. Sonst von Hand entfernen.

## Phase 5 – Laptops (NixOS-Framework, NixOS-Convertible)

- [X] 5.1 Pro Laptop: Phase 4.1 bis 4.6 wiederholen. Am einfachsten direkt auf dem Laptop, beide Repos liegen dort durch Syncthing in `~/Documents`. `cd ~/Documents/nixos && sudo nixos-rebuild boot --flake .#NixOS-Framework` (bzw. `.#NixOS-Convertible`). Vorher prüfen, dass beide Repos samt `.git` aktuell sind (`git log -1`). Vom Desktop aus geht es mit der IP (`ip -br a` auf dem Laptop, die Laptops haben im Netz keinen Namen) und `--build-host jf@<IP> --target-host jf@<IP> --sudo --ask-sudo-password`, ohne `--build-host` kommt derselbe Signaturfehler wie auf dem Server.
- [X] 5.1b Pro Laptop: SSH-Schlüssel in KeePassXC übernehmen. Der Agent selbst kommt mit dem Rollout aus der Konfiguration, die Einstellungen am Eintrag liegen in der Datenbank. Jeder Host hat einen eigenen Schlüssel, nur `~/.ssh/id_ed25519.pub` entscheidet, welcher angeboten wird. Deshalb pro Laptop: Eintrag „SSH id_ed25519 <Host>“ mit dem privaten Schlüssel dieses Laptops als Anhang anlegen, im Eintrag unter „SSH Agent“ Private key auf Attachment stellen, beide Haken setzen, Datenbank speichern. Prüfen mit `ssh-add -l` und `ssh admin@NixOS-Server1`, danach `rm ~/.ssh/id_ed25519`. Die `.pub` schreibt seit 06.11.2026 Home Manager aus `authorizedKeys` (Kommentar `jf@<Host>`), sie ist auch nach einer Neuinstallation wieder da. Liegt die Datenbank nicht auf dem Laptop, zuerst dorthin kopieren, sonst fehlt der Schlüssel im Agenten. NixOS-Portable hat noch keinen Schlüssel in `authorizedKeys`, das erledigt 22.2 (Schritte wie bei den anderen Clients, nur ohne alten Schlüssel).
- [X] 5.1a Pro Client (Framework, Convertible, Portable): Journal abarbeiten wie auf dem Desktop. Einmal in Plasma und in Hyprland an- und abmelden, neu starten, dann `journalctl -b -p err` und `coredumpctl list -S today`. Jede Meldung bewerten und in 13.1 eintragen. Erwartet: keine Coredumps nach dem Abmelden, kein `ordering cycle`, kein `kauditd hold queue overflow`, `systemctl --failed` und `systemctl --user --failed` sind leer. Eine einzelne Meldung `Failed to activate with specified passphrase` ist nur ein Tippfehler bei der LUKS-Eingabe.
- [X] 5.2 Convertible in Plasma: automatische Drehung testen. Der Lagesensor läuft über `iio-sensor-proxy` (`hardware.sensor.iio.enable`), KWin dreht damit selbst.
  - [X] Sensor prüfen: `nix shell nixpkgs#iio-sensor-proxy -c monitor-sensor`, dann das Gerät drehen. Es muss `Accelerometer orientation changed` erscheinen.
  - [X] Systemeinstellungen → Anzeige und Monitor → Ausrichtung: „Automatisch“ bzw. „Nur im Tablet-Modus“. In den Tablet-Modus klappen und drehen, das Bild muss folgen. Tut es das nur bei „Automatisch“, meldet das Gerät den Tablet-Modus nicht (`libinput debug-events | grep -i switch` beim Umklappen).
  - [X] Touch und Stift folgen der Drehung (die Eingabe zeigt nach dem Drehen auf die richtige Stelle), dabei auch die Wacom-Meldungen aus 13.1 prüfen.
  - [X] Bildschirmtastatur in Plasma: Systemeinstellungen → Tastatur → Virtuelle Tastatur. Ist keine auswählbar, hier notieren.
- [X] 5.3 Hyprland-Punkte der Laptops (kanshi, Touch-Gesten): nach Phase 18 verschoben.

## Phase 6 – NixOS-Server1

- [X] 6.1 machine-id sichern: `ssh admin@NixOS-Server1 'sudo mkdir -p /persistent/etc && sudo cp /etc/machine-id /persistent/etc/machine-id'`.
- [X] 6.1a Mullvad-Gerät vor dem Neustart sichern, sonst braucht der erste Boot noch einmal einen freien Geräteplatz: `ssh admin@NixOS-Server1 'sudo mkdir -p /persistent/etc/mullvad-vpn && sudo cp -a /etc/mullvad-vpn/. /persistent/etc/mullvad-vpn/'`. Bisher lag `device.json` auf tmpfs, jeder Boot belegte einen neuen der fünf Plätze.
- [X] 6.1b Verwaiste Geräte entfernen: `ssh admin@NixOS-Server1 'mullvad account get; mullvad account list-devices'` zeigt das aktuelle Gerät und alle anderen. Geräte, die zu keinem aktiven Rechner gehören, mit `mullvad account revoke-device "<Name>"` entfernen. Nicht das eigene Gerät und nicht die der Clients entfernen.
- [X] 6.2 Bauen und als Boot-Generation setzen: `nixos-rebuild boot --flake .#NixOS-Server1 --build-host admin@NixOS-Server1 --target-host admin@NixOS-Server1 --sudo --ask-sudo-password`, dann neu starten (Remote-Unlock per initrd-ssh). `sudo` fragt dabei noch nach dem bisherigen Passwort. `--build-host` ist nötig: `admin` ist kein `trusted-user`, der Server lehnt lokal gebaute, unsignierte Pakete ab (`lacks a signature by a trusted key`), baut sie aber selbst. Der erste Build dauert länger als 10 Minuten. Nach dem Neustart gilt für `admin` das neue Passwort aus KeePassXC (Hash in `site.nix`), das alte nicht mehr. `mutableUsers` ist aus.
- [X] 6.2a Mullvad prüfen (am 03.11.2026 nach dem Neustart: Gerät war widerrufen, das Autologin erkannte das nicht, behoben): Nach zwei Neustarts zeigt `mullvad account get` denselben `Device name`, `mullvad account list-devices` hat keinen neuen Eintrag, und `journalctl -b -u mullvad-daemon | grep login_account` ist leer.
- [X] 6.3 (03.11.2026: Ollama nutzt die Arc A310 per Vulkan) Intel-GPU für Ollama prüfen: `ssh admin@NixOS-Server1 'nix shell nixpkgs#vulkan-tools -c vulkaninfo --summary'` muss die Intel-GPU zeigen. Danach im Log `journalctl -u ollama | grep -i vulkan`.
- [X] 6.4 ComfyUI: `systemctl status podman-comfyui`. Der erste Start lädt das Image (mehrere GB). Danach `https://comfyui.<homeDomain>` öffnen und ein Modell (z. B. SDXL oder Flux) in `/pool01/applications/comfyui/models/checkpoints` legen. Am 03.11.2026 scheiterte der Start mit `statfs /pool01/applications/comfyui/models: no such file or directory`, ebenso Prometheus, Loki und HomeBox: `systemd-tmpfiles-setup` läuft vor dem Mount der verschlüsselten Datasets, die Ordner landeten verdeckt unter dem Mountpunkt. Jetzt wendet `zfs-mounts-ready` die tmpfiles-Regeln für `/pool01` nach dem Mount noch einmal an, `podman-comfyui` wartet darauf. Nach dem Deploy prüfen: `systemctl is-active podman-comfyui prometheus loki homebox`.
- [X] 6.5 Neue DNS-Namen im Pi-hole: `comfyui`, `grafana`, `homebox` (kommen automatisch aus `lan.hosts`).
- [X] 6.6 Externe Sicherung per Skript (erst nach 6.2 vorhanden, Anleitung in der README unter Maintenance): `sudo backup-external`. Der Lauf vom 03.11.2026 endete mit Code 23 (alte Windows-Streams als xattrs, FreeTube-Cache), beides ist jetzt ausgenommen. Nach dem nächsten Lauf prüfen: `sudo grep -c "rsync error" /root/.local/share/backintime/takesnapshot_.log` ist 0. Fortschritt: `sudo tail -f /root/.local/share/backintime/takesnapshot_.log`.
- [X] 6.9 Grafana: Dashboard „Security and Updates“ öffnen. Den ersten Scan von Hand starten: `sudo systemctl start vulnscan update-check` (lädt rund 3 GB Datenbank). Treffer sind Kandidaten, siehe [`docs/updates-and-vulnerabilities.md`](docs/updates-and-vulnerabilities.md).

## Phase 7 – Passwörter, Schlüssel und sops neu aufsetzen

Hintergrund: Die alte `secrets/secrets.yaml` und die alten Passwort-Hashes sind in der öffentlichen Git-Historie. Ändere deshalb alles, was dort stand.

7A – sops: getrennte Dateien und Schlüssel (Plan vom 06.11.2026, siehe auch README → „Host keys for sops“)

Ziel: Ein gehackter Server betrifft nur seine eigene Datei, Server und Clients teilen keine Datei. Jeder Host hat einen eigenen Schlüssel in `/secrets/keys.txt`, der Admin-Schlüssel liegt nur in KeePassXC. Auf jeden Host kommt nur seine eigene sops-Datei, nicht mehr das ganze private Repo (seit 06.11.2026 im Code, `nixos.system.sops.file`).

| Datei in `$PRIV/secrets/` | Hosts | Verschlüsselt für |
|---|---|---|
| `clients.yaml` | Desktop, Framework, Convertible | Admin, `sops_desktop`, `sops_framework`, `sops_convertible` |
| `nixos-server1.yaml` | Server1 | Admin, `sops_server1` (neu erzeugen) |
| `nixos-serverpublic.yaml` | ServerPublic | Admin, `sops_serverpublic` |
| `nixos-servergaming.yaml` | ServerGaming | Admin, `sops_servergaming` |
| `nixos-portable.yaml` | Portable (eigene Datei, die SSD geht am ehesten verloren) | Admin, `sops_portable` |

Werte, die mehrere Seiten brauchen (`mullvad`, `radicale/htpasswd`), stehen in beiden Dateien. Geht ein Client verloren: seinen Schlüssel aus `.sops.yaml` streichen, `sops updatekeys -y clients.yaml`, die Werte in `clients.yaml` rotieren. Die Server bleiben unberührt.

- [X] 7.0 Admin-Schlüssel nur noch in KeePassXC. Voraussetzung: Desktop mit dem Stand vom 06.11.2026 neu gebaut und neu angemeldet (`echo $SOPS_AGE_KEY_CMD` zeigt einen Pfad).
  - [X] Neuen Admin-Schlüssel erzeugen, ohne Datei: `nix shell nixpkgs#age -c age-keygen`. Die Zeile `AGE-SECRET-KEY-1…` als Passwort in einen neuen KeePassXC-Eintrag „sops age admin“, URL `https://sops-admin.invalid`, den Public Key (`age1…`) in die Notizen. Der alte Schlüssel lag als Datei auf mehreren Rechnern und kann die öffentliche Git-Historie von `secrets/secrets.yaml` lesen, deshalb ein neuer.
  - [X] Einmal verbinden: `kpxc-cred configure` (KeePassXC entsperrt, Verbindung bestätigen und benennen).
  - [X] In `$PRIV/secrets/.sops.yaml` und `$REPO/secrets/.sops.yaml` bei `sops_jf` den neuen Public Key eintragen. Dann mit dem alten Schlüssel neu verschlüsseln: `cd $PRIV/secrets && for f in nixos-*.yaml; do SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops updatekeys -y $f; done`, ebenso `$REPO/secrets/secrets.yaml`.
  - [X] Test: `sops -d $PRIV/secrets/nixos-portable.yaml | head -3`. KeePassXC fragt nach dem Zugriff, „Merken“ wählen.
  - [X] Erst wenn auch `$REPO/secrets/secrets.yaml` umgeschlüsselt ist (`grep -c age1shm2 $REPO/secrets/secrets.yaml` zeigt 0), den alten Admin-Schlüssel (`age1shm2…`) überall löschen:
    - [X] Desktop, Framework, Convertible, Portable: `shred -u ~/.config/sops/age/keys.txt`. `~/.config/sops` ist persistiert, `shred` trifft über die Persistenz die echte Datei unter `/persistent/home/jf/.config/sops`. Prüfen: `ls /persistent/home/jf/.config/sops/age/` ist leer.
    - [X] Seit 06.11.2026 ist `~/.config/sops` nicht mehr persistiert. Nach dem Rebuild und Neustart auf jedem Client den Rest in der Persistenz löschen: `ls -la /persistent/home/jf/.config/sops/age/` muss leer sein, dann `sudo rm -r /persistent/home/jf/.config/sops`.
    - [X] Auf jedem Client `/secrets/keys.txt` prüfen: `sudo age-keygen -y /secrets/keys.txt`. Zeigt es `age1shm2…`, liegt dort der alte Admin-Schlüssel als Host-Schlüssel. Er wird in 7.1 durch einen eigenen Schlüssel ersetzt (`age-keygen -o` überschreibt die Datei).
    - [X] KeePassXC: einen alten Eintrag mit diesem Schlüssel löschen. Laut alter README wurde er per `ssh-to-age` aus dem SSH-Schlüssel `~/.ssh/private` abgeleitet. Gibt es diesen SSH-Schlüssel noch (KeePassXC, Dateien, Sicherungen), ergibt er wieder den alten Admin-Schlüssel: löschen bzw. in 7B ersetzen.
    - [X] Nicht löschbar sind alte Kopien in Git-Historie, Snapshots und Backups (z. B. `/persistent` in restic). Dort entschlüsselt der alte Schlüssel nur die alten Versionen der Dateien. Deshalb in 7B alle Werte rotieren, dann ist er wertlos.
  - [X] Offline-Kopie des neuen Admin-Schlüssels (Ausdruck oder USB-Stick), siehe [`docs/disaster-recovery.md`](docs/disaster-recovery.md).
- [X] 7.1 Pro Host einen eigenen Schlüssel direkt auf dem Host erzeugen: `sudo nix shell nixpkgs#age -c age-keygen -o /secrets/keys.txt && sudo chmod 400 /secrets/keys.txt`, Public Key mit `sudo age-keygen -y /secrets/keys.txt`. Sicherung in KeePassXC als Eintrag „age <host>“, ohne URL: Nur der Admin-Eintrag darf `https://sops-admin.invalid` haben, sonst liefert KeePassXC sops den falschen Schlüssel. Für Server1 einen neuen (der alte konnte die gemeinsame Datei mit den Client-Secrets lesen). 7.1 bis 7.4 pro Host in einem Zug: Bis zum Rebuild aus 7.4 passt der neue Schlüssel nicht zur alten Datei, ein Neustart dazwischen ließe die Dienste ohne Secrets starten.
- [X] 7.2 Die Public Keys in `$PRIV/secrets/.sops.yaml` eintragen (`sops_<host>`) und in den Regeln einkommentieren. Die Regel für `clients.yaml` steht schon da.
- [X] 7.3 Die gemeinsame Datei aufteilen, ohne Klartext auf der Platte:
  ```
  cd $PRIV/secrets
  cp $REPO/secrets/secrets.yaml clients.yaml
  cp $REPO/secrets/secrets.yaml nixos-server1.yaml
  for k in changeme changeme_env cloudflare forgejo glance linkwarden monero nginx sabnzbd searxng smb-share user webdav-share zfs; do sops unset clients.yaml "[\"$k\"]"; done
  sops unset clients.yaml '["syncthing"]["nixos-server1"]'
  for k in alphavantage changeme changeme_env cloudflare nas-smb user weather-location wifi; do sops unset nixos-server1.yaml "[\"$k\"]"; done
  for h in nixos-desktop nixos-framework nixos-convertible nixos-portable; do sops unset nixos-server1.yaml "[\"syncthing\"][\"$h\"]"; done
  sops updatekeys -y clients.yaml && sops updatekeys -y nixos-server1.yaml
  ```
  Fehlermeldungen von `unset` für Schlüssel, die es nicht gibt, sind egal. Prüfen: `sops -d clients.yaml | grep -E '^[a-z]'` zeigt nur `alphavantage`, `mullvad`, `nas-smb`, `radicale`, `syncthing` (nur Clients), `weather-location`, `wifi`. Dann im privaten Repo committen, im öffentlichen `nix flake update private`.
- [X] 7.4 (06.11.2026 erledigt, sops-Prüfung beim Bauen für alle vier Hosts bestanden) Hosts umstellen: in `hosts/NixOS-Desktop/configuration.nix`, `hosts/NixOS-Framework/configuration.nix` und `hosts/NixOS-Convertible/configuration.nix` die Zeile `nixos.system.sops.file = "clients";` ergänzen, in `hosts/NixOS-Server1/configuration.nix` `nixos.system.sops.file = "nixos-server1";` (oder mir Bescheid geben). Bauen, deployen, `systemctl --failed` prüfen.
- [X] 7.5 Wenn alle Hosts umgestellt sind: `git rm -r secrets/` im öffentlichen Repo (der Rückfallwert in `nixosModules/system/sops.nix` ist seit 06.11.2026 entfernt, ein Host ohne `nixos.system.sops.file` bricht beim Bauen mit einer Meldung ab). Die Werte stehen weiter verschlüsselt in der öffentlichen Git-Historie, deshalb alles aus 7B rotieren.

Vor der Erneuerung aller Werte (7B) erledigt:

- [X] 7.5a Den SSH-Schlüssel `~/.ssh/private` suchen (KeePassXC, alte Dateien, Sicherungen) und löschen. Aus ihm wurde der alte Admin-Schlüssel abgeleitet (`ssh-to-age`), er würde die Historie wieder lesbar machen.
- [X] 7.5b Die alten Passwort-Hashes stehen unverschlüsselt in der öffentlichen Historie und lassen sich offline knacken. Wurde eines der alten Passwörter auch anderswo verwendet (Konten, Router, Mail), dort jetzt ändern.
- [X] 7.5c Neue age-Schlüssel auf Server1 und den Clients in `/secrets/keys.txt`, Sicherung in KeePassXC (06.11.2026). Den alten Server1-Schlüssel (`age1s538…`) gibt es damit nicht mehr.

7B – Alle Secrets neu erzeugen (Stand 06.11.2026)

Warum alle: Die Werte in `nixos-serverpublic.yaml` (angelegt am 18.10.2026), `nixos-servergaming.yaml`, `nixos-portable.yaml` und die früheren Platzhalter wurden in Sitzungen mit Claude erzeugt oder dort angezeigt. Sie gelten damit als bekannt. Alle übrigen Werte standen verschlüsselt in der öffentlichen Git-Historie (`secrets/secrets.yaml`). Deshalb wird jeder Wert neu erzeugt. Ausgenommen sind die Login-Passwörter, das WLAN-Passwort und alles, was du danach am Handy oder an anderen Geräten neu eintragen musst (SMB, Radicale, Postfächer, Mailkonten bei Anbietern): Phase 20. restic kommt in Phase 9 (Tabelle 9A), SSH-Schlüssel und Syncthing ganz zuletzt (Phase 22). Die Festplattenpasswörter werden nicht rotiert, sie bekommen nur einen ordentlichen Eintrag in KeePassXC (20.2).

Grundregeln:

- Werte nie an Claude geben, nicht in Chats, Notizen, Repo-Dateien oder die Shell-History. Erzeugen in KeePassXC oder per Befehl, eintragen direkt im Editor von `sops <datei>` (im privaten Repo, KeePassXC entsperrt).
- Keiner dieser Werte wird je getippt: KeePassXC füllt aus oder kopiert. Länge und Komplexität sind für dich deshalb egal, es zählen nur die technischen Grenzen der Dienste (Tabelle unten).
- Reihenfolge pro Wert: (1) in KeePassXC erzeugen und speichern, (2) im Dienst ändern, falls der Dienst den Wert selbst kennt (Datenbank, Router, Anbieter), (3) in sops eintragen, (4) im privaten Repo committen, im öffentlichen `nix flake update private`, deployen, (5) prüfen, (6) den alten Wert im Verlauf des KeePassXC-Eintrags erst löschen, wenn alles läuft.
- Was mehrere Hosts brauchen (`mullvad`, `radicale/htpasswd`, SMB), in allen betroffenen Dateien gleichzeitig ändern und alle betroffenen Hosts im selben Zug deployen.
- Keine Ablaufdaten in KeePassXC, die Werte werden nicht regelmäßig rotiert, nur bei Verdacht.

Erzeugen und technische Grenzen:

| Art | Erzeugen | Grund |
|---|---|---|
| Standard (alles ohne eigene Zeile) | KeePassXC → Passwortgenerator, Reiter „Passwort“, 128 Zeichen, nur A-Z, a-z, 0-9 | Sonderzeichen brechen Env-Dateien (`"` `'` `\` `$` `#` Leerzeichen), URLs (`@ : / ? # %`), SQL (`'`) und die YAML-Vorlagen von Synapse (`"`). Ohne sie ist der Wert überall gültig, 128 Zeichen sind über 760 Bit. Gilt für PostgreSQL, restic, Radicale (Klartext), WebDAV, Stalwart, code-server, Grafana und Pi-hole. |
| Interne Zufallsschlüssel | `openssl rand -hex 64` (128 Hex-Zeichen) | Synapse, coturn, SearXNG, Linkwarden und die Bridges lesen beliebig lange Werte |
| SMB (`smb-share/*`, `nas-smb/user`) | KeePassXC, 127 Zeichen, nur A-Z, a-z, 0-9 | Windows nimmt bei SMB höchstens 127 Zeichen an, Samba und Linux mehr. 127 hält auch Windows-Geräte offen. |
| WLAN (WPA3) | KeePassXC, 63 Zeichen, nur A-Z, a-z, 0-9 | WPA erlaubt 8 bis 63 Zeichen, die FRITZ!Box höchstens 63. Neue Geräte per QR-Code aus der FRITZ!Box verbinden, nicht abtippen. |
| bcrypt (`htpasswd -B`): `resticserver/htpasswd` mit dem Passwort aus `restic/home-env`; Syncthing-GUI (in sops im Klartext, den Hash bildet NixOS) | KeePassXC, 72 Zeichen, nur A-Z, a-z, 0-9 | bcrypt wertet nur die ersten 72 Bytes aus, alles danach wäre wirkungslos |
| SABnzbd `api_key`/`nzb_key` | `openssl rand -hex 16` (32 Zeichen) | das feste Format von SABnzbd |
| Forgejo | `nix shell nixpkgs#forgejo -c forgejo generate secret SECRET_KEY` bzw. `INTERNAL_TOKEN` | feste Länge, Forgejo prüft das Format von `INTERNAL_TOKEN` |
| Konten in Web-Oberflächen (7E) | 128 Zeichen; lehnt die Oberfläche das ab, in KeePassXC die Länge auf das erlaubte Maximum senken | Manche Dienste begrenzen die Länge, oft ohne Hinweis in der Doku |
| Hash für Stalwart-Admin | `nix shell nixpkgs#mkpasswd -c mkpasswd -m sha-512 -R 500000`, Passwort aus KeePassXC einfügen | im Server liegt nur der Hash |
| Hash für code-server | `read -rs pw; printf '%s' "$pw" \| nix shell nixpkgs#libargon2 -c argon2 "$(openssl rand -hex 16)" -id -e; unset pw` (Passwort aus KeePassXC einfügen, Enter) | code-server erwartet `HASHED_PASSWORD` als Argon2-Hash, `read -s` hält das Passwort aus der Shell-History |
| WireGuard | `nix shell nixpkgs#wireguard-tools -c sh -c 'wg genkey \| tee /dev/stderr \| wg pubkey'` (erste Zeile privat, zweite öffentlich) | fester Schlüsseltyp |
| Syncthing | `d=$(mktemp -d); nix shell nixpkgs#syncthing -c syncthing generate --home "$d"`, dann `$d/cert.pem`, `$d/key.pem`, die ausgegebene Device ID; danach `rm -r "$d"` | das Zertifikat bestimmt die Geräte-ID |
| Tokens externer Dienste | beim Anbieter, siehe Tabelle | Format vom Anbieter vorgegeben |

KeePassXC-Ablage: sieben Gruppen unter `NixOS`, jeder Wert steht in genau einem Eintrag, auch wenn er an mehreren Stellen gebraucht wird. Die vollständige Liste aller Einträge mit Gruppe steht in 7F.

Welche Gruppe? Die erste passende Regel gilt:

1. `NixOS/Providers`: Konten bei externen Anbietern und alles, was ein Anbieter ausstellt (Cloudflare-Tokens, Mullvad, Alpha Vantage, Telegram-App, Usenet, Proton, …).
2. `NixOS/Devices`: was du an einem Gerät eintippst oder was eine Festplatte öffnet: Login, LUKS, ZFS-Schlüssel, WLAN.
3. `NixOS/Keys`: Schlüssel, die einen Rechner ausweisen: age, SSH, WireGuard, Syncthing.
4. `NixOS/Portable`: die Werte des Server-Modus von Portable (7D-5). Sie gelten nur dort, deshalb eine eigene Gruppe, auch wenn die Titel wie bei Server1 heißen.
5. `NixOS/Server1`, `NixOS/ServerPublic`, `NixOS/ServerGaming`: alles andere, und zwar beim Server, dessen Dienst den Wert prüft oder ausstellt. Das gilt auch, wenn Clients oder andere Server denselben Wert in ihrer sops-Datei haben: SMB, Radicale und WebDAV liegen bei Server1, ebenso der restic-Zugang der VPS (der rest-server auf Server1 prüft ihn). Die ntfy-Tokens und das Postfach `alerts@` liegen bei ServerPublic.

Pro Eintrag:

- In KeePassXC alles auf Englisch: Gruppen, Titel, Notizen und Attribute genau wie in 7F. Passwortfeld = der Wert, bei Env-Dateien nur der Wert, die ganze Zeile (`SEARXNG_SECRET=…`) ins Notizfeld.
- Notizfeld: der Text aus 7F, also alle Fundstellen (Datei → sops-Pfad, Dienste, Geräte). Ändert sich der Wert, sind genau das die Stellen, die mitgeändert werden.
- Weboberfläche: URL eintragen, siehe 7F. Ist ein Wert zugleich sops-Wert und Login einer Oberfläche (Stalwart-Admin, ntfy `jf`, Postfach `alerts@`), gibt es nur diesen einen Eintrag, mit URL.
- Bei Hashes (Stalwart, code-server, ntfy, bcrypt-Zeilen, Login) steht im Eintrag das Klartext-Passwort, der Hash nur in sops.
- Schlüsseldateien (Syncthing `cert.pem`/`key.pem`, SSH privat) als Anhang (Erweitert → Anhänge), öffentliche Teile (Device ID, Public Keys) ins Notizfeld. Zusatzwerte desselben Kontos (LUKS-Recovery-Key, 2FA-Wiederherstellungscodes) im selben Eintrag als Anhang oder unter Erweitert → Zusätzliche Attribute, nie als eigener Eintrag.
- Nicht ablegen: SSH-Hostkeys und den initrd-Hostkey (werden bei Bedarf neu erzeugt), `weather-location`, `ENV_LOCATION` und die Monero-Wallet-Adresse in `monero/p2pool-env` (keine Geheimnisse).
- Die schon angelegten Einträge aus 7A (`sops age admin`, `age <host>`) nur nach `NixOS/Keys` verschieben. Die Gruppe ändert nichts an der Suche per URL, sops findet den Admin-Schlüssel weiterhin.
- Die Datenbank selbst: Backup wie in [`docs/disaster-recovery.md`](docs/disaster-recovery.md), damit die Ablage nicht an einem Rechner hängt.

7C – Reihenfolge:

- [X] 7.6 Vor der Installation der VPS (Phase 8): `nixos-serverpublic.yaml` und `nixos-servergaming.yaml` komplett neu nach 7D-3 und 7D-4. Dort läuft noch nichts, es gibt kein Risiko für Daten.
- [X] 7.7 Externe Tokens zuerst: Cloudflare (pro Server ein eigenes Token), Alpha Vantage, Usenet-Zugang. Mit ihnen ließe sich außerhalb deines Netzes etwas anrichten.
- [X] 7.8 Server1 nach 7D-2, Dienst für Dienst. Die Zeilen mit „Achtung“ genau in der angegebenen Reihenfolge.
- [X] 7.8a **Pflicht vor dem nächsten Deploy von Server1:** Seit 07.11.2026 liest die Konfiguration das Pi-hole-Passwort, den Hash des App-Passworts und das Syncthing-GUI-Passwort nur noch aus sops (die alten Hashes sind aus dem Repo entfernt). Fehlen die Einträge, bricht schon der Build ab (`the key 'pihole' cannot be found`), am laufenden Server ändert sich bis dahin nichts. Alles in einem Zug:
  1. KeePassXC: im Eintrag „Pi-hole“ (`NixOS/Server1`) ein neues Passwort erzeugen (Reiter „Passwort“, 128 Zeichen, nur A-Z, a-z, 0-9), das alte bleibt im Verlauf des Eintrags. Im Eintrag „Syncthing GUI Server1“ (`NixOS/Server1`, Benutzername `admin`, URL `https://syncthing.<homeDomain>`) ein neues Passwort erzeugen, 72 Zeichen, nur A-Z, a-z, 0-9 (bcrypt nutzt nur 72 Bytes). Speichern.
  2. Neues App-Passwort samt Hash vom laufenden Pi-hole holen, auf dem Desktop. Der Befehl fragt nach dem **bisherigen** Pi-hole-Passwort (aus dem Verlauf des Eintrags). Pi-hole erzeugt dabei nur ein Paar und speichert nichts, das alte App-Passwort gilt bis zum Deploy weiter:

     ```
     nix shell nixpkgs#curl nixpkgs#jq -c bash -c 'read -rsp "Bisheriges Pi-hole-Passwort: " pw; echo; u=https://pihole.<homeDomain>/api; sid=$(jq -nc --arg p "$pw" "{password:\$p}" | curl -sf "$u/auth" -d @- | jq -r .session.sid); curl -sf -H "X-FTL-SID: $sid" "$u/auth/app" | jq .app; curl -sf -o /dev/null -X DELETE -H "X-FTL-SID: $sid" "$u/auth"'
     ```

     Die Ausgabe zeigt `password` und `hash` (beginnt mit `$BALLOON-SHA256$`). `password` in KeePassXC in den Eintrag „Pi-hole app password“ (`NixOS/Server1`, ohne URL) ins Passwortfeld, `hash` ins Notizfeld, speichern. Bleibt die Ausgabe leer oder steht dort `null`, war das bisherige Passwort falsch.
  3. `cd ~/Documents/nixos-private/secrets && sops nixos-server1.yaml` und ergänzen. Einrückung 4 Leerzeichen wie im Rest der Datei, keine Anführungszeichen um die Werte. `syncthing:` und `nixos-server1:` gibt es schon (mit `cert` und `key`), dort nur `gui-password` dazusetzen:

     ```yaml
     pihole:
         env: |
             FTLCONF_webserver_api_password=<neues Passwort aus „Pi-hole“>
             FTLCONF_webserver_api_app_pwhash=<hash aus Schritt 2>
     syncthing:
         nixos-server1:
             gui-password: <neues Passwort aus „Syncthing GUI Server1“>
     ```

     In derselben Datei unter `glance` die Zeile `ENV_PIHOLE_PASSWORD=<password aus Schritt 2>` ersetzen. Ist 10.5 schon aktiv, auch `monitoring/pihole-env` auf `PIHOLE_PASSWORD=<password aus Schritt 2>`. Speichern.
  4. Im privaten Repo committen (`cd ~/Documents/nixos-private && git add -A && git commit -m "pihole and syncthing gui from sops"`), im öffentlichen `nix flake update private`, dann Server1 deployen: `nixos-rebuild switch --flake .#NixOS-Server1 --build-host admin@NixOS-Server1 --target-host admin@NixOS-Server1 --sudo --ask-sudo-password`.
  5. Prüfen:
     - Auf Server1 `sudo grep FTLCONF /var/log/pihole/FTL.log | tail -1` zeigt `2 FTLCONF environment variables found (2 used, 0 invalid, 0 ignored)`.
     - `https://pihole.<homeDomain>/admin`: Anmeldung mit dem neuen Passwort geht, mit dem alten nicht mehr.
     - Glance: Das Pi-hole-Widget zeigt Zahlen.
     - `https://syncthing.<homeDomain>`: Anmeldung mit `admin` und dem neuen Passwort geht. Auf Server1 `systemctl status syncthing-init` ohne Fehler.
  6. Ab jetzt lassen sich beide Pi-hole-Passwörter nur noch über sops ändern (Schritte 1 bis 5). `sudo pihole setpassword` und das Feld in der Oberfläche greifen nicht mehr, Werte aus der Umgebung sind in Pi-hole schreibgeschützt.
- [X] 7.9 Clients und Portable nach 7D-1 (bleibt nur Alpha Vantage, Mullvad lässt sich nicht tauschen).
- [X] 7.9a Portable-Server-Modus nach 7D-5, spätestens vor 12.3.
- [x] 7.10 Werte außerhalb von sops nach 7E.
- [X] 7.11 Aufräumen: unbenutzte Altlasten aus allen Dateien löschen (`changeme`, `changeme_env`, `cloudflare/api_key`, `nginx/acme/email`, `monero/*`, `user/nixos-vmdesktop/admin`, `user/nixos-vmserver/admin`, `nextcloud/admin`, `codeserver/password`, `restic/storagebox-ssh-key`), committen, `nix flake update private`, deployen, dann die alten Werte im Verlauf der KeePassXC-Einträge löschen.

7D-1 – `clients.yaml` (Desktop, Framework, Convertible) und `nixos-portable.yaml` (Portable, gleiche Werte):

| sops | KeePassXC (Gruppe → Titel) | KeePassXC-URL (Autofill) | Format | Erzeugen | Ändern ohne Ausfall | Auch anpassen |
|---|---|---|---|---|---|---|
| `mullvad` | `NixOS/Providers` → „Mullvad“ | `https://mullvad.net/account` | Kontonummer (16 Ziffern) | Nicht erzeugbar: Mullvad tauscht keine Kontonummern. Nur bei Verdacht ein neues Konto kaufen und alle Geräte neu anmelden. | – | `clients.yaml`, `nixos-portable.yaml` und `nixos-server1.yaml`, jeweils → `mullvad` |
| `alphavantage/api_key` | `NixOS/Providers` → „Alpha Vantage“ | `https://www.alphavantage.co` | Schlüssel (nur der Wert) | Auf alphavantage.co → „Get your free API key“ einen neuen anfordern. Der Key wird dort erzeugt (16 Zeichen, Großbuchstaben und Ziffern), nichts selbst wählen. | jederzeit | `clients.yaml` und `nixos-portable.yaml`, jeweils → `alphavantage/api_key` |
| `weather-location` | – (kein Geheimnis) | – | JSON | kein Geheimnis, bleibt | – | – |

7D-2 – `nixos-server1.yaml` (Server1):

| sops | KeePassXC (Gruppe → Titel) | KeePassXC-URL (Autofill) | Format | Erzeugen | Ändern ohne Ausfall | Auch anpassen |
|---|---|---|---|---|---|---|
| `zfs/pool01` | `NixOS/Devices` → „ZFS pool01“ | keine | ZFS-Schlüssel der Datasets und zugleich LUKS-Schlüssel des Cache-Laufwerks `zfs-cache` (`/dev/nvme0n1p1`) | bleibt; nur bei Verdacht nach 7.12 (dort 64 Hex-Zeichen, `openssl rand -hex 32`, weil das ZFS-Format `hex` genau diese Länge verlangt) | **Achtung, bleibt.** Der Wert war nur mit Schlüsseln verschlüsselt, die es nicht mehr gibt, und ein Fehler sperrt alle Daten aus. | – |
| `forgejo/secret` | `NixOS/Server1` → „Forgejo SECRET_KEY“ | keine | `SECRET_KEY`, nur der Wert | `nix shell nixpkgs#forgejo -c forgejo generate secret SECRET_KEY` (Länge legt Forgejo fest) | **Achtung:** Forgejo verschlüsselt damit Geheimnisse in seiner Datenbank: 2FA (TOTP), OAuth2-Client-Secrets, Zugangsdaten von Spiegeln. Vorher 2FA in Forgejo deaktivieren und Spiegel-Zugangsdaten bereithalten, nach dem Deploy 2FA neu einrichten und Zugangsdaten neu eintragen. Repos, Issues und Konten bleiben. | – |
| `forgejo/token` | `NixOS/Server1` → „Forgejo INTERNAL_TOKEN“ | keine | `INTERNAL_TOKEN`, nur der Wert | `nix shell nixpkgs#forgejo -c forgejo generate secret INTERNAL_TOKEN` (Format legt Forgejo fest) | jederzeit, nur Neustart | – |
| `linkwarden/postgres` | `NixOS/Server1` → „Linkwarden PostgreSQL“ | keine | Passwort, nur der Wert | KeePassXC → Reiter „Passwort“, 128 Zeichen, nur A-Z, a-z, 0-9 (keine `'`, die brechen SQL, und keine `@ : / ?`, die brechen die Verbindungs-URL) | **Achtung Datenbank:** Das Passwort steht auch in PostgreSQL. (1) Benutzer ist `linkwarden` (geprüft mit `\du` am 07.11.2026), (2) dort ändern: `sudo -u postgres psql -c '\password linkwarden'` (fragt zweimal, nichts landet in der Shell-History), (3) sofort sops und deployen. Dazwischen erreicht Linkwarden die Datenbank nicht, die Daten bleiben. | – |
| `linkwarden/secret` | `NixOS/Server1` → „Linkwarden NEXTAUTH_SECRET“ | keine | `NEXTAUTH_SECRET`, nur der Wert | `openssl rand -hex 64` (128 Hex-Zeichen) | jederzeit, alle Sitzungen werden abgemeldet | – |
| `searxng/secret` | `NixOS/Server1` → „SearXNG secret“ | keine | eine Zeile `SEARXNG_SECRET=<wert>` | `openssl rand -hex 64` (128 Hex-Zeichen) | jederzeit | – |
| `webdav-share/user-jf` | `NixOS/Server1` → „WebDAV jf“ | `https://dav.<homeDomain>`, unter Zusätzliche URLs `https://webdav.<homeDomain>` | eine Zeile `ENV_PASSWORD=<passwort>` | KeePassXC → Reiter „Passwort“, 128 Zeichen, nur A-Z, a-z, 0-9 | jederzeit | Clients `webdav-share/davfs`, sobald eingerichtet (27.4) |
| `sabnzbd` | `NixOS/Server1` → „SABnzbd api_key“, „SABnzbd nzb_key“; Usenet-Zugang: `NixOS/Providers` → „Usenet provider“ | „SABnzbd api_key“, „SABnzbd nzb_key“: keine; „Usenet provider“: Login-Seite des Anbieters | INI-Ausschnitt: `[misc]` mit `api_key = …`, `nzb_key = …`; `[servers]` mit dem Usenet-Zugang | `api_key` und `nzb_key`: je `openssl rand -hex 16` (32 Hex-Zeichen, das feste Format von SABnzbd), zwei verschiedene Werte. Usenet-Passwort: beim Anbieter ändern, so lang wie der Anbieter zulässt, nur A-Z, a-z, 0-9 | **Achtung:** Danach in Sonarr, Radarr, Lidarr, Readarr (Einstellungen → Download-Clients) den neuen `api_key` eintragen, sonst laden sie nichts mehr. Die Warteschlange bleibt. | *arr-Apps |
| `glance` | `NixOS/Server1` → „Pi-hole app password“, „Home Assistant token (Glance)“, „Jellyfin API key (Glance)“, „Sonarr API key“, „Radarr API key“; `NixOS/ServerPublic` → „Miniflux token (Glance)“; `ENV_LOCATION`: keiner | keine (Tokens, sonst bietet KeePassXC sie auf der Login-Seite des Dienstes mit an) | Env-Datei, eine Zeile pro Wert: `ENV_PIHOLE_PASSWORD`, `ENV_HA_TOKEN`, `ENV_JELLYFIN_TOKEN`, `ENV_SONARR_KEY`, `ENV_RADARR_KEY`, `ENV_MINIFLUX_TOKEN`, `ENV_LOCATION` | **`ENV_PIHOLE_PASSWORD` zusammen mit `pihole/env` in 7.8a, `ENV_MINIFLUX_TOKEN` erst in 13.12**, bis dahin die alten Zeilen stehen lassen. Alles wird im jeweiligen Dienst erzeugt, nichts selbst wählen: Home Assistant → Profil → Sicherheit → langlebiges Zugriffstoken; Jellyfin → Dashboard → API-Schlüssel → „+“; Sonarr und Radarr → Einstellungen → Allgemein → API-Schlüssel neu erzeugen. `ENV_LOCATION` ist kein Geheimnis. | Neu erzeugen, sops, deployen, danach das alte Token im Dienst löschen. Die Sonarr/Radarr-Keys nutzt nur Glance. | kein weiterer sops-Pfad; `ENV_PIHOLE_PASSWORD` ist das App-Passwort aus Pi-hole (7.8a) |
| `pihole/env` | `NixOS/Server1` → „Pi-hole“ (Weboberfläche), „Pi-hole app password“ (Passwort im Passwortfeld, Hash im Notizfeld) | „Pi-hole“: `https://pihole.<homeDomain>/admin`; „Pi-hole app password“: keine | zwei Zeilen ohne Anführungszeichen: `FTLCONF_webserver_api_password=<passwort>` (Klartext, Pi-hole bildet den Hash selbst) und `FTLCONF_webserver_api_app_pwhash=<hash>` | Weboberfläche: KeePassXC → Reiter „Passwort“, 128 Zeichen, nur A-Z, a-z, 0-9. App-Passwort und Hash erzeugt Pi-hole, auf dem Desktop (fragt nach dem bisherigen Pi-hole-Passwort, speichert nichts): `nix shell nixpkgs#curl nixpkgs#jq -c bash -c 'read -rsp "Bisheriges Pi-hole-Passwort: " pw; echo; u=https://pihole.<homeDomain>/api; sid=$(jq -nc --arg p "$pw" "{password:\$p}" \| curl -sf "$u/auth" -d @- \| jq -r .session.sid); curl -sf -H "X-FTL-SID: $sid" "$u/auth/app" \| jq .app; curl -sf -o /dev/null -X DELETE -H "X-FTL-SID: $sid" "$u/auth"'` | **Achtung, Pflicht vor dem nächsten Server1-Deploy**, sonst bricht der Build ab. Ablauf mit allen Befehlen in 7.8a. Mit `glance` im selben Deploy, sonst zeigt das Widget nichts. | `nixos-server1.yaml` → `glance` (`ENV_PIHOLE_PASSWORD=<app-passwort>`), ab 10.5 `monitoring/pihole-env` (`PIHOLE_PASSWORD=<app-passwort>`) |
| `syncthing/nixos-server1/gui-password` | `NixOS/Server1` → „Syncthing GUI Server1“ (Benutzername `admin`) | `https://syncthing.<homeDomain>` | Passwort im Klartext, nur der Wert (NixOS bildet beim Start den bcrypt-Hash) | KeePassXC → Reiter „Passwort“, 72 Zeichen, nur A-Z, a-z, 0-9 (bcrypt nutzt nur 72 Bytes) | **Achtung, Pflicht vor dem nächsten Server1-Deploy**, sonst bricht der Build ab (7.8a). Nach dem Deploy gilt sofort das neue Passwort, offene Sitzungen müssen sich neu anmelden. | – |
| `mullvad` | `NixOS/Providers` → „Mullvad“ (ein Eintrag für alle Dateien) | `https://mullvad.net/account` | Kontonummer (16 Ziffern) | Nicht erzeugbar: Mullvad tauscht keine Kontonummern. Nur bei Verdacht ein neues Konto kaufen und alle Geräte neu anmelden. | – | `clients.yaml` und `nixos-portable.yaml`, jeweils → `mullvad` |
| `nginx/acme/api_key` | `NixOS/Providers` → „Cloudflare DNS token NixOS-Server1“ | keine (Token; `https://dash.cloudflare.com/profile/api-tokens` nur im Notizfeld) | eine Zeile `CLOUDFLARE_DNS_API_TOKEN=<token>` (lego liest auch `CF_DNS_API_TOKEN`, den bisherigen Namen beibehalten) | Wird von Cloudflare erzeugt: My Profile → API Tokens → Create Token → Vorlage „Edit zone DNS“, unter Zone Resources nur deine Zonen, ohne Ablaufdatum. Pro Server ein eigenes Token, damit sich eines einzeln sperren lässt. | Neues Token in sops, deployen, prüfen (`sudo systemctl start acme-order-renew-<name>.service` für eine Domain, `systemctl status` ohne Fehler), dann das alte Token bei Cloudflare löschen. Bestehende Zertifikate bleiben gültig. | nur `nixos-server1.yaml` → `nginx/acme/api_key`; ServerPublic und ServerGaming haben eigene Tokens |

7D-3 – `nixos-serverpublic.yaml` (ServerPublic, alles neu vor der Installation, außer restic: das kommt in Phase 9, Tabelle 9A):

| sops | KeePassXC (Gruppe → Titel) | KeePassXC-URL (Autofill) | Format | Erzeugen | Später beachten |
|---|---|---|---|---|---|
| `user/nixos-serverpublic/admin` | `NixOS/Devices` → „Login NixOS-ServerPublic“ (Phase 20) | keine | Login-Hash | bleibt bis Phase 20 (dein eigener Hash vom 02.11.2026) | – |
| `nginx/acme/api_key` | `NixOS/Providers` → „Cloudflare DNS token NixOS-ServerPublic“ | keine (Token) | eine Zeile `CLOUDFLARE_DNS_API_TOKEN=<token>` | Wird von Cloudflare erzeugt: My Profile → API Tokens → Create Token → Vorlage „Edit zone DNS“, unter Zone Resources nur deine Zonen, ohne Ablaufdatum. Pro Server ein eigenes Token, damit sich eines einzeln sperren lässt. | Neues Token in sops, deployen, prüfen (`sudo systemctl start acme-order-renew-<name>.service`, `systemctl status` ohne Fehler), dann das alte Token bei Cloudflare löschen. |
| `stalwart/admin` | `NixOS/ServerPublic` → „Stalwart admin“ (Klartext-Passwort, nicht der Hash) | `https://stalwart.<domain>` | sha512crypt-Hash (`$6$rounds=500000$…`) | Passwort: KeePassXC → Reiter „Passwort“, 128 Zeichen, nur A-Z, a-z, 0-9. Hash: `nix shell nixpkgs#mkpasswd -c mkpasswd -m sha-512 -R 500000`, Passwort einfügen, die Ausgabe in sops. | Die Postfächer haben eigene Passwörter in der Stalwart-Oberfläche (7E) |
| `matrix/registration_shared_secret` | `NixOS/ServerPublic` → „Matrix registration_shared_secret“ | keine | nur der Wert | `openssl rand -hex 64` (128 Hex-Zeichen) | jederzeit änderbar, nur für `register_new_matrix_user` |
| `matrix/macaroon_secret_key` | `NixOS/ServerPublic` → „Matrix macaroon_secret_key“ | keine | nur der Wert | `openssl rand -hex 64` (128 Hex-Zeichen), eigener Wert | Nach der Installation nicht mehr ändern, er macht bestehende Anmeldungen ungültig |
| `matrix/form_secret` | `NixOS/ServerPublic` → „Matrix form_secret“ | keine | nur der Wert | `openssl rand -hex 64` (128 Hex-Zeichen), eigener Wert | jederzeit änderbar |
| `coturn/secret` | `NixOS/ServerPublic` → „coturn secret“ | keine | nur der Wert | `openssl rand -hex 64` (128 Hex-Zeichen) | Synapse und coturn lesen denselben Wert, ein Deploy reicht |
| `mautrix-signal/env` | `NixOS/ServerPublic` → „mautrix-signal pickle key“, „mautrix-signal provisioning secret“ | keine | zwei Zeilen: `MAUTRIX_SIGNAL_PICKLE_KEY=<wert>`, `MAUTRIX_SIGNAL_PROVISIONING_SECRET=<wert>` | je `openssl rand -hex 64` (128 Hex-Zeichen), zwei verschiedene Werte | **Achtung:** Der Pickle-Key verschlüsselt die Krypto-Sitzungen der Bridge in ihrer Datenbank. Nach der Installation nicht mehr ändern, sonst muss die Bridge neu verbunden werden. |
| `mautrix-whatsapp/env` | `NixOS/ServerPublic` → „mautrix-whatsapp pickle key“, „mautrix-whatsapp provisioning secret“ | keine | zwei Zeilen: `MAUTRIX_WHATSAPP_PICKLE_KEY=<wert>`, `MAUTRIX_WHATSAPP_PROVISIONING_SECRET=<wert>` | je `openssl rand -hex 64` (128 Hex-Zeichen), zwei verschiedene Werte, andere als bei Signal | **Achtung:** Der Pickle-Key verschlüsselt die Krypto-Sitzungen der Bridge in ihrer Datenbank. Nach der Installation nicht mehr ändern, sonst muss die Bridge neu verbunden werden. |
| `mautrix-telegram/env` | `NixOS/Providers` → „Telegram app (mautrix)“ | `https://my.telegram.org` | zwei Zeilen: `MAUTRIX_TELEGRAM_TELEGRAM_API_ID=<zahl>`, `MAUTRIX_TELEGRAM_TELEGRAM_API_HASH=<32 Hex-Zeichen>` | Wird von Telegram vergeben: https://my.telegram.org/apps, App anlegen, `api_id` und `api_hash` übernehmen | Telegram vergibt keinen neuen `api_hash`. Bei Verdacht die App dort löschen und neu anlegen (eine App pro Konto). |
| `wireguard/nixos-serverpublic/private` | `NixOS/Keys` → „WireGuard NixOS-ServerPublic“ | keine | privater Schlüssel (44 Zeichen Base64) | `nix shell nixpkgs#wireguard-tools -c sh -c 'wg genkey \| tee /dev/stderr \| wg pubkey'`: erste Zeile privat (in sops und KeePassXC), zweite öffentlich | Public Key in `nixosModules/system/wireguard.nix`, alle Peers neu deployen |
| löschen | – (alte Einträge zu diesen Werten löschen) | – | `nextcloud/admin`, `codeserver/password`, `codeserver/env`, `murmur/env`, `restic/storagebox-ssh-key` | – | gehören nicht mehr hierher (Testdienste auf ServerGaming, Storage Box entfallen) |

7D-4 – `nixos-servergaming.yaml` (ServerGaming, alles neu vor der Installation, außer restic: Phase 9, Tabelle 9A):

| sops | KeePassXC (Gruppe → Titel) | KeePassXC-URL (Autofill) | Format | Erzeugen | Später beachten |
|---|---|---|---|---|---|
| `user/nixos-servergaming/admin` | `NixOS/Devices` → „Login NixOS-ServerGaming“ (Phase 20) | keine | Login-Hash | bleibt bis Phase 20 | – |
| `nginx/acme/api_key` | `NixOS/Providers` → „Cloudflare DNS token NixOS-ServerGaming“ | keine (Token) | eine Zeile `CLOUDFLARE_DNS_API_TOKEN=<token>` | Wird von Cloudflare erzeugt: My Profile → API Tokens → Create Token → Vorlage „Edit zone DNS“, unter Zone Resources nur deine Zonen, ohne Ablaufdatum. Pro Server ein eigenes Token, damit sich eines einzeln sperren lässt. | Neues Token in sops, deployen, prüfen (`sudo systemctl start acme-order-renew-<name>.service`, `systemctl status` ohne Fehler), dann das alte Token bei Cloudflare löschen. |
| `wireguard/nixos-servergaming/private` | `NixOS/Keys` → „WireGuard NixOS-ServerGaming“ | keine | privater Schlüssel (44 Zeichen Base64) | `nix shell nixpkgs#wireguard-tools -c sh -c 'wg genkey \| tee /dev/stderr \| wg pubkey'`: erste Zeile privat (in sops und KeePassXC), zweite öffentlich | Public Key in `nixosModules/system/wireguard.nix`, alle Peers neu deployen |
| `codeserver/env` | `NixOS/ServerGaming` → „code-server“ (Klartext-Passwort, nicht der Hash) | `https://code.<domain>` | eine Zeile `HASHED_PASSWORD='$argon2id$…'` (in einfachen Anführungszeichen wegen der `$`) | Passwort: KeePassXC → Reiter „Passwort“, 128 Zeichen, nur A-Z, a-z, 0-9. Hash: `read -rs pw; printf '%s' "$pw" \| nix shell nixpkgs#libargon2 -c argon2 "$(openssl rand -hex 16)" -id -e; unset pw`, Passwort einfügen, Enter. Nur der Hash in sops. | Testdienst (Phase 19) |

7D-5 – `nixos-portable.yaml` unter `server/` (nur der Boot-Eintrag `server` von Portable, alles neu vor der Installation in Phase 12):

Der Server-Modus liest seine Secrets unter `server/<name>` (`hosts/NixOS-Portable/server.nix`), nie die Werte von Server1. Jeder Wert ist ein eigener, auch wenn der Name gleich ist. Die Client-Werte der Datei (7D-1: `radicale/htpasswd`, `nas-smb/user`, `mullvad`, `wifi`, …) bleiben auf der obersten Ebene und gleich wie bei den Clients. Die alten Server-Werte auf der obersten Ebene (`forgejo/*`, `linkwarden/*`, `searxng/secret`, `smb-share/*`, `webdav-share/user-jf`, `codeserver/env`, `glance`) wurden mit Claude erzeugt: neu unter `server/` anlegen, oben löschen. Kommt ein Dienst mit Secret dazu, gehört er auch in `serverSecrets` in `hosts/NixOS-Portable/server.nix`.

| sops | KeePassXC (Gruppe → Titel) | KeePassXC-URL (Autofill) | Format | Erzeugen |
|---|---|---|---|---|
| `server/forgejo/secret` | `NixOS/Portable` → „Forgejo SECRET_KEY“ | keine | `SECRET_KEY`, nur der Wert | `nix shell nixpkgs#forgejo -c forgejo generate secret SECRET_KEY` (Länge legt Forgejo fest). **Achtung:** Forgejo verschlüsselt mit `SECRET_KEY` 2FA (TOTP), OAuth2-Client-Secrets und Zugangsdaten von Spiegeln in seiner Datenbank. Nach der ersten Einrichtung nur noch mit 2FA aus und Spiegel-Zugangsdaten bereit ändern. |
| `server/forgejo/token` | `NixOS/Portable` → „Forgejo INTERNAL_TOKEN“ | keine | `INTERNAL_TOKEN`, nur der Wert | `nix shell nixpkgs#forgejo -c forgejo generate secret INTERNAL_TOKEN` (Format legt Forgejo fest), jederzeit änderbar |
| `server/linkwarden/postgres` | `NixOS/Portable` → „Linkwarden PostgreSQL“ | keine | Passwort, nur der Wert | KeePassXC → Reiter „Passwort“, 128 Zeichen, nur A-Z, a-z, 0-9 (keine `'`, die brechen SQL, und keine `@ : / ?`, die brechen die Verbindungs-URL), eigener Wert. Vor der Installation frei wählbar. Danach zuerst in PostgreSQL ändern: `sudo -u postgres psql -c '\password linkwarden'` (fragt zweimal), dann sofort sops und `sudo nixos-rebuild switch --flake .#NixOS-Portable` |
| `server/linkwarden/secret` | `NixOS/Portable` → „Linkwarden NEXTAUTH_SECRET“ | keine | nur der Wert | `openssl rand -hex 64` |
| `server/searxng/secret` | `NixOS/Portable` → „SearXNG secret“ | keine | eine Zeile `SEARXNG_SECRET=<wert>` | `openssl rand -hex 64` |
| `server/smb-share/user-jf`, `server/smb-share/user-meli` | `NixOS/Portable` → „SMB jf“, „SMB meli“ | keine (`smb://NixOS-Portable` nur im Notizfeld) | Passwort, eine Zeile | KeePassXC → Reiter „Passwort“, 127 Zeichen, nur A-Z, a-z, 0-9, andere Werte als auf Server1 |
| `server/webdav-share/user-jf` | `NixOS/Portable` → „WebDAV jf“ | `https://dav.portable.internal`, unter Zusätzliche URLs `https://webdav.portable.internal` | eine Zeile `ENV_PASSWORD=<passwort>` | KeePassXC → Reiter „Passwort“, 128 Zeichen, nur A-Z, a-z, 0-9 |
| `server/radicale/htpasswd` | `NixOS/Portable` → „Radicale jf“ | `https://radicale.portable.internal` | eine Zeile `jf:<passwort>` | KeePassXC → Reiter „Passwort“, 128 Zeichen, nur A-Z, a-z, 0-9 (kein `:`), anderer Wert als `radicale/htpasswd` oben |
| `server/codeserver/env` | `NixOS/Portable` → „code-server“ (Klartext-Passwort) | `https://code.portable.internal` | eine Zeile `HASHED_PASSWORD='$argon2id$…'` (in einfachen Anführungszeichen wegen der `$`) | Passwort: KeePassXC → Reiter „Passwort“, 128 Zeichen, nur A-Z, a-z, 0-9. Hash: `read -rs pw; printf '%s' "$pw" \| nix shell nixpkgs#libargon2 -c argon2 "$(openssl rand -hex 16)" -id -e; unset pw`, Passwort einfügen, Enter. Nur der Hash in sops. Eigenes Passwort, nicht das von ServerGaming. |
| `server/glance` | – (kein Geheimnis) | – | eine Zeile `ENV_LOCATION=<ort>` | Ortsname für das Wetter-Widget, z. B. `ENV_LOCATION=Berlin, Germany`. Kein Geheimnis, Portable nutzt keine Glance-Tokens |

7E – Außerhalb von sops: Konten, die es schon gibt (SSH-Schlüssel aller Art: Phase 22). Unabhängig vom Deploy in 7G, die Reihenfolge ist egal.

| Was | KeePassXC (Gruppe → Titel) | KeePassXC-URL (Autofill) | Erzeugen (Art und Länge) | Ändern | Eintragen in |
|---|---|---|---|---|---|
| Grafana-Admin | `NixOS/Server1` → „Grafana“ (Benutzername `admin`) | `https://grafana.<homeDomain>` | KeePassXC → Reiter „Passwort“, 128 Zeichen, nur A-Z, a-z, 0-9; lehnt Grafana das ab, auf das Maximum kürzen | in Grafana unter Profil → Passwort ändern | nur KeePassXC |
| Dienst-Konten auf Server1 (Home Assistant, Jellyfin, Forgejo, Linkwarden, HomeBox, Sonarr, Radarr, Lidarr, Readarr, NZBHydra2, SABnzbd) | je Dienst ein Eintrag, Titel = Dienstname: `NixOS/Server1` → „Home Assistant“, „Jellyfin“, „Forgejo“, „Linkwarden“, „HomeBox“, „Sonarr“, „Radarr“, „Lidarr“, „Readarr“, „NZBHydra2“, „SABnzbd“ | je Eintrag: „Home Assistant“ `https://homeassistant.<homeDomain>`, „Jellyfin“ `https://jellyfin.<homeDomain>`, „Forgejo“ `https://forgejo.<homeDomain>`, „Linkwarden“ `https://linkwarden.<homeDomain>`, „HomeBox“ `https://homebox.<homeDomain>`, „Sonarr“ `https://sonarr.<homeDomain>`, „Radarr“ `https://radarr.<homeDomain>`, „Lidarr“ `https://lidarr.<homeDomain>`, „Readarr“ `https://readarr.<homeDomain>`, „NZBHydra2“ `https://nzbhydra.<homeDomain>`, „SABnzbd“ `https://sabnzbd.<homeDomain>` | KeePassXC → Reiter „Passwort“, 128 Zeichen, nur A-Z, a-z, 0-9; lehnt der Dienst das ab, in KeePassXC auf das erlaubte Maximum kürzen und das im Notizfeld vermerken | in der jeweiligen Oberfläche unter Profil/Benutzer. Apps am Handy (Home Assistant, Jellyfin) bleiben über ihre Tokens angemeldet, fragt eine trotzdem neu, das Konto erst in Phase 20 ändern. Forgejo: nur das Passwort hier, 2FA kommt nach dem Deploy in 7.16. Hat ein Dienst keine Anmeldung mit Passwort, die Zeile für ihn überspringen. | nur KeePassXC, Eintrag mit URL des Dienstes |
| Externe Konten (Registrar, Contabo, Cloudflare, GitHub, Codeberg) | `NixOS/Providers` → „Registrar“, „Contabo“, „Cloudflare“, „GitHub“, „Codeberg“ | „Registrar“ Login-Seite des Registrars, „Contabo“ `https://my.contabo.com`, „Cloudflare“ `https://dash.cloudflare.com`, „GitHub“ `https://github.com`, „Codeberg“ `https://codeberg.org` | KeePassXC → Reiter „Passwort“, so lang wie der Anbieter zulässt (128 versuchen, sonst kürzen), Sonderzeichen nur, wenn der Anbieter sie verlangt | beim Anbieter; dabei 2FA prüfen und Wiederherstellungscodes sichern | `NixOS/Providers` in KeePassXC, Wiederherstellungscodes als Anhang |

Nicht in 7E:

- ServerPublic (Stalwart-Postfächer, Matrix, Miniflux, CryptPad) und Nextcloud auf ServerGaming: Die Konten gibt es noch nicht. Sie werden bei der Einrichtung gleich mit dem endgültigen Passwort angelegt (8.8, 10.1, 19.4) und danach nicht mehr rotiert.
- Mullvad (nur Kontonummer) und Telegram (Anmeldung per Code): kein Passwort.
- Proton, DLRG, 1&1: in 20.4, weil dabei Thunderbird und das Handy mitgeändert werden.
- Radicale auf bcrypt: kein Wert zum Ändern, sondern ein optionaler Umbau, jetzt 14.13.

7F – Alle KeePassXC-Einträge mit Gruppe, URL für das automatische Ausfüllen und allen Stellen, an denen der Wert steht

Eine Zeile mit mehreren Titeln heißt: je Titel ein eigener Eintrag mit eigenem Wert. Die Spalte „Notizfeld“ so übernehmen. URLs mit den echten Domains aus `$PRIV/site.nix` eintragen (`<homeDomain>`, `<domain>`, `<domain>` sind hier nur Platzhalter, das öffentliche Repo enthält keine Domains). KeePassXC füllt im Browser nur aus, wenn Schema und Host passen (`MatchUrlScheme` ist an), also immer mit `https://`. Eine zweite Adresse desselben Dienstes unter Browser-Integration → Zusätzliche URLs. Einträge ohne Weboberfläche bekommen keine URL. Die URL `https://sops-admin.invalid` hat nur „sops age admin“ (siehe 7A).

| Titel | Gruppe | Benutzername | URL (Autofill) | Notizfeld |
|---|---|---|---|---|
| Login NixOS-Desktop, Login NixOS-Framework, Login NixOS-Convertible, Login NixOS-Portable | `NixOS/Devices` | `jf` | – | Plaintext here, sha512crypt hash in `clients.yaml` → `user/nixos-<host>/jf` or `nixos-portable.yaml` → `user/nixos-portable/jf` (since 07.11.2026, `passwordFromSops`). |
| Login NixOS-Server1, Login NixOS-ServerPublic, Login NixOS-ServerGaming | `NixOS/Devices` | `admin` | Server1 only: `https://cockpit.<homeDomain>` | Plaintext here, sha512crypt hash in `nixos-<host>.yaml` → `user/nixos-<host>/admin`. Server1: also the Cockpit login. |
| LUKS NixOS-Desktop, LUKS NixOS-Framework, LUKS NixOS-Convertible, LUKS NixOS-Portable, LUKS NixOS-Server1, LUKS NixOS-ServerPublic, LUKS NixOS-ServerGaming | `NixOS/Devices` | – | – | Only on the disk. Partition and unlock method in the notes, recovery key in attribute `recovery key` (protected), LUKS header backup attached (9.5). |
| ZFS pool01 | `NixOS/Devices` | – | – | `nixos-server1.yaml` → `zfs/pool01`; on Server1 `/secrets/zfs-cache.key` (LUKS key of the cache drive). Without it the pool data is lost. |
| WiFi HOME | `NixOS/Devices` | SSID | – | `clients.yaml` and `nixos-portable.yaml` → `wifi` (lines `ENV_HOME_SSID=`, `ENV_HOME_PSK=`); FRITZ!Box. |
| sops age admin | `NixOS/Keys` | – | `https://sops-admin.invalid` | Only here. Public key (`age1…`) in `$PRIV/secrets/.sops.yaml`. |
| age NixOS-Desktop, age NixOS-Framework, age NixOS-Convertible, age NixOS-Portable, age NixOS-Server1, age NixOS-ServerPublic, age NixOS-ServerGaming | `NixOS/Keys` | – | – | `/secrets/keys.txt` on the host. Public key in `$PRIV/secrets/.sops.yaml`. |
| SSH jf@NixOS-Desktop, SSH jf@NixOS-Framework, SSH jf@NixOS-Convertible, SSH jf@NixOS-Portable | `NixOS/Keys` | `jf` | – | Desktop, Framework, Convertible: until phase 22 still named „SSH id_ed25519 <Host>“ (5.1b). Portable: new key since 07.11.2026 (12.2b). Private key attached, passphrase in the password field (SSH agent). Public key in `nixosModules/system/ssh.nix` (`authorizedKeys`) and `hosts/NixOS-Server1/machine.nix` (`initrdssh.authorizedKeys`). |
| WireGuard NixOS-Desktop, WireGuard NixOS-Framework, WireGuard NixOS-Convertible, WireGuard NixOS-Server1, WireGuard NixOS-ServerPublic, WireGuard NixOS-ServerGaming, WireGuard GrapheneOS | `NixOS/Keys` | – | – | Private key in the password field: clients `clients.yaml`, servers `nixos-<host>.yaml`, each → `wireguard/nixos-<host>/private`; GrapheneOS only in the app (23.1). Public key in the notes and in `nixosModules/system/wireguard.nix` (ServerPublic since 07.11.2026, ServerGaming in 8.18, the others in 9.1, GrapheneOS in 23.1). |
| Syncthing NixOS-Desktop | `NixOS/Keys` | – | – | Device ID: PVZV2NU-LFXP33P-6I4XSXQ-M3TZWJN-HJOB2UC-2GLQSIE-GGF2TZ4-N22MAQN. Certificate: `clients.yaml` → `syncthing/nixos-desktop/cert` and `/key`, `cert.pem` and `key.pem` attached from phase 22.5 on. Device ID also in `nixosModules/userEnvironment/syncthing.nix`, `hosts/NixOS-Server1/syncthing.nix` and on the phone. |
| Syncthing NixOS-Framework | `NixOS/Keys` | – | – | Device ID: FSX7XGK-OPZCHEB-GGK5B2Z-S6KINWL-WWTSUFA-WBIZFQW-I7HZF6L-IKH2NAW. Certificate: `clients.yaml` → `syncthing/nixos-framework/cert` and `/key`, `cert.pem` and `key.pem` attached from phase 22.5 on. Device ID also in `nixosModules/userEnvironment/syncthing.nix`, `hosts/NixOS-Server1/syncthing.nix` and on the phone. |
| Syncthing NixOS-Convertible | `NixOS/Keys` | – | – | Device ID: MUOQSA5-7L5PSY4-DV3IYPW-VPCRMW6-RWOTIBN-DU27J42-AML2NCX-JGEMBQC. Certificate: `clients.yaml` → `syncthing/nixos-convertible/cert` and `/key`, `cert.pem` and `key.pem` attached from phase 22.5 on. Device ID also in `nixosModules/userEnvironment/syncthing.nix`, `hosts/NixOS-Server1/syncthing.nix` and on the phone. |
| Syncthing NixOS-Server1 | `NixOS/Keys` | – | – | Device ID: 7NQB6WA-LNGXLBN-4VCFKIX-Z64IF5D-RZSGTIT-7DP6I46-LSKOXYH-AVOV2QQ. Certificate: `nixos-server1.yaml` → `syncthing/nixos-server1/cert` and `/key`, `cert.pem` and `key.pem` attached from phase 22.5 on. Device ID also in `nixosModules/userEnvironment/syncthing.nix`, `hosts/NixOS-Server1/syncthing.nix` and on the phone. |
| Syncthing NixOS-Portable | `NixOS/Keys` | – | – | Device ID: from the command in 7F-S. Certificate: `nixos-portable.yaml` → `syncthing/nixos-portable/cert` and `/key`, `cert.pem` and `key.pem` attached from phase 22.5 on. Joins the device lists of the other hosts in 12.7, after the installation of Portable. |
| SMB jf | `NixOS/Server1` | `jf` | – | `nixos-server1.yaml` → `smb-share/user-jf`; `clients.yaml` and `nixos-portable.yaml` → `nas-smb/user` (line `password=`); phone file manager and Windows devices (23.3). Share: `smb://NixOS-Server1`. |
| SMB meli | `NixOS/Server1` | `meli` | – | `nixos-server1.yaml` → `smb-share/user-meli`; Meli's computer and her Bitwarden (23.4). |
| Radicale jf | `NixOS/Server1` | `jf` | `https://radicale.<homeDomain>` | `nixos-server1.yaml`, `clients.yaml` and `nixos-portable.yaml`, each → `radicale/htpasswd` (line `jf:<password>`); Thunderbird, DAVx5 on the phone (23.5). |
| WebDAV jf | `NixOS/Server1` | `jf` | `https://dav.<homeDomain>`, additional URL `https://webdav.<homeDomain>` | `nixos-server1.yaml` → `webdav-share/user-jf` (line `ENV_PASSWORD=`); later `clients.yaml` → `webdav-share/davfs`. |
| Forgejo SECRET_KEY, Forgejo INTERNAL_TOKEN | `NixOS/Server1` | – | – | `nixos-server1.yaml` → `forgejo/secret` or `forgejo/token`. |
| Linkwarden PostgreSQL | `NixOS/Server1` | `linkwarden` | – | `nixos-server1.yaml` → `linkwarden/postgres` and in PostgreSQL. |
| Linkwarden NEXTAUTH_SECRET | `NixOS/Server1` | – | – | `nixos-server1.yaml` → `linkwarden/secret`. |
| SearXNG secret | `NixOS/Server1` | – | – | `nixos-server1.yaml` → `searxng/secret` (line `SEARXNG_SECRET=`). |
| SABnzbd api_key, SABnzbd nzb_key | `NixOS/Server1` | – | – | `nixos-server1.yaml` → `sabnzbd` (`[misc]`). `api_key` also in Sonarr, Radarr, Lidarr, Readarr → Download Clients. |
| Pi-hole app password | `NixOS/Server1` | – | – | Generated by Pi-hole (`/api/auth/app`), hash in the notes. `nixos-server1.yaml` → `pihole/env` (line `FTLCONF_webserver_api_app_pwhash=`, the hash), `glance` (line `ENV_PIHOLE_PASSWORD=`) and `monitoring/pihole-env`. |
| Home Assistant token (Glance), Jellyfin API key (Glance), Sonarr API key, Radarr API key | `NixOS/Server1` | – | – | Issued by the service. `nixos-server1.yaml` → `glance` (line `ENV_HA_TOKEN=`, `ENV_JELLYFIN_TOKEN=`, `ENV_SONARR_KEY=` or `ENV_RADARR_KEY=`). |
| Pi-hole | `NixOS/Server1` | – | `https://pihole.<homeDomain>/admin` | `nixos-server1.yaml` → `pihole/env` (line `FTLCONF_webserver_api_password=`). |
| Grafana | `NixOS/Server1` | `admin` | `https://grafana.<homeDomain>` | Only in Grafana. |
| Syncthing GUI Server1 | `NixOS/Server1` | `admin` | `https://syncthing.<homeDomain>` | Plaintext in `nixos-server1.yaml` → `syncthing/nixos-server1/gui-password`. |
| Home Assistant, Jellyfin, Forgejo, Linkwarden, HomeBox, Sonarr, Radarr, Lidarr, Readarr, NZBHydra2, SABnzbd | `NixOS/Server1` | dein Benutzer | `https://homeassistant.<homeDomain>`, `https://jellyfin.<homeDomain>`, `https://forgejo.<homeDomain>`, `https://linkwarden.<homeDomain>`, `https://homebox.<homeDomain>`, `https://sonarr.<homeDomain>`, `https://radarr.<homeDomain>`, `https://lidarr.<homeDomain>`, `https://readarr.<homeDomain>`, `https://nzbhydra.<homeDomain>`, `https://sabnzbd.<homeDomain>` | Only in the service. |
| Stalwart admin | `NixOS/ServerPublic` | `admin` | `https://stalwart.<domain>` | Hash in `nixos-serverpublic.yaml` → `stalwart/admin`. |
| Matrix registration_shared_secret, Matrix macaroon_secret_key, Matrix form_secret, coturn secret | `NixOS/ServerPublic` | – | – | `nixos-serverpublic.yaml` → `matrix/registration_shared_secret`, `matrix/macaroon_secret_key`, `matrix/form_secret` or `coturn/secret`. |
| mautrix-signal pickle key, mautrix-signal provisioning secret, mautrix-whatsapp pickle key, mautrix-whatsapp provisioning secret | `NixOS/ServerPublic` | – | – | `nixos-serverpublic.yaml` → `mautrix-signal/env` or `mautrix-whatsapp/env` (one line each). Never change the pickle key after installation. |
| code-server | `NixOS/ServerGaming` | – | `https://code.<domain>` | Argon2 hash in `nixos-servergaming.yaml` → `codeserver/env`. Test service, delete in phase 19. |
| Forgejo SECRET_KEY, Forgejo INTERNAL_TOKEN, Linkwarden PostgreSQL, Linkwarden NEXTAUTH_SECRET, SearXNG secret | `NixOS/Portable` | – (Linkwarden PostgreSQL: `linkwarden`) | – | Portable server mode only. `nixos-portable.yaml` → `server/forgejo/secret`, `server/forgejo/token`, `server/linkwarden/postgres`, `server/linkwarden/secret`, `server/searxng/secret`. |
| SMB jf, SMB meli | `NixOS/Portable` | `jf` or `meli` | – | Portable server mode only. `nixos-portable.yaml` → `server/smb-share/user-jf`, `server/smb-share/user-meli`. Share: `smb://NixOS-Portable`. |
| WebDAV jf | `NixOS/Portable` | `jf` | `https://dav.portable.internal`, additional URL `https://webdav.portable.internal` | Portable server mode only. `nixos-portable.yaml` → `server/webdav-share/user-jf` (line `ENV_PASSWORD=`). |
| Radicale jf | `NixOS/Portable` | `jf` | `https://radicale.portable.internal` | Portable server mode only. `nixos-portable.yaml` → `server/radicale/htpasswd` (line `jf:<password>`). |
| code-server | `NixOS/Portable` | – | `https://code.portable.internal` | Portable server mode only. Argon2 hash in `nixos-portable.yaml` → `server/codeserver/env`. |
| Mullvad | `NixOS/Providers` | – | `https://mullvad.net/account` | Account number in the password field. `clients.yaml`, `nixos-portable.yaml` and `nixos-server1.yaml`, each → `mullvad`. |
| Alpha Vantage | `NixOS/Providers` | – | `https://www.alphavantage.co` | `clients.yaml` and `nixos-portable.yaml` → `alphavantage/api_key`. |
| Cloudflare | `NixOS/Providers` | Mailadresse | `https://dash.cloudflare.com` | 2FA recovery codes attached. |
| Cloudflare DNS token NixOS-Server1, Cloudflare DNS token NixOS-ServerPublic, Cloudflare DNS token NixOS-ServerGaming | `NixOS/Providers` | – | – (sonst konkurriert der Eintrag beim Ausfüllen mit dem Konto) | `nixos-server1.yaml`, `nixos-serverpublic.yaml` or `nixos-servergaming.yaml` → `nginx/acme/api_key`. Manage at `https://dash.cloudflare.com/profile/api-tokens`. |
| Usenet provider | `NixOS/Providers` | Benutzername beim Anbieter | Login-Seite des Anbieters | `nixos-server1.yaml` → `sabnzbd` (`[servers]`). |
| Telegram app (mautrix) | `NixOS/Providers` | Telefonnummer | `https://my.telegram.org` | `api_hash` in the password field, `api_id` in attribute `api_id`. `nixos-serverpublic.yaml` → `mautrix-telegram/env`. |
| Proton | `NixOS/Providers` | Mailadresse | `https://account.proton.me` | `nixos-server1.yaml` → `restic/rclone-proton` (rclone config, password only obscured, not encrypted). 2FA recovery codes attached. |
| Contabo, Registrar, DLRG, 1&1, GitHub, Codeberg | `NixOS/Providers` | Login beim Anbieter | `https://my.contabo.com`, Login-Seite des Registrars, Webmail der DLRG, Login-Seite von 1&1, `https://github.com`, `https://codeberg.org` | 2FA recovery codes attached. |

7F-L – Einträge, die es erst später gibt. Hier überspringen, sie entstehen in dem Schritt in der letzten Spalte, zusammen mit dem Wert in sops (KeePassXC zuerst, dann der Dienst, dann sops). Den Text fürs Notizfeld nennt der jeweilige Schritt:

| Titel | Gruppe | Benutzername | URL (Autofill) | Notizfeld | Anlegen in |
|---|---|---|---|---|---|
| Stalwart mailadmin | `NixOS/ServerPublic` | `mailadmin` | `https://stalwart.<domain>` | Own admin account in Stalwart with 2FA (TOTP in the entry), the fallback admin is only for emergencies. | 8.8 |
| Mailbox jf@ (ebenso jede weitere Adresse) | `NixOS/ServerPublic` | Mailadresse | `https://mail.<domain>` | In Stalwart, with 2FA (TOTP in the entry). | 8.8 |
| Mailbox jf@ App <Gerät> | `NixOS/ServerPublic` | Mailadresse | – | App password from Stalwart for Thunderbird or the phone, one per device. | 8.8 |
| Mailbox alerts@ | `NixOS/ServerPublic` | `alerts@<domain>` | `https://mail.<domain>` | In Stalwart; every host file → `notify/mail-password` (Server1 also for Alertmanager). | 10.1 |
| ntfy jf | `NixOS/ServerPublic` | `jf` | `https://push.<domain>` | bcrypt hash in `nixos-serverpublic.yaml` → `ntfy/env` (`NTFY_AUTH_USERS`); ntfy app on the phone. | 10.2 |
| ntfy token alerts | `NixOS/ServerPublic` | – | – | `nixos-serverpublic.yaml` → `ntfy/env` (`NTFY_AUTH_TOKENS`); every host file → `notify/ntfy-env` (line `NTFY_TOKEN=`); `nixos-server1.yaml` → `monitoring/ntfy-token`. Topic: `ALERT_TOPIC`. | 10.2, 10.3 |
| ntfy token killswitch read, ntfy token killswitch write | `NixOS/ServerPublic` | – | – | `nixos-serverpublic.yaml` → `ntfy/env` (`NTFY_AUTH_TOKENS`). Read: every host file → `killswitch/env` (line `NTFY_TOKEN=`). Write: `nixos-server1.yaml` → `killswitch/ha-env`. Topic: `KILLSWITCH_TOPIC`. | 10.4 |
| MollySocket VAPID | `NixOS/ServerPublic` | – | – | `nixos-serverpublic.yaml` → `mollysocket/env` (`MOLLY_VAPID_PRIVKEY`). | 13.10 (optional) |
| Matrix admin, CryptPad admin, Miniflux | `NixOS/ServerPublic` | `admin` | `https://matrix.<domain>`, `https://cryptpad.<domain>`, `https://rss.<domain>` | Admin accounts, only in the service. Not for daily use. | 8.8 |
| Matrix jf, CryptPad, Miniflux jf | `NixOS/ServerPublic` | `jf` | `https://matrix.<domain>`, `https://cryptpad.<domain>`, `https://rss.<domain>` | Personal accounts without admin rights, only in the service. Matrix: security key in an attribute. | 8.8 |
| Miniflux token (Glance) | `NixOS/ServerPublic` | – | – | Issued by Miniflux. `nixos-server1.yaml` → `glance` (line `ENV_MINIFLUX_TOKEN=`). | 8.8a |
| Matrix doublepuppet token | `NixOS/ServerPublic` | – | – | `nixos-serverpublic.yaml` → `matrix/doublepuppet_token`. Lets the bridges act as every local Matrix user, keep it only here and in sops. | 27.1 |
| Nextcloud admin, Nextcloud jf | `NixOS/ServerGaming` | `admin`, `jf` | `https://cloud.<domain>` | Only in Nextcloud, admin and personal account separate. Test service, delete in phase 19. | 19.4 |
| GitHub mirror token (Forgejo), Codeberg mirror token (Forgejo) | `NixOS/Providers` | Benutzer beim Anbieter | – | Issued by the provider, scoped to the mirrored repos. Only in Forgejo: repo → Settings → Mirror settings (7.16). | 7.16 |

Die restic-Einträge (Backups der VPS auf Server1 und von Server1 zu Proton Drive) stehen mit allem Nötigen in Tabelle 9A.

7F-S – Die fünf Syncthing-Einträge anlegen. Die Zertifikate werden erst in 22.5 erneuert, bis dahin stehen sie nur in sops und kommen noch nicht als Anhang in KeePassXC (sonst zweimal):

- [X] Pro Host in KeePassXC unter `NixOS/Keys` einen Eintrag anlegen: „Syncthing NixOS-Desktop“, „Syncthing NixOS-Framework“, „Syncthing NixOS-Convertible“, „Syncthing NixOS-Portable“, „Syncthing NixOS-Server1“. Kein Benutzername, keine URL, Passwortfeld leer. Das Notizfeld genau wie in der Tabelle oben, die Device IDs stehen dort schon. Speichern.
- [X] Prüfen, dass die Device IDs zu den Zertifikaten in sops passen, und die von Portable holen. Der Befehl legt Zertifikat und Schlüssel kurz im RAM ab, zeigt nur die IDs und vernichtet die Dateien wieder:

  ```
  cd ~/Documents/nixos-private/secrets; d=$(mktemp -d -p /run/user/1000)
  for x in "clients.yaml nixos-desktop" "clients.yaml nixos-framework" "clients.yaml nixos-convertible" "nixos-portable.yaml nixos-portable" "nixos-server1.yaml nixos-server1"; do set -- $x; for k in cert key; do sops -d --extract "[\"syncthing\"][\"$2\"][\"$k\"]" "$1" > "$d/$k.pem"; done; echo "$2: $(nix shell nixpkgs#syncthing -c syncthing device-id --home "$d")"; done
  shred -u "$d"/*.pem; rmdir "$d"
  ```

  Die vier IDs von Desktop, Framework, Convertible und Server1 müssen mit der Tabelle übereinstimmen. Weicht eine ab, mir Bescheid geben (dann passt das Zertifikat in sops nicht zur Geräteliste). Die ID von Portable ins Notizfeld von „Syncthing NixOS-Portable“. Portable kommt nach seiner Installation in 12.7 in die Gerätelisten.
- [X] 7.12 Nur bei konkretem Verdacht: ZFS-Schlüssel `zfs/pool01` wechseln. Dabei bleiben die Daten verschlüsselt wie vorher, es wird nur der Schlüssel getauscht, der den eigentlichen Datenschlüssel schützt.
  1. Backups prüfen: Back In Time auf die externe Platte und restic aktuell.
  2. `zfs get -H -o name,value keyformat,encryptionroot pool01/applications pool01/shares pool01/shares/jf` zeigt Format und die Verschlüsselungs-Roots. Der neue Schlüssel braucht dasselbe Format (bei `hex`: 64 Hex-Zeichen).
  3. Alten Schlüssel sichern (in der Persistenz, er wird nach dem Neustart noch gebraucht), neuen erzeugen: `sudo sh -c 'umask 077; cp /secrets/zfs-cache.key /persistent/pool01.old; openssl rand -hex 32 | tr -d "\n" > /persistent/pool01.new'`.
  4. Für jeden Verschlüsselungs-Root: `sudo zfs change-key -o keyformat=hex -o keylocation=prompt <root> < /persistent/pool01.new`.
  5. Cache-Laufwerk: `sudo cryptsetup luksAddKey --key-file /persistent/pool01.old /dev/nvme0n1p1 /persistent/pool01.new`.
  6. Inhalt von `/persistent/pool01.new` in KeePassXC und als `zfs/pool01` in sops eintragen, committen, `nix flake update private`, deployen.
  7. Prüfen ohne Neustart: `sudo zfs load-key -n pool01/shares < /run/secrets/zfs/pool01` (Probelauf) und `sudo cryptsetup open --test-passphrase --key-file /secrets/zfs-cache.key /dev/nvme0n1p1`. Erst dann neu starten.
  8. Nach dem erfolgreichen Neustart den alten LUKS-Schlüssel entfernen und beide Dateien löschen: `sudo cryptsetup luksRemoveKey /dev/nvme0n1p1 /persistent/pool01.old && sudo shred -u /persistent/pool01.old /persistent/pool01.new`.

7G – Phase 7 abschließen: einmal bauen, deployen, prüfen (am besten sofort, auch vor 7E)

Befund vom 07.11.2026: Server1 läuft noch mit der Generation vom 04.11. (`system-132`), der Desktop mit der vom 06.11., 09:50. Beide lesen noch die alte gemeinsame `secrets.yaml` aus dem öffentlichen Repo. Keiner der Werte aus 7.4 bis 7.10 ist dort also schon aktiv. Die Dienste laufen nur, weil `/run/secrets` seit der letzten Aktivierung im RAM liegt. **Server1 und die Clients bis zum Ende von 7.15 nicht neu starten.** Passt `/secrets/keys.txt` schon zum neuen Host-Schlüssel (7.5c), lässt sich die alte Datei beim Booten nicht mehr entschlüsseln, und die Dienste starten ohne Secrets. ServerPublic, ServerGaming und Portable sind noch nicht installiert und bekommen den neuen Stand bei der Installation (8.6, 8.14, 12.3).

- [X] 7.13 Vorbereiten:
  - [X] Stand der sops-Dateien: Am 07.11.2026 nach dem Terminal-Absturz aus den Arbeitskopien zurückgeschrieben und für alle Hosts geprüft (die Logins in `user/…` für alle Hosts, `server/…` bei Portable, die Altlasten auf Server1 gelöscht). Hast du danach noch etwas geändert: jede sops-Sitzung mit `:wq` schließen (Strg+S speichert nur die unverschlüsselte Arbeitskopie in `/tmp`), nie mehrere Dateien gleichzeitig offen lassen, und `ls -l --time-style=+%F_%T ~/Documents/nixos-private/secrets/` zeigt bei der geänderten Datei die aktuelle Zeit.
  - [X] Forgejo: 2FA jetzt ausschalten, solange noch der alte `SECRET_KEY` läuft: `https://forgejo.<homeDomain>` → Einstellungen → Sicherheit → Zwei-Faktor-Authentifizierung → deaktivieren. Nach dem Deploy kann Forgejo den alten TOTP-Seed nicht mehr lesen. Dazu die Spiegel notieren: Verwaltung → Repositorys (Symbol „Spiegel“), bei Pull-Spiegeln den Benutzer, bei Push-Spiegeln die Ziel-URL.
  - [X] Linkwarden: Hast du das PostgreSQL-Passwort aus 7D-2 noch nicht geändert, jetzt, direkt vor dem Deploy: `ssh -t admin@NixOS-Server1 "sudo -u postgres psql -c '\password linkwarden'"`, zweimal das Passwort aus „Linkwarden PostgreSQL“ einfügen. Bis zum Deploy erreicht Linkwarden die Datenbank dann nicht. Hast du es schon früher geändert, läuft Linkwarden seitdem mit dem alten Passwort, das Deploy behebt das.
  - [X] Privates Repo committen, der Flake liest nur committete Stände: `cd ~/Documents/nixos-private && git status --short && git add -A && git commit -m "phase 7: rotated secrets"`, dann `cd ~/Documents/nixos && nix flake update private`.
- [X] 7.14 Prüfen, ohne etwas zu aktivieren:
  - [X] Bauen. Fehlt ein sops-Eintrag, bricht der Build mit `the key '…' cannot be found` ab und nennt ihn:

    ```
    cd ~/Documents/nixos
    for h in NixOS-Server1 NixOS-Desktop NixOS-Framework NixOS-Convertible; do nix build --no-link .#nixosConfigurations.$h.config.system.build.toplevel && echo "OK $h"; done
    ```

  - [X] Passt der Host-Schlüssel zur Datei? Die Befehle entschlüsseln nach `/dev/null` und zeigen keine Werte, nur `OK`. Server1, vom Desktop aus:

    ```
    scp ~/Documents/nixos-private/secrets/nixos-server1.yaml admin@NixOS-Server1:/tmp/s1.yaml && ssh -t admin@NixOS-Server1 'nix shell nixpkgs#sops -c sh -c "sudo env SOPS_AGE_KEY_FILE=/secrets/keys.txt \$(command -v sops) -d /tmp/s1.yaml >/dev/null && echo OK"; rm -f /tmp/s1.yaml'
    ```

    Desktop, Framework und Convertible, jeweils lokal auf dem Rechner:

    ```
    nix shell nixpkgs#sops -c sh -c 'sudo env SOPS_AGE_KEY_FILE=/secrets/keys.txt "$(command -v sops)" -d ~/Documents/nixos-private/secrets/clients.yaml >/dev/null && echo OK'
    ```

    Kommt statt `OK` die Meldung `no identity matched any of the recipients`, diesen Host nicht deployen: Sein Public Key fehlt in `$PRIV/secrets/.sops.yaml` (`sudo age-keygen -y /secrets/keys.txt` mit `sops_<host>` vergleichen), danach `sops updatekeys -y <datei>`, committen, `nix flake update private`, 7.14 wiederholen.
- [X] 7.15 Deployen, Server1 zuerst. Seit 07.11.2026 kommen auf allen Hosts auch die Login-Passwörter aus sops (`user/…`). Stimmt ein Hash nicht, klappt `sudo` danach nicht mehr, auf Server1 auch kein weiteres Deploy. Deshalb vorher eine Root-Shell öffnen und offen lassen, bis `sudo -v` mit dem Passwort aus KeePassXC („Login <Host>“) geklappt hat. Geht es nicht, in der Root-Shell `nixos-rebuild switch --rollback`.
  - [X] Root-Shell für Server1, in einem zweiten Terminal: `ssh -t admin@NixOS-Server1 sudo -i`. Für den Desktop und die Laptops jeweils lokal in einem zweiten Terminal: `sudo -i`.
  - [X] Server1: `nixos-rebuild switch --flake .#NixOS-Server1 --build-host admin@NixOS-Server1 --target-host admin@NixOS-Server1 --sudo --ask-sudo-password`, danach in einem dritten Terminal `ssh -t admin@NixOS-Server1 sudo -v` (Passwort aus „Login NixOS-Server1“). Ohne Ausgabe heißt: geklappt, ein falsches Passwort meldet `Sorry, try again.`
  - [X] Desktop: `cd ~/Documents/nixos && sudo nixos-rebuild switch --flake .#NixOS-Desktop`, danach in einem neuen Terminal `sudo -k; sudo -v` (Passwort aus „Login NixOS-Desktop“). Erst wenn das geht, die Root-Shell schließen.
  - [X] Framework und Convertible, jeweils auf dem Laptop, sobald Syncthing dort „Aktuell“ zeigt: `cd ~/Documents/nixos && sudo nixos-rebuild switch --flake .#NixOS-Framework` bzw. `sudo nixos-rebuild switch --flake .#NixOS-Convertible`
  - [X] Auf jedem dieser Hosts: `systemctl --failed` ist leer, und die aktive Generation liest die neue Datei: `grep -o '"sopsFile":"[^"]*"' $(grep -o '/nix/store/[a-z0-9]*-manifest.json' /run/current-system/activate | head -1) | sort -u` zeigt nur `…-nixos-server1.yaml` (Server1) bzw. `…-clients.yaml` (Clients), kein `…-secrets.yaml` mehr. Ab hier sind Neustarts wieder unbedenklich.
- [X] 7.16 Prüfen, was sich in Phase 7 geändert hat (der volle Test aller Dienste folgt einmal am Ende in Phase 21):
  - [X] Dienste mit neuen Secrets einmal neu starten. Befund vom 07.11.2026: Bis auf Pi-hole, Glance und Syncthing-GUI hatte kein Secret `restartUnits`, sops-nix tauscht dann nur die Datei. webdav, SABnzbd, SearXNG, Radicale und Forgejo liefen deshalb weiter mit den alten Werten vom 03.11. (WebDAV und SABnzbd lehnten die neuen Passwörter ab). Seitdem starten die Dienste bei jeder Änderung ihres Secrets neu, für die schon geänderten Werte aber nicht mehr.
    1. Forgejo zuerst: Die 2FA von oben wurde noch mit dem alten `SECRET_KEY` gespeichert und ist nach dem Neustart unlesbar. Deshalb jetzt `https://forgejo.<homeDomain>` → Einstellungen → Sicherheit → Zwei-Faktor-Authentifizierung → deaktivieren, das TOTP im KeePassXC-Eintrag „Forgejo“ entfernen.
    2. Neu starten: `ssh -t admin@NixOS-Server1 'sudo systemctl restart forgejo webdav sabnzbd searx radicale && systemctl --failed --no-legend'`
    3. Prüfen: `ssh admin@NixOS-Server1 'systemctl show forgejo webdav sabnzbd searx radicale -p Id -p ActiveEnterTimestamp'` zeigt bei allen die aktuelle Zeit. `ssh admin@NixOS-Server1 'journalctl -u forgejo --since -10min -o cat | grep -i -E "decrypt|secret"'` zeigt nichts.
    4. Danach den Forgejo-Punkt unten (2FA) noch einmal und die Spiegel prüfen. WebDAV mit „WebDAV jf“ im Browser, SABnzbd mit dem neuen Zugang, in Sonarr, Radarr, Lidarr und Readarr den neuen `api_key` unter Einstellungen → Download-Clients → SABnzbd eintragen und „Test“.
  - [X] Forgejo (nach dem Neustart oben, die erste 2FA lief noch mit dem alten Schlüssel): anmelden, `journalctl -u forgejo -b | grep -i -E "secret|decrypt"` zeigt keine Fehler. 2FA neu einrichten: Einstellungen → Sicherheit → Zwei-Faktor-Authentifizierung → aktivieren, den QR-Code in der Authenticator-App einlesen. Den Seed (der Text unter dem QR-Code) zusätzlich im KeePassXC-Eintrag „Forgejo“ (`NixOS/Server1`) unter Eintrag → TOTP → TOTP einrichten eintragen, die Wiederherstellungscodes als Anhang. Ab- und wieder anmelden, der Code aus KeePassXC muss passen.
  - [X] Forgejo-Spiegel: nur prüfen, erst nach dem Neustart oben (davor lief Forgejo noch mit dem alten `SECRET_KEY`, fehlerfreie Logs sagen also nichts). Bei jedem Spiegel mit Zugangsdaten (Pull-Spiegel eines privaten Repos, Push-Spiegel zu GitHub oder Codeberg): Repo → Einstellungen → Spiegel-Einstellungen → „Jetzt synchronisieren“, danach Verwaltung → Systemhinweise. Ist dort nichts und die Zeit der letzten Synchronisierung aktuell, ist der Punkt erledigt. Spiegel öffentlicher Repos ohne Zugangsdaten brauchen nichts. Nur bei einem Fehler:
    - Token zuerst: beim Anbieter einen neuen anlegen (GitHub → Settings → Developer settings → Fine-grained tokens, nur die gespiegelten Repos, „Contents: Read and write“; Codeberg → Einstellungen → Anwendungen, `write:repository`), den alten dort löschen. KeePassXC: „GitHub mirror token (Forgejo)“ bzw. „Codeberg mirror token (Forgejo)“ in `NixOS/Providers`, ohne URL.
    - Pull-Spiegel: Repo → Einstellungen → Spiegel-Einstellungen → Autorisierung, Benutzer und Token neu eintragen, speichern, „Jetzt synchronisieren“.
    - Push-Spiegel lassen sich nicht bearbeiten: Eintrag löschen, mit derselben Ziel-URL und dem neuen Token neu anlegen, „Jetzt synchronisieren“.
    - Prüfen: Das Repo zeigt „Zuletzt synchronisiert“ mit aktueller Zeit, die Systemhinweise bleiben leer.
  - [X] PostgreSQL meldet `collation version mismatch` (Datenbanken mit glibc 2.42 angelegt, das System hat 2.44, Indizes auf Text können falsch sortiert sein). Weil Linkwarden ohnehin gleich getestet wird, jetzt beheben, auf Server1:

    ```
    sudo systemctl stop linkwarden invidious
    for db in $(sudo -u postgres psql -Atc "SELECT datname FROM pg_database WHERE datallowconn"); do sudo -u postgres psql -d "$db" -c "REINDEX DATABASE \"$db\"" -c "ALTER DATABASE \"$db\" REFRESH COLLATION VERSION"; done
    sudo systemctl start linkwarden invidious
    ```

    Prüfen: `sudo -u postgres psql -c '\du'` zeigt die Warnung nicht mehr. Nach jedem größeren glibc-Update wieder prüfen.
  - [X] Linkwarden: anmelden, einen Link speichern, nach etwa einer Minute ist das Archiv da. `journalctl -u linkwarden -b | grep -i -E "password authentication failed|ECONNREFUSED"` ist leer. Invidious spielt ein Video.
  - [X] Pi-hole: `sudo grep FTLCONF /var/log/pihole/FTL.log | tail -1` zeigt `2 FTLCONF environment variables found (2 used, 0 invalid, 0 ignored)`. `https://pihole.<homeDomain>/admin`: Anmeldung mit „Pi-hole“ geht, mit dem alten Passwort aus dem Verlauf des Eintrags nicht mehr. In Glance zeigt das Pi-hole-Widget Zahlen.
  - [X] Syncthing-GUI: `https://syncthing.<homeDomain>`, Anmeldung mit `admin` und „Syncthing GUI Server1“. `systemctl status syncthing-init` ohne Fehler.
  - [X] Übrige Werte aus 7D-2: SearXNG sucht (`https://searxng.<homeDomain>`). WebDAV: `https://dav.<homeDomain>` im Browser mit „WebDAV jf“. SABnzbd: in Sonarr, Radarr, Lidarr und Readarr unter Einstellungen → Download-Clients → SABnzbd → „Test“ grün. Glance: Seite lädt, eingeschaltete Widgets zeigen Daten. Cloudflare-Token: `sudo systemctl start acme-order-renew-pihole.<homeDomain>.service`, danach `systemctl status acme-order-renew-pihole.<homeDomain>.service` ohne Fehler (`systemctl list-units --all 'acme-order-renew-*'` zeigt die Namen).
  - [X] Clients: `mullvad status` verbunden, KMyMoney holt einen Kurs (Alpha Vantage), `ls /run/secrets` zeigt die erwarteten Einträge.
  - [X] Erst wenn alles läuft: in den in Phase 7 geänderten KeePassXC-Einträgen den Verlauf mit den alten Werten löschen (Eintrag → Verlauf).

# Teil B – Offen, in dieser Reihenfolge

## Phase 27 – Jetzt zuerst: Stand vom 08.11.2026 ausrollen und aufräumen

Alle Änderungen vom 08.11.2026 sind gebaut und ausgewertet, aber noch auf keinem Host aktiv. Hier in einem Zug ausrollen, prüfen und Reste löschen. ServerPublic zuerst, weil dort der Bridge-Neustart aus 8.8 dranhängt.

- [ ] 27.1 Double Puppeting vorbereiten (Entscheidung 08.11.2026), vor dem Deploy von ServerPublic. Die Bridges handeln dann mit deinem Konto `@jf:matrix.<domain>`: Sie treten neuen Räumen selbst bei, und was du am Handy schreibst, erscheint in Matrix als von dir. Das Token darf als jeder Benutzer deines Servers schreiben, deshalb nur in sops und KeePassXC.
  1. `openssl rand -hex 64` und den Wert in KeePassXC `NixOS/ServerPublic` → „Matrix doublepuppet token“ ins Passwortfeld, ohne URL. Notizfeld:

     ```
     Matrix doublepuppet token:
     nixos-serverpublic.yaml → matrix/doublepuppet_token
     ```

  2. `cd ~/Documents/nixos-private/secrets && sops nixos-serverpublic.yaml`, unter `matrix:` die Zeile `doublepuppet_token: <wert>` ergänzen (4 Leerzeichen eingerückt wie die anderen), mit `:wq` speichern. Committen: `cd ~/Documents/nixos-private && git add -A && git commit -m "matrix double puppet token"`, dann `cd ~/Documents/nixos && nix flake update private`.
  3. In `hosts/NixOS-ServerPublic/server.nix` im Block `matrix.bridges` die Zeile `doublePuppet = true;` ergänzen (oder Claude Bescheid geben).

- [ ] 27.2 Alle Hosts bauen (fehlt ein Secret, bricht der Build mit `the key '…' cannot be found` ab):

  ```
  cd ~/Documents/nixos
  for h in NixOS-ServerPublic NixOS-Server1 NixOS-ServerGaming NixOS-Desktop NixOS-Framework NixOS-Convertible; do nix build --no-link .#nixosConfigurations.$h.config.system.build.toplevel && echo "OK $h"; done
  ```

  Der Desktop baut dabei die gepatchte Monero GUI selbst (einmal etwa 15 Minuten).

- [ ] 27.3 Deployen, in dieser Reihenfolge:
  1. ServerPublic mit Neustart der Bridges (der Verlauf kommt nur in neue, leere Räume, deshalb einmal neu anfangen, 8.8 → Bridges → Schritt 5). Auf ServerPublic zuerst die Bridges anhalten und ihre Daten löschen:

     ```
     sudo systemctl stop mautrix-discord mautrix-signal mautrix-telegram mautrix-whatsapp
     sudo find /var/lib/mautrix-discord /var/lib/mautrix-signal /var/lib/mautrix-telegram /var/lib/mautrix-whatsapp -mindepth 1 -delete
     ```

     Dann vom Desktop: `nixos-rebuild switch --flake .#NixOS-ServerPublic --build-host admin@<ipv4> --target-host admin@<ipv4> --sudo --ask-sudo-password` (`<ipv4>` = `serverPublic.ipv4`, nach dem Deploy der Clients geht auch der Name). Danach auf ServerPublic: `sudo systemctl start mautrix-discord mautrix-signal mautrix-telegram mautrix-whatsapp` und `sudo systemctl restart matrix-synapse` (Synapse liest die neuen Registrierungen nur beim Start). Weiter in 8.8 → Bridges → Schritt 5.2 (alte Räume verlassen, neu anmelden, Discord-Server freischalten).
  2. Server1: `nixos-rebuild switch --flake .#NixOS-Server1 --build-host admin@NixOS-Server1 --target-host admin@NixOS-Server1 --sudo --ask-sudo-password`. Der Ollama-Loader löscht dabei die alten Modelle und lädt die neuen (13.29).
  3. ServerGaming: `nixos-rebuild switch --flake .#NixOS-ServerGaming --build-host admin@<ipv4> --target-host admin@<ipv4> --sudo --ask-sudo-password` (`<ipv4>` = `serverGaming.ipv4`).
  4. Desktop: `sudo nixos-rebuild switch --flake .#NixOS-Desktop`. Framework und Convertible jeweils lokal: `sudo nixos-rebuild switch --flake .#NixOS-Framework` bzw. `.#NixOS-Convertible`.
  5. Auf jedem Host `systemctl --failed` leer, auf den Clients zusätzlich `systemctl status home-manager-jf`.

- [ ] 27.4 Prüfen und einrichten:
  - [ ] Server1, Snapshots einschalten (die Timer laufen, aber nur Datasets mit der Eigenschaft werden gesichert; `pool01` vererbt sie an alle): `ssh -t admin@NixOS-Server1 'sudo zfs set com.sun:auto-snapshot=true pool01 && zfs get -r -o name,value com.sun:auto-snapshot pool01 && systemctl list-timers "zfs-snapshot-*"'`. Erwartet: überall `true`, Timer für daily, weekly und monthly. Am nächsten Tag zeigt `zfs list -t snapshot -r pool01` die ersten `zfs-auto-snap_daily-…`.
  - [ ] Server1, Monero ist weg: `ssh admin@NixOS-Server1 'systemctl status monero p2pool'` meldet bei beiden „could not be found“.
  - [ ] ServerPublic: 14.9 (Sandboxing) und 14.3 (SMT). Double Puppeting: `ssh admin@NixOS-ServerPublic 'journalctl -u mautrix-signal -b | grep -i -m3 "double puppet"'` ohne Fehler, nach dem Login in einer Bridge erscheinen deine eigenen Nachrichten vom Handy als `jf`.
  - [ ] ServerGaming: `ssh admin@NixOS-ServerGaming getfacl /srv/minecraft` zeigt `group:minecraft:rwx` und `default:group:minecraft:rwx`.
  - [ ] Clients: `getent hosts NixOS-ServerPublic NixOS-ServerGaming` zeigt die öffentlichen Adressen (13.31). In Dolphin steht in der Seitenleiste „Minecraft“ und öffnet `/srv/minecraft` (KeePassXC entsperrt). WebDAV: `ls /mount/dav` zeigt die Dateien von `dav.<homeDomain>` (`systemctl status mount-dav.mount` bei Fehlern).
  - [ ] Monero GUI auf dem Desktop auf den eigenen Node umstellen (die Voreinstellung gilt nur für neue Installationen, deine `monero-gui.conf` gibt es schon): Monero GUI → Einstellungen → Knoten → „Lokaler Knoten“, Blockchain-Ordner `/mount/Data/Datein/Monero`, „Blockchain beschneiden“ an. Der erste Abgleich dauert Tage (pruned etwa 100 GB). Danach Mining → „P2Pool“ → Start. Die GUI nutzt jetzt das p2pool aus nixpkgs (Patch in `pkgs/default.nix`). Laptops: dort ebenfalls lokaler Knoten oder in der GUI einen Remote-Knoten wählen, Server1 bietet keinen mehr an.

- [ ] 27.5 Reste löschen (immer erst nach dem Deploy des jeweiligen Hosts):
  - [ ] Server1, Mai-Snapshot (die Bilder sind zurückgeholt, 13.28; gibt etwa 1,4 TB frei: `video` 728 GB, `applications` 345 GB, `jf` 301 GB): `ssh -t admin@NixOS-Server1 'sudo zfs destroy -rv pool01@2026.05.14-10.39.43 && zfs list -o name,avail pool01'`.
  - [ ] Server1, Monero-Daten: zuerst ansehen `ssh -t admin@NixOS-Server1 'sudo ls -la /pool01/applications | grep -i -E "monero|p2pool"; sudo du -sh /pool01/applications/monero'`, dann `ssh -t admin@NixOS-Server1 'sudo rm -r /pool01/applications/monero'` (und `/pool01/applications/p2pool`, falls vorhanden). Die festen IDs `monero` in `hosts/NixOS-Server1/usergroupids.nix` sind schon entfernt.
  - [ ] ServerPublic, Zertifikat des Apex: steht in 8.8 → Matrix → Schritt 0 → „Aufräumen“.
  - [ ] Desktop, Fusion 360 (Modul seit 08.11.2026 entfernt, 11 GB): zuerst `findmnt ~/.local/share/fusion360` (muss leer sein, sonst ist der alte Stand noch aktiv), dann `rm -r /persistent/home/jf/.local/share/fusion360`. Gab es den Ordner auf einem anderen Client auch (`ls /persistent/home/jf/.local/share/fusion360`), dort ebenso.
  - [ ] Clients, `/etc/ssh`-Reste: 13.30 (Framework, Convertible, Server1; der Desktop ist sauber).
  - [ ] Forgejo-Spiegel: 15.11.

## Phase 8 – NixOS-ServerPublic installieren

SSH auf die VPS geht immer direkt, ohne WireGuard (seit 08.11.2026, 13.31). Bis die Clients mit dieser Änderung deployt sind, lösen sie die Namen der VPS noch nicht auf. Du erreichst sie dann über ihre öffentliche IP (`$PRIV/site.nix` → `serverPublic.ipv4` bzw. `serverGaming.ipv4`): `ssh admin@<ipv4>`, deployen mit `nixos-rebuild switch --flake .#NixOS-ServerPublic --build-host admin@<ipv4> --target-host admin@<ipv4> --sudo --ask-sudo-password` (bei ServerGaming `.#NixOS-ServerGaming` und dessen IP). Danach gehen auch `ssh admin@NixOS-ServerPublic` und `ssh admin@NixOS-ServerGaming`, die Namen zeigen auf die öffentlichen Adressen aus `site.nix`.

- [X] 8.1 Den VPS bestellen (Contabo, Anbieter siehe [`docs/providers.md`](docs/providers.md)) und die Daten in `$PRIV/site.nix` → `serverPublic` eintragen, committen, `nix flake update private`.
- [X] 8.2 Den Host-Key vor der Installation erzeugen, Datei `keys.txt` außerhalb beider Repos ablegen: `nix shell nixpkgs#age -c age-keygen -o keys.txt`, den Public Key in `.sops.yaml` als `sops_serverpublic` eintragen, dann `sops updatekeys secrets/nixos-serverpublic.yaml`.
- [X] 8.3 Die Werte in `nixos-serverpublic.yaml` sind seit 7.6 neu (7D-3), restic folgt in Phase 9 (9A). Hier nur prüfen, dass keiner fehlt, ohne etwas zu entschlüsseln: nach 8.2 im privaten Repo committen, `cd ~/Documents/nixos && nix flake update private && nix build --no-link .#nixosConfigurations.NixOS-ServerPublic.config.system.build.toplevel`. Fehlt ein Eintrag, bricht der Build mit `the key '…' cannot be found` ab.
- [X] 8.3a WireGuard-Schlüssel von ServerPublic: seit 07.11.2026 in `nixosModules/system/wireguard.nix` (`WM3RI8KfcnWXoPzSWc0k/Xv3ZDC9vEsWER7w7u+y4w8=`, abgeleitet aus dem privaten Schlüssel in sops). Die Schlüssel der anderen Peers kommen erst in 9.1 dazu.
- [X] 8.4 Firewall im Contabo-Panel: Network Services → Firewall, Firewall pro Server anlegen, unter Inbound Rules die Regeln unten als Accept Rule mit Source „Any“ (IPv4 und IPv6) anlegen und den VPS unter Active VPS/VDS zuweisen. Eingehend bleibt alles andere gesperrt, ausgehend ist alles frei. Die Regeln greifen vor NixOS, dessen eigene Firewall bleibt zusätzlich aktiv. Prometheus-Ports (9100 usw.) laufen über WireGuard und brauchen keine Regel. Zuerst nur 22 und 2222 anlegen und installieren, die Dienste danach freigeben. Danach prüfen, ob ausgehende Verbindungen gehen (`curl -I https://nixos.org`, `chronyc sources`), die Doku von Contabo sagt nicht, ob die Regeln zustandsbehaftet sind.

Die Spalte „Name“ ist der Regelname im Panel, „Quelle“ das Feld Source. „Any“ heißt: eine Regel für IPv4 (0.0.0.0/0) und eine für IPv6 (::/0). Stand 04.11.2026 aus `networking.firewall` beider Hosts, nach dem Umzug der Testdienste auf ServerGaming (Phase 19).

| Name | Port | Protokoll | Quelle | ServerPublic | ServerGaming | Wofür |
|---|---|---|---|---|---|---|
| ssh | 22 | TCP | Any | ja | ja | SSH, direkt ohne WireGuard, nie löschen |
| initrd-ssh | 2222 | TCP | Any | ja | ja | LUKS-Entsperrung im initrd bei jedem Neustart, nie löschen |
| web | 80, 443 | TCP | Any | ja | ja | Webdienste, BlueMap, Testdienste |
| smtp | 25 | TCP | Any | ja | nein | Mail von anderen Servern |
| smtps | 465 | TCP | Any | ja | nein | Mail senden mit TLS von Anfang an (Thunderbird) |
| submission | 587 | TCP | Any | ja | nein | Mail senden mit STARTTLS |
| imaps | 993 | TCP | Any | ja | nein | IMAP |
| stun-turn | 3478, 5349 | TCP und UDP | Any | ja | nein | STUN/TURN (coturn) |
| turn-relay | 49152-49999 | UDP | Any | ja | nein | TURN-Relay für Anrufe |
| wireguard | 51820 | UDP | Any | ja | nein | WireGuard-Hub |
| minecraft | 25565 | TCP | Any | nein | ja | Minecraft |
| icmp | – | ICMP | Any | ja | ja | IPv6 braucht ICMP, Ping beantwortet der Server trotzdem nicht |

- [X] 8.5 Zuerst in der VM testen: `nixos-rebuild build-vm --flake .#NixOS-VMServerPublic`. Der hardened malloc und `security.lockKernelModules` sind aktiv. Die VM hat keinen age-Key, Dienste mit Secrets können deshalb unabhängig davon scheitern. Prüfen, ob die übrigen Dienste starten: `systemctl --failed`. Bricht ein Dienst ab, `nixos.system.hardening.hardenedMalloc = false;` setzen und das hier notieren.
- [X] 8.5a Ergebnis ServerPublic (07.11.2026): `/dev/sda`, kein `/sys/firmware/efi`, also BIOS. `hosts/NixOS-ServerPublic/disko.nix` ist seitdem auf BIOS-Boot umgestellt. Ein Übergangssystem installieren und darin prüfen. Ein neuer VPS ist bei Contabo „nicht installiert“, das Menü „More“ (⋮) und das Rescue-System gibt es erst danach. nixos-anywhere (8.6) braucht ohnehin ein laufendes Linux mit SSH als `root`, es überschreibt die Platte.
  - [X] Customer Panel → Servers & Hosting → VPS/VDS → beim VPS „Install“ (bei einem schon installierten „More“ → „Reinstall“) → Standard Image, Debian (neueste Version), bei SSH Key den öffentlichen Schlüssel vom Desktop (`cat ~/.ssh/id_ed25519.pub`, „jf@NixOS-Desktop“), zusätzlich ein Root-Passwort aus KeePassXC (nur für dieses Übergangssystem, nach 8.6 wertlos) → Install. Fortschritt in der Spalte Status.
  - [X] Vom Desktop: `ssh-keygen -R <ipv4>`, dann `ssh root@<ipv4>` (`<ipv4>` aus `$PRIV/site.nix` → `serverPublic.ipv4`, den Fingerprint mit `yes` annehmen).
  - [X] Darin `lsblk -o NAME,SIZE,TYPE,MODEL` (die Hosts erwarten `/dev/sda`, sonst `hosts/<Host>/disko.nix` anpassen) und `ls /sys/firmware/efi` (Liste = UEFI, passt; `No such file or directory` = BIOS, dann `nixos.system.bootloader.biosDevice` setzen). Beide Ausgaben an Claude geben. Bei ServerGaming dasselbe vor 8.15.
- [X] 8.6 Installieren, Ablauf auch in [`README.md`](README.md#installation). Die erste Installation am 07.11.2026 lief, danach fand sshd `/etc/ssh/sshd_config` nicht (das persistierte `/etc/ssh` verdeckte die Dateien der Aktivierung) und brauchte Handarbeit im Rescue-System. Behoben in `nixosModules/system/ssh.nix` und `initrdssh.nix`: Host-Keys und initrd-Key liegen direkt unter `/persistent/etc/ssh`, `/etc/ssh` wird nicht mehr persistiert. Am 08.11.2026 neu installieren, um das zu prüfen:
  - [X] Vorher: KeePassXC entsperrt, `ssh-add -l` zeigt den Desktop-Key. Contabo-Panel → VPS → ⋮ → Rescue System, als Zugang den SSH-Key des Desktops. Dann vom Desktop `ssh-keygen -R <ipv4>` und `ssh root@<ipv4> true` (Fingerprint annehmen).
  - [X] Dateien im RAM vorbereiten (die vom 07.11. sind weg, `/run/user/1000` ist ein tmpfs):

    ```
    d=$(mktemp -d -p /run/user/1000 anywhere.XXXXXX)
    mkdir -p "$d"/extra/{secrets,persistent/etc/ssh}
    chmod 755 "$d"/extra "$d"/extra/persistent "$d"/extra/persistent/etc "$d"/extra/persistent/etc/ssh
    chmod 700 "$d"/extra/secrets
    (umask 077; cat > "$d"/extra/secrets/keys.txt)
    (umask 077; read -rsp "LUKS passphrase: " p; printf '%s' "$p" > "$d"/luks.pass); echo
    ssh-keygen -q -t ed25519 -N "" -C "initrd@NixOS-ServerPublic" -f "$d"/extra/persistent/etc/ssh/initrd_host_key
    ssh-keygen -lf "$d"/extra/persistent/etc/ssh/initrd_host_key.pub
    echo "$d"
    ```

    Bei `cat` die Zeile `AGE-SECRET-KEY-1…` aus KeePassXC „age NixOS-ServerPublic“ einfügen, Enter, Strg+D. Bei `read` die Passphrase aus „LUKS NixOS-ServerPublic“. Den neuen Fingerprint des initrd-Keys in „LUKS NixOS-ServerPublic“ eintragen, den alten ersetzen.
  - [X] Installieren (aus dem Rescue-System lädt nixos-anywhere zuerst per kexec seinen Installer, die Platte wird komplett neu angelegt):

    ```
    cd ~/Documents/nixos
    nix run nixpkgs#nixos-anywhere -- --flake .#NixOS-ServerPublic \
      --disk-encryption-keys /tmp/secret.key "$d"/luks.pass \
      --extra-files "$d"/extra \
      root@<ipv4> 2>&1 | tee /run/user/1000/anywhere.log
    ```

    Scheitert kexec im Rescue-System, im Panel stattdessen Debian als Standard-Image mit dem SSH-Key installieren und den Befehl wiederholen.
    Antwortet GitHub beim Download des kexec-Tarballs mit `504` (08.11.2026 für einige Minuten), den Tarball lokal holen und mitgeben: `k=$(nix build --no-link --print-out-paths github:nix-community/nixos-images#kexec-installer-nixos-stable-noninteractive)`, dann zusätzlich `--kexec "$k"/nixos-kexec-installer-noninteractive-x86_64-linux.tar.gz`.
  - [X] Entsperren, ohne Handarbeit:

    ```
    ssh-keygen -R <ipv4>; ssh-keygen -R "[<ipv4>]:2222"
    ssh -p 2222 root@<ipv4>
    systemd-tty-ask-password-agent
    ```

    Fingerprint mit KeePassXC vergleichen, Passphrase einfügen. Die Verbindung bricht danach ab.
  - [X] Prüfen: `ssh-keygen -R <ipv4>`, dann `ssh -t admin@<ipv4> 'findmnt /etc/ssh; ls -la /etc/ssh /persistent/etc/ssh; sudo -v && systemctl --failed --no-legend; sudo nix shell nixpkgs#age -c age-keygen -y /secrets/keys.txt'`. Erwartet: `findmnt` gibt nichts aus, `/etc/ssh` enthält `sshd_config` und `authorized_keys.d`, `/persistent/etc/ssh` die Host-Keys und `initrd_host_key`, `sudo -v` nimmt das Passwort aus KeePassXC (eingefügt), keine fehlgeschlagenen Units, der age-Key gehört zu einem Empfänger in `.sops.yaml`. Den Fingerprint von `ssh_host_ed25519_key` in KeePassXC notieren.
  - [X] Einmal neu starten (`ssh -t admin@<ipv4> sudo reboot`), entsperren wie oben und `ssh admin@<ipv4>` muss ohne neue Host-Key-Warnung gehen. Damit ist gezeigt, dass die Host-Keys die Persistenz überleben.
  - [X] Aufräumen: `shred -u "$d"/luks.pass "$d"/extra/secrets/* "$d"/extra/persistent/etc/ssh/* && rm -r "$d" /run/user/1000/anywhere.log`.
- [X] 8.7 DNS-Einträge und Einstellungen beim Anbieter. Stand 08.11.2026 (von außen geprüft): MX, SPF, DKIM (`202611r`, `202611e`), DMARC, TLS-RPT, SRV, CAA und A/AAAA für `mail` und `mta-sts` stehen. Es fehlen die offenen Punkte unten. Der Apex `<domain>` braucht keinen Eintrag: Matrix-Adressen heißen seit 08.11.2026 `@name:matrix.<domain>`.
  - [X] MTA-STS: Stalwart zeigt diesen Eintrag nicht an, also selbst anlegen. Cloudflare → `<domain>` → DNS → „Add record“: Typ TXT, Name `_mta-sts`, Inhalt `v=STSv1; id=20261108`. Die `id` ist frei wählbar (nur Buchstaben und Ziffern) und muss sich ändern, wenn sich die Policy ändert, sonst holen andere Server sie nicht neu. Die Policy selbst liefert Stalwart unter `https://mta-sts.<domain>/.well-known/mta-sts.txt` schon aus (`mode: testing`). Prüfen: `dig +short TXT _mta-sts.<domain>`. Später, wenn eingehende Mail stabil läuft (Port 25 und STARTTLS bei internet.nl grün), die Policy auf `mode: enforce` stellen und die `id` erhöhen, z. B. `id=20261201`.
  - [X] PTR (Reverse DNS): Der Eintrag gehört dem Besitzer der IP, also Contabo, nicht Cloudflare. Customer Panel → „Reverse DNS Management“ → bei der IPv4 von ServerPublic `mail.<domain>` eintragen, ebenso bei der IPv6 (`serverPublic.ipv6`). Jetzt steht dort ein Name `vmd….contaboserver.net`, deshalb meldet mail-tester „Your reverse DNS does not match“, und manche Empfänger (AOL, teils Microsoft) lehnen Mails ohne passenden PTR ab. Prüfen (die Änderung braucht bis zu einige Stunden): `dig +short -x <ipv4>` zeigt `mail.<domain>.`.
  - [X] CAA: steht schon. Cloudflare legt die Einträge für die Zertifizierungsstellen selbst an, `letsencrypt.org` ist dabei. Nichts tun.
  - [X] Port 25 eingehend (internet.nl): Senden und Empfangen gehen, Firewall und Stalwart sind richtig. internet.nl meldet „Unreachable receiving mail server“, weil Stalwart die Testserver als Scanner sperrt (Log 08.11.2026 12:02 und 13:11: „Banned due to scan“, Verbindungen ohne Mail, ab 30 am Tag dauerhaft). Das bleibt bewusst so, der STARTTLS-Test von internet.nl fällt damit weg. mail-tester zeigt 10/10.
  - [X] DKIM-Signatur: Am 08.11.2026 meldete Stalwart `DKIM signer not found`, nach `sudo systemctl restart stalwart` signiert es, mail-tester zeigt 10/10. Stalwart liest neu angelegte Signaturen also erst beim Neustart.
  - [X] Vorher (08.11.2026): Stalwart läuft dauerhaft auf der Hauptdomain. In `$PRIV/site.nix` `mailDomain` auf denselben Wert wie `domain` setzen und `mailAddress` auf eine Adresse dieser Domain, im privaten Repo committen, dann hier `nix flake update private` und ServerPublic deployen. Vorher prüfen, dass die Hauptdomain keine MX- oder SPF-Einträge von anderer Stelle hat (z. B. E-Mail-Routing von Cloudflare). Die Einträge unten gelten für die Hauptdomain.
- [X] 8.8 Ersteinrichtung. Jedes Konto gleich mit dem endgültigen Passwort anlegen: zuerst in KeePassXC erzeugen und speichern, dann im Dienst eintragen. Passwörter: KeePassXC → Reiter „Passwort“, 128 Zeichen, nur A-Z, a-z, 0-9; lehnt der Dienst das ab, in KeePassXC auf das erlaubte Maximum kürzen und das im Notizfeld vermerken. Diese Konten sind neu, sie werden in Phase 20 nicht noch einmal geändert.
  - [X] Stalwart. Die Adressen lauten `name@<domain>`, `mail.<domain>` ist nur der Name des Servers. Die Oberfläche ist englisch, die Menünamen können je nach Version leicht abweichen.
    1. Anmelden auf `https://stalwart.<domain>` mit `admin` und „Stalwart admin“. Das ist der Notfall-Admin aus der Konfiguration (`authentication.fallback-admin`). Er kann weder 2FA noch App-Passwörter, daher die Meldung „Fallback administrator accounts do not support 2FA or AppPasswords“. Nur für die Ersteinrichtung und als Notzugang nutzen.
    2. Domain: Management → Directory → Domains → „Create domain“, Name `<domain>` (nicht `mail.<domain>`), speichern. Stalwart erzeugt dabei die DKIM-Schlüssel.
    3. DNS: In der Domainliste bei `<domain>` „View DNS records“ öffnen und alle Einträge (MX, SPF, DKIM, DMARC, MTA-STS, TLS-RPT, SRV) in Cloudflare anlegen, „DNS only“ (8.7). Der MX zeigt auf `mail.<domain>`.
    4. Eigenes Admin-Konto mit 2FA: KeePassXC `NixOS/ServerPublic` → „Stalwart mailadmin“, Benutzername `mailadmin`, URL `https://stalwart.<domain>`, Passwort wie oben erzeugen. Management → Directory → Accounts → „Create account“: Name `mailadmin`, Passwort aus dem Eintrag, keine E-Mail-Adresse, unter Roles `admin`, speichern. Abmelden, als `mailadmin` anmelden, unter Account → Security die Zwei-Faktor-Authentifizierung einschalten und den TOTP-Schlüssel in KeePassXC am Eintrag speichern (Eintrag → TOTP → Einrichten). Ab jetzt nur noch mit `mailadmin` verwalten.
    5. Postfach `jf`: KeePassXC „Mailbox jf@“, Benutzername `jf@<domain>`, URL `https://mail.<domain>`. Als `mailadmin`: Accounts → „Create account“, Name `jf@<domain>` (so meldet sich Thunderbird an, `mailAddress` in `$PRIV/site.nix`), Passwort aus dem Eintrag, E-Mail-Adresse `jf@<domain>`, dazu als weitere Adressen `postmaster@<domain>`, `abuse@<domain>` und `dmarc@<domain>` (Pflichtadressen und DMARC-Berichte landen bei dir), Roles `user`, kein Admin. Weitere eigene Adressen ebenso als Alias oder als eigenes Konto mit eigenem Eintrag.
    6. 2FA und App-Passwörter für `jf`: als `jf@<domain>` auf `https://stalwart.<domain>` anmelden, unter Account → Security die Zwei-Faktor-Authentifizierung einschalten (TOTP in KeePassXC am Eintrag „Mailbox jf@“). Danach unter App Passwords je Gerät ein Passwort erzeugen (Thunderbird Desktop, Framework, Convertible, Handy), jedes als eigener KeePassXC-Eintrag „Mailbox jf@ App <Gerät>“. Mit 2FA nehmen IMAP und SMTP nur noch App-Passwörter, Thunderbird fragt beim ersten Start danach.
    7. Prüfen: Thunderbird sendet an eine fremde Adresse und empfängt die Antwort. `https://www.mail-tester.com` zeigt 10/10, `https://internet.nl/test-mail/` ist grün bei DKIM, DMARC, SPF, STARTTLS und MTA-STS.
    8. `alerts@` kommt in 10.1 (eigenes Konto, Roles `user`, ohne 2FA, die Hosts senden per SMTP mit Passwort).
  - [X] Matrix, zwei getrennte Konten, beide direkt auf dem Server angelegt (die Registrierung in Element geht nur mit Token). Seit 08.11.2026 ist `server_name` `matrix.<domain>`, die Adressen lauten `@admin:matrix.<domain>` und `@jf:matrix.<domain>`, in Element ist der Server `matrix.<domain>`.
    0. Zurücksetzen, einmalig vor dem Deploy dieser Änderung: Synapse lief schon mit `server_name` `<domain>`, und die Bridges haben ihre Bots damit registriert. Synapse verweigert den Start, wenn in der Datenbank Benutzer einer anderen Domain stehen, und der Name lässt sich nicht nachträglich ändern. Auf ServerPublic zuerst ansehen, was in der Datenbank steht: `sudo -u postgres psql -d matrix-synapse -tAc 'SELECT name FROM users'`. Erwartet sind nur die Bots der Bridges (`@discordbot:<domain>`, `@signalbot:<domain>`, `@telegrambot:<domain>`, `@whatsappbot:<domain>`). Eigene Konten gibt es noch keine (Stand 08.11.2026). Steht dort trotzdem eines, erst Claude fragen. Ist die Liste leer oder stehen dort nur die Bots, weiter:

       ```
       sudo systemctl stop mautrix-discord mautrix-signal mautrix-telegram mautrix-whatsapp matrix-synapse
       sudo -u postgres dropdb matrix-synapse
       sudo find /var/lib/matrix-synapse /var/lib/mautrix-discord /var/lib/mautrix-signal /var/lib/mautrix-telegram /var/lib/mautrix-whatsapp -mindepth 1 -delete
       ```

       Dann vom Desktop deployen: `nixos-rebuild switch --flake .#NixOS-ServerPublic --build-host admin@<ipv4> --target-host admin@<ipv4> --sudo --ask-sudo-password`. Danach auf ServerPublic `sudo systemctl restart matrix-synapse-db matrix-synapse mautrix-discord mautrix-signal mautrix-telegram mautrix-whatsapp` und prüfen: `systemctl is-active matrix-synapse mautrix-discord mautrix-signal mautrix-telegram mautrix-whatsapp` zeigt fünfmal `active`, `curl https://matrix.<domain>/.well-known/matrix/client` zeigt `{"m.homeserver":{"base_url":"https://matrix.<domain>"}}`, `https://federationtester.matrix.org` mit `matrix.<domain>` ist grün.
       Aufräumen: Für `<domain>` selbst holt nginx kein Zertifikat mehr. `ls /var/lib/acme /var/lib/acme/.lego` auf ServerPublic, dann die Ordner, die genau `<domain>` heißen (nicht `matrix.<domain>` usw.), löschen: `sudo rm -r /var/lib/acme/<domain> /var/lib/acme/.lego/<domain>`. Einen DNS-Eintrag für den Apex gibt es nicht, in Cloudflare ist nichts zu tun.
    1. Admin: KeePassXC `NixOS/ServerPublic` → „Matrix admin“, Benutzername `admin`, URL `https://matrix.<domain>`. Auf ServerPublic: `sudo -u matrix-synapse matrix-synapse-register_new_matrix_user -u admin -a` (NixOS installiert das Programm unter diesem Namen, es gibt Konfiguration und Adresse selbst mit), Passwort aus dem Eintrag. Nur für Tokens und Verwaltung, nicht in Element angemeldet lassen.
    2. Persönlich: KeePassXC „Matrix jf“, Benutzername `jf`. `sudo -u matrix-synapse matrix-synapse-register_new_matrix_user -u jf --no-admin`. In Element mit Server `matrix.<domain>` als `jf` anmelden (Adresse `@jf:matrix.<domain>`), Sicherheitsschlüssel (Schlüsselsicherung) in KeePassXC am Eintrag speichern.
    3. Prüfen: In Element eine Registrierung ohne Token versuchen, sie wird abgelehnt.
  - [ ] Bridges (Signal, WhatsApp, Telegram, Discord), in Element als `jf` (das Konto `admin` verbindet keine Dienste). Die Bots heißen `@signalbot:matrix.<domain>`, `@whatsappbot:matrix.<domain>`, `@telegrambot:matrix.<domain>` und `@discordbot:matrix.<domain>`. In einem Raum, in dem nur du und der Bot seid, gelten Befehle ohne Präfix.
    1. Signal und WhatsApp (die Bridges können Verschlüsselung; bis 08.11.2026 erreichten sie Synapse nicht, `homeserver.address` fehlte, nach dem Deploy antworten sie): Element → „+“ neben „Personen“ → „Unterhaltung beginnen“, `@signalbot:matrix.<domain>` eintragen → „Los“. Der Bot tritt bei und antwortet. `help` zeigt alle Befehle.
    2. Telegram und Discord (die Bridges können keine Verschlüsselung, in einem verschlüsselten Raum antwortet der Bot nicht): Element → „+“ neben „Räume“ → „Neuer Raum“, Name z. B. `Telegram`, „Ende-zu-Ende-Verschlüsselung aktivieren“ ausschalten → „Raum erstellen“, dann „Einladen“ → `@telegrambot:matrix.<domain>`. Für Discord ebenso mit `@discordbot:matrix.<domain>`. Antwortet der Bot mit „This bridge has not been configured to support encryption“, ist der Raum verschlüsselt. Das lässt sich nicht mehr abschalten: Raum verlassen und einen neuen ohne Verschlüsselung anlegen.
    3. Anmelden, jeweils `login` an den Bot schicken:
       - Signal: Der Bot schickt einen QR-Code. Am Handy Signal → Einstellungen → Verknüpfte Geräte → „+“, Code scannen.
       - WhatsApp: Der Bot fragt nach der Methode, QR-Code wählen. Am Handy WhatsApp → Einstellungen → Verknüpfte Geräte → „Gerät hinzufügen“, Code scannen.
       - Telegram: Telefonnummer mit Ländervorwahl (`+49…`), dann den Code aus der Telegram-App, bei aktivierter Zwei-Schritt-Bestätigung zusätzlich das Passwort.
       - Discord: Der Bot schickt einen QR-Code. In der Discord-App am Handy → Einstellungen → „QR-Code scannen“. Kommt „CAPTCHAs are currently not supported - use token login instead“ (08.11.2026 so passiert): Im Browser auf discord.com anmelden, F12 → Reiter „Netzwerk“ → Seite neu laden → eine Anfrage an `api` anklicken → unter „Anfragekopfzeilen“ den Wert von `authorization` kopieren. Im Raum `login-token user <token>` schicken und die Nachricht danach löschen. Achtung: Ein Benutzer-Token in einem fremden Programm verstößt gegen die Regeln von Discord, im schlimmsten Fall sperrt Discord das Konto. Abmelden in Discord oder ein neues Passwort macht den Token ungültig.
    4. Prüfen: Nach dem Login legt jede Bridge für deine Chats eigene Räume an, Nachrichten gehen in beide Richtungen. `ping` an den Bot zeigt, ob du angemeldet bist.
    5. Verlauf nachholen, zusammen mit 27.3 (seit 08.11.2026 holen die Bridges bis zu 10000 Nachrichten pro Chat, das gilt nur für neue, leere Räume, und Signal und WhatsApp schicken den Verlauf nur beim Login). Die schon angelegten Räume bekommen nichts nach, deshalb einmal neu anfangen, nach dem Deploy von ServerPublic:
       1. Auf ServerPublic die Bridges zurücksetzen:

          ```
          sudo systemctl stop mautrix-discord mautrix-signal mautrix-telegram mautrix-whatsapp
          sudo find /var/lib/mautrix-discord /var/lib/mautrix-signal /var/lib/mautrix-telegram /var/lib/mautrix-whatsapp -mindepth 1 -delete
          sudo systemctl start mautrix-discord mautrix-signal mautrix-telegram mautrix-whatsapp
          sudo systemctl restart matrix-synapse
          ```

          Die Bridges schreiben beim Start neue Registrierungen, Synapse liest sie nur beim eigenen Start, deshalb in dieser Reihenfolge.
       2. In Element die alten Bridge-Räume und die alten Bot-Chats verlassen (Raum → „Verlassen“).
       3. Mit jedem Bot einen neuen Raum öffnen wie in Schritt 1 und 2 und wieder `login`. Signal fragt am Handy nach dem QR-Code, ob der Nachrichtenverlauf übertragen werden soll: „Übertragen“ wählen. Bei WhatsApp kommt ein Jahr Verlauf, die Übertragung dauert einige Minuten.
       4. Discord: `guilds status` zeigt deine Server mit ID, für jeden gewünschten `guilds bridge <ID> --entire`.
       5. Mit Double Puppeting (27.1) treten die Bridges den neuen Räumen selbst bei. Bleiben doch Einladungen offen: auf ServerPublic `matrix-accept-invites jf` (Passwort aus „Matrix jf“), nach einigen Minuten noch einmal.
  - [X] Miniflux (Admin): KeePassXC `NixOS/ServerPublic` → „Miniflux“, URL `https://rss.<domain>`. Auf ServerPublic: `sudo -u miniflux env DATABASE_URL="user=miniflux host=/run/postgresql dbname=miniflux" miniflux -create-admin`, Benutzername und Passwort aus dem Eintrag.
  - [X] Miniflux, persönliches Konto: KeePassXC „Miniflux jf“, Benutzername `jf`, URL `https://rss.<domain>`. Als Admin anmelden → Settings → Users → „Add user“, Name `jf`, Passwort aus dem Eintrag, „Administrator“ nicht anhaken. Abmelden, als `jf` anmelden und dort die Feeds anlegen oder per OPML importieren. Das Admin-Konto liest keine Feeds.
  - [X] CryptPad: KeePassXC `NixOS/ServerPublic` → „CryptPad“, URL `https://cryptpad.<domain>`. Auf `https://cryptpad.<domain>` registrieren, dann Einstellungen → Konto → „Öffentlicher Signaturschlüssel“ kopieren und in `hosts/NixOS-ServerPublic/server.nix` bei `nixos.server.public.cryptpad.adminKeys` eintragen, die Domain dabei nicht ausschreiben: `"[admin@cryptpad.${config.nixos.server.network.nginx.domain}/…=]"` (der Schlüssel ist öffentlich, die Domain kommt aus `site.nix`), deployen. Danach sofort Administration (`https://cryptpad.<domain>/admin/`) → Benutzerverzeichnis → „Registrierung schließen“. Freunde bekommen dort je einen Einladungslink (ein Konto pro Link, CryptPad verschickt nichts, den Link selbst über Signal o. Ä. schicken). Bis die Registrierung zu ist, kann sich jeder ein Konto anlegen, der die Adresse kennt.
  - [X] CryptPad, Admin und `jf` trennen: Das registrierte Konto ist jetzt Admin. Ist es dein persönliches, ein zweites anlegen: KeePassXC „CryptPad admin“, Benutzername `admin`. Als jetziger Admin unter Administration → Benutzerverzeichnis einen Einladungslink erzeugen, im privaten Fenster damit `admin` registrieren, dort den „Öffentlichen Signaturschlüssel“ kopieren und in `nixos.server.public.cryptpad.adminKeys` statt des alten eintragen, deployen. Prüfen: Als `admin` ist Administration sichtbar, als `jf` nicht mehr. Zählen, wie viele Konten es gibt: `ssh -t admin@<ipv4> 'sudo find /var/lib/private/cryptpad/block -type f | wc -l'`.
  - [X] ntfy: Benutzer und Tokens kommen deklarativ aus `ntfy/env` (10.2), hier nichts anlegen.
  - [X] Briar-Mailbox: läuft seit 08.11.2026 (das Image baute vorher nicht, `briar-mailbox.nix` nennt das Basis-Image jetzt mit Registry). Den QR-Code zeigt `ssh -t admin@<ipv4> journalctl -u podman-briar-mailbox`, verbinden am Handy: 23.8.
- [X] 8.8a Miniflux-Token für Glance und Fluent Reader (damit sind 4.10 und der Miniflux-Teil von 13.12 erledigt):
  - [X] Glance: als `jf` in Miniflux angemeldet (der Token gehört zum Benutzer, Glance zeigt dessen Feeds) → Einstellungen → API-Schlüssel → „Neuen API-Schlüssel erstellen“, Beschreibung `glance`. KeePassXC `NixOS/ServerPublic` → „Miniflux token (Glance)“, ohne URL. `cd ~/Documents/nixos-private/secrets && sops nixos-server1.yaml`, unter `glance` die Zeile `ENV_MINIFLUX_TOKEN=<token>` ergänzen. In `hosts/NixOS-Server1/server.nix` `nixos.server.management.glance.miniflux.enable = true` setzen. Privates Repo committen, `cd ~/Documents/nixos && nix flake update private`, Server1 deployen: `nixos-rebuild switch --flake .#NixOS-Server1 --build-host admin@NixOS-Server1 --target-host admin@NixOS-Server1 --sudo --ask-sudo-password`. Prüfen: Glance zeigt auf der Seite Server die ungelesenen Einträge. Notizfeld in KeePassXC:

    ```
    Miniflux token (Glance):
    nixos-server1.yaml → glance (line ENV_MINIFLUX_TOKEN=)
    ```
  - [X] Fluent Reader: noch einen API-Schlüssel, Beschreibung `fluent-reader`, in Fluent Reader unter Einstellungen → Dienst → Miniflux eintragen (URL `https://rss.<domain>`). KeePassXC: im Eintrag „Miniflux“ unter Erweitert → Zusätzliche Attribute als `fluent-reader token` (geschützt).
- [X] 8.9 Ping ist absichtlich deaktiviert (`icmp_echo_ignore_all`). Monitoring per Ping funktioniert deshalb nicht, IPv6/ICMPv6 bleibt erlaubt.

8B – NixOS-ServerGaming installieren (Minecraft, BlueMap, Countdown)

In 8B ist `<ipv4>` immer die Adresse von ServerGaming (`$PRIV/site.nix` → `serverGaming.ipv4`), `<ipv6>` entsprechend `serverGaming.ipv6`. Die Befehle laufen auf dem Desktop im Ordner `~/Documents/nixos`, KeePassXC ist entsperrt.

- [X] 8.10 Eigener VPS bei Contabo (200 GB), Daten stehen in `$PRIV/site.nix`. Minecraft nutzt bis zu 12 GB RAM, der VPS braucht also 16 GB oder mehr.
- [X] 8.11 Host-Key: `nix shell nixpkgs#age -c age-keygen -o keys.txt` in einem Ordner außerhalb beider Repos. Die Zeile `AGE-SECRET-KEY-1…` in KeePassXC `NixOS/Keys` → „age NixOS-ServerGaming“ (Passwortfeld, Public Key ins Notizfeld). Den Public Key in `$PRIV/secrets/.sops.yaml` als `sops_servergaming` eintragen, die Zeilen für `nixos-servergaming.yaml` aktivieren, `cd ~/Documents/nixos-private/secrets && sops updatekeys -y nixos-servergaming.yaml`, dann `shred -u keys.txt`.
- [X] 8.12 Prüfen, dass kein Secret fehlt, ohne etwas zu entschlüsseln (die Werte sind seit 7.6 neu, 7D-4; restic folgt in Phase 9, 9A): `cd ~/Documents/nixos-private && git add -A && git commit -m "servergaming key"`, dann `cd ~/Documents/nixos && nix flake update private && nix build --no-link .#nixosConfigurations.NixOS-ServerGaming.config.system.build.toplevel`. Fehlt ein Eintrag, bricht der Build mit `the key '…' cannot be found` ab.
- [X] 8.13 Countdown: In `hosts/NixOS-ServerGaming/temp/default.nix` steht `target = "2026-11-13T19:00:00+01:00";`. Datum, Uhrzeit und die Texte daneben prüfen. Der Name steht damit im öffentlichen Repo.
- [X] 8.14 Firewall im Contabo-Panel: Network Services → Firewall → „Create Firewall“, Name `servergaming`. Unter Inbound Rules als Accept Rule mit Source „Any“ (je eine Regel für IPv4 und IPv6) zuerst nur `ssh` (22, TCP) und `initrd-ssh` (2222, TCP). Unter Active VPS/VDS den Gaming-VPS zuweisen. Nach der Installation (8.15) dazu: `web` (80 und 443, TCP), `minecraft` (25565, TCP), `icmp` (ICMP). Mehr braucht ServerGaming nicht (Tabelle in 8.4).
- [X] 8.15 Installieren:
  - [X] Übergangssystem: Customer Panel → Servers & Hosting → VPS/VDS → beim Gaming-VPS „Install“ (ist er schon installiert: „More“ → „Reinstall“) → Standard Image, Debian (neueste Version). Bei SSH Key den Schlüssel des Desktops (`cat ~/.ssh/id_ed25519.pub`, „jf@NixOS-Desktop“), dazu ein Root-Passwort aus KeePassXC (nur für dieses Übergangssystem) → Install. Warten, bis der Status „running“ zeigt.
  - [X] Vom Desktop: `ssh-keygen -R <ipv4>`, dann `ssh root@<ipv4> 'lsblk -o NAME,SIZE,TYPE,MODEL; ls /sys/firmware/efi; ip -4 addr; ip -4 route; ip -6 addr'` (Fingerprint mit `yes` annehmen). Erwartet: eine Platte `sda`, bei `/sys/firmware/efi` „No such file or directory“ (BIOS, so ist `hosts/NixOS-ServerGaming/disko.nix` eingestellt). Adresse, Präfixlänge und Gateway müssen zu `serverGaming.ipv4`, `ipv4PrefixLength`, `ipv4Gateway`, `ipv6` und `ipv6PrefixLength` in `$PRIV/site.nix` passen, sonst antworten nach der Installation weder SSH noch die Entsperrung. Weicht etwas ab: Ausgabe an Claude.
  - [X] Dateien im RAM vorbereiten:

    ```
    d=$(mktemp -d -p /run/user/1000 anywhere.XXXXXX)
    mkdir -p "$d"/extra/{secrets,persistent/etc/ssh}
    chmod 755 "$d"/extra "$d"/extra/persistent "$d"/extra/persistent/etc "$d"/extra/persistent/etc/ssh
    chmod 700 "$d"/extra/secrets
    (umask 077; cat > "$d"/extra/secrets/keys.txt)
    (umask 077; read -rsp "LUKS passphrase: " p; printf '%s' "$p" > "$d"/luks.pass); echo
    ssh-keygen -q -t ed25519 -N "" -C "initrd@NixOS-ServerGaming" -f "$d"/extra/persistent/etc/ssh/initrd_host_key
    ssh-keygen -lf "$d"/extra/persistent/etc/ssh/initrd_host_key.pub
    echo "$d"
    ```

    Bei `cat` die Zeile `AGE-SECRET-KEY-1…` aus „age NixOS-ServerGaming“ einfügen, Enter, Strg+D. Bei `read` die Passphrase aus `NixOS/Devices` → „LUKS NixOS-ServerGaming“ (vorher dort erzeugen: Reiter „Passwort“, 128 Zeichen, nur A-Z, a-z, 0-9). Den Fingerprint, den `ssh-keygen -lf` ausgibt, im Notizfeld von „LUKS NixOS-ServerGaming“ eintragen.
  - [X] Installieren (nixos-anywhere lädt per kexec seinen Installer, die Platte wird komplett neu angelegt, das System baut der Desktop):

    ```
    cd ~/Documents/nixos
    nix run nixpkgs#nixos-anywhere -- --flake .#NixOS-ServerGaming \
      --disk-encryption-keys /tmp/secret.key "$d"/luks.pass \
      --extra-files "$d"/extra \
      root@<ipv4> 2>&1 | tee /run/user/1000/anywhere.log
    ```

    Antwortet GitHub beim Download des kexec-Tarballs mit `504`: `k=$(nix build --no-link --print-out-paths github:nix-community/nixos-images#kexec-installer-nixos-stable-noninteractive)` und den Befehl mit zusätzlich `--kexec "$k"/nixos-kexec-installer-noninteractive-x86_64-linux.tar.gz` wiederholen. Am Ende startet der VPS neu.
  - [X] Entsperren:

    ```
    ssh-keygen -R <ipv4>; ssh-keygen -R "[<ipv4>]:2222"
    ssh -p 2222 root@<ipv4>
    systemd-tty-ask-password-agent
    ```

    Den angezeigten Fingerprint mit dem in „LUKS NixOS-ServerGaming“ vergleichen, dann die Passphrase einfügen. Die Verbindung bricht danach ab, das System bootet weiter. Antwortet Port 2222 nicht: Contabo-Panel → VPS → „VNC“ und dort die Passphrase eingeben.
  - [X] Prüfen: `ssh -t admin@<ipv4> 'findmnt /etc/ssh; ls -la /etc/ssh /persistent/etc/ssh; sudo -v && systemctl --failed --no-legend; sudo nix shell nixpkgs#age -c age-keygen -y /secrets/keys.txt'` (neuer Host-Key, mit `yes` annehmen). Erwartet: `findmnt` gibt nichts aus, `/etc/ssh` enthält `sshd_config` und `authorized_keys.d`, `/persistent/etc/ssh` die Host-Keys und `initrd_host_key`, `sudo -v` nimmt das Passwort aus „Login NixOS-ServerGaming“, keine fehlgeschlagenen Units, der age-Key ist der aus `.sops.yaml`. Den Fingerprint (`ssh admin@<ipv4> ssh-keygen -lf /persistent/etc/ssh/ssh_host_ed25519_key.pub`) im Notizfeld von „Login NixOS-ServerGaming“ notieren.
  - [X] Neustart: `ssh -t admin@<ipv4> sudo reboot`, entsperren mit den drei Befehlen aus dem Schritt „Entsperren“ (ohne `ssh-keygen -R`), danach muss `ssh admin@<ipv4> true` ohne Host-Key-Warnung gehen.
  - [X] Aufräumen: `shred -u "$d"/luks.pass "$d"/extra/secrets/* "$d"/extra/persistent/etc/ssh/* && rm -r "$d" /run/user/1000/anywhere.log`. Das Root-Passwort des Übergangssystems in KeePassXC löschen.
  - [X] Firewall: die Regeln `web`, `minecraft` und `icmp` aus 8.14 anlegen.
- [X] 8.16 DNS in Cloudflare → `<domain>` → DNS: für `bluemap`, `countdown` und `flolserver` je einen Eintrag Typ A (Wert `<ipv4>`) und AAAA (Wert `<ipv6>`), „DNS only“. Die Zertifikate holt ACME per DNS-01, dafür ist nichts weiter nötig.
- [ ] 8.17 Minecraft, neuer Server mit neuer Welt (keine alten Dateien, Entscheidung 08.11.2026). Eingestellt ist Minecraft 1.21.11 (Fabric Loader 0.20.1, Fabric API 0.141.6, BlueMap 5.16). Die Welt entsteht beim ersten Start von selbst im Ordner `/srv/minecraft/flolserver/world`. Verwaltung, neue Welt, Herunter- und Hochladen und Versionswechsel: [`nixosModules/server/game/README.md`](nixosModules/server/game/README.md#managing-the-minecraft-servers).
  1. Optional vor der Installation: eine neuere Version wählen (nix-minecraft kennt schon 26.3), Schritte „Change the Minecraft version“ in der README. Alle Mitspieler brauchen dann dieselbe Version.
  2. Nach der Installation prüfen: `ssh admin@<ipv4> journalctl -u minecraft-server-flolserver -n 50` zeigt `Done`. Im Spiel `flolserver.<domain>` beitreten (nur Spieler aus der Whitelist in `hosts/NixOS-ServerGaming/minecraft.nix`).
  3. `https://bluemap.<domain>` lädt die Karte (das erste Rendern dauert), `https://countdown.<domain>` zeigt den Countdown.
## Phase 13 – Fehler, offene Prüfungen

- [ ] 4.11 EasyEffects: Das Preset `microphone` ist auf Rode Procaster und Behringer UMC22 abgestimmt (Eingang 1, 48V aus). Den Gain am UMC22 so einstellen, dass normale Sprache bei -18 bis -12 dBFS liegt, dann Probeaufnahme machen. Die Werte stammen aus den Datenblättern und sind nicht gemessen, Feinabstimmung siehe [`docs/microphone.md`](docs/microphone.md).
- [ ] 13.1 Boot-Log auf jedem Host prüfen: `journalctl -b 0 -p err` (nur Fehler) und `journalctl -b 0 -p warning`. Auf den Clients ist das Punkt 5.1a. Befund auf NixOS-Desktop (18.10. und 02.11.2026):
  - [x] `systemd-cryptsetup: key file '/tmp/secret.key' missing`: behoben (disko `passwordFile` statt `settings.keyFile`)
  - [x] `bootctl: /boot ... random seed ... world accessible`: behoben (ESP mit `fmask=0077`)
  - [x] Journal zeigt nur den aktuellen Boot: behoben (`/etc/machine-id` persistiert, Phase 4.1)
  - [x] `dbus-broker-launch: Ignoring duplicate name ...`: Kosmetik (der Dienst kommt doppelt aus system-path und Paket). Für den System-Bus per `LogFilterPatterns` gefiltert (`nixosModules/system/dbus.nix`). Die Meldungen des Session-Busses bleiben, der Filter wirkt nicht in User-Units.
  - [x] (08.11.2026 nicht mehr im Journal) `Invalid framebuffer status: GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT` (16-mal): Prozess finden (`journalctl -b -p err -o verbose | grep -B20 GL_FRAMEBUFFER | grep _COMM`), vermutlich KWin/Plasma mit amdgpu
  - [x] `kauditd hold queue overflow`: behoben, `backlogLimit` ist 8192 (`nixosModules/system/hardening.nix`), am 02.11.2026 nach dem Reboot 0 Treffer.
  - [x] `wallpaper-random: Found ordering cycle`: behoben, der Dienst hängt jetzt an `awww.service` statt am Target.
  - [x] `backintime: cannot chdir(/var/cron)`: behoben, siehe 4.7.
  - [x] `systemd-cryptsetup: Failed to activate with specified passphrase`: einmaliger Tippfehler bei der LUKS-Eingabe (15:01:29), der zweite Versuch 6 Sekunden später war erfolgreich. Keine Konfiguration betroffen.
  - [x] `chronyd: Could not connect ... No route to host`: harmlos. IPv6 ist beim Start von chronyd noch nicht bereit, 15 Sekunden später steht NTS (`chronyc -n sources`).
  - [x] ddcutil-Meldungen (`dw_start_watch_displays`): von PowerDevil, harmlos
  - [x] `ucsi_acpi USBC000:00: GET_CABLE_PROPERTY failed` (Framework): Firmware meldet die Kabeldaten nicht, harmlos.
  - [x] (08.11.2026 nicht mehr im Journal, akzeptiert) `baloo_file_extractor ... App info not found` und `MDB_BAD_RSLOT` (einmal pro Boot, 10 Minuten nach dem Login): harmlos, die Indexierung läuft weiter. Der Index ist 12 GiB groß, ggf. Baloo einschränken (`balooctl6 status`)
  - Befund auf NixOS-Convertible (03.11.2026):
    - [x] 5 Coredumps `iio-hyprland` (SIGABRT): behoben. `touch.enable` war im Host gesetzt und hing nicht am Hyprland-Bundle. Ohne Hyprland liefen `iio-hyprland` und `wvkbd` in Plasma und fanden keinen Hyprland-Socket. Das Touch-Modul wirkt jetzt nur noch mit Hyprland.
    - [x] `ACPI BIOS Error (bug): Could not resolve symbol [\_SB.PC00.PEG0.PXSX]`: Fehler in der Firmware-Tabelle (verweist auf einen nicht vorhandenen PCIe-Slot), harmlos.
    - [ ] `int3472-tps68470 ... No board-data found for this model`: Der Kernel kennt die Stromversorgung der Kamera dieses Modells nicht. Harmlos, falls die Kamera nicht gebraucht wird. Sonst prüfen, ob sie in einer Videokonferenz funktioniert.
    - [ ] `i2c_hid_acpi i2c-WCOM4A04:00: device returned incorrect report` (5-mal beim Start): Wacom-Digitizer beim Initialisieren, harmlos, wenn Stift und Touch funktionieren (in Phase 5.2 testen).
    - [ ] `soundwire_intel ... Bus clash` und `Clock stop failed -110`: SoundWire-Audio beim Start bzw. beim ersten Energiesparen. Harmlos, wenn Lautsprecher und Mikrofon nach dem Start und nach dem Aufwachen funktionieren, das einmal testen.
    - [x] `dbus-broker-launch: Ignoring duplicate name ...`: wie auf dem Desktop, Kosmetik.
  - [ ] Dasselbe auf Framework, Server1 und ServerPublic prüfen und hier ergänzen
- [X] 13.6 Die Images von networkingtoolbox und ComfyUI sind per Digest in `pkgs/images.json` gepinnt. Aktualisieren: `nix run .#update-images`, siehe [`docs/updates-and-vulnerabilities.md`](docs/updates-and-vulnerabilities.md).
- [X] 13.8 Registrierungen: Linkwarden (`enableRegistration = false`) und HomeBox (`allowRegistration` ist seit 08.11.2026 aus, Standard des Moduls) sind zu. Neue Konten in HomeBox nur noch, indem du die Option kurz einschaltest, das Konto anlegst und sie wieder ausschaltest.

- [ ] 13.8a HomeBox-Mailadresse ändern: Die Oberfläche kann das nicht (die Profilseite zeigt Name und Mail nur an), die API schon (`PUT /api/v1/users/self`). Auf dem Desktop, Passwort aus dem KeePassXC-Eintrag „HomeBox“, die alte Mailadresse ist dein Benutzername (ungetestet, bei einem Fehler die Ausgabe an Claude):

  ```
  u=https://homebox.<homeDomain>/api/v1
  read -rp "Bisherige Mailadresse: " old; read -rp "Neue Mailadresse: " new; read -rp "Anzeigename: " name; read -rsp "HomeBox-Passwort: " pw; echo
  t=$(nix run nixpkgs#jq -- -n --arg u "$old" --arg p "$pw" '{username: $u, password: $p}' | curl -fsS -H 'Content-Type: application/json' -d @- "$u/users/login" | nix run nixpkgs#jq -- -r .token); unset pw
  nix run nixpkgs#jq -- -n --arg n "$name" --arg e "$new" '{name: $n, email: $e}' | curl -fsS -X PUT -H "Authorization: $t" -H 'Content-Type: application/json' -d @- "$u/users/self"; echo
  ```

  Danach in KeePassXC beim Eintrag „HomeBox“ den Benutzernamen auf die neue Adresse ändern und neu anmelden.

- [ ] 13.12 Glance-Widgets einschalten: API-Keys in sops `glance` ergänzen, dann in `hosts/NixOS-Server1/server.nix` unter `glance` einschalten:
  - [ ] Jellyfin: Dashboard → API-Schlüssel, `ENV_JELLYFIN_TOKEN=`, `jellyfin.enable`
  - [ ] Sonarr und Radarr: Einstellungen → Allgemein, `ENV_SONARR_KEY=`, `ENV_RADARR_KEY=`, `calendar.enable`
  - [X] Pi-hole: App-Passwort steht seit 7.8a in `pihole/env` und `glance`. Miniflux: seit 8.8a an.
  - [ ] Home Assistant: Profil → langlebiges Token, `ENV_HA_TOKEN=`, `homeassistant.enable` und `homeassistant.entities`
- [ ] 13.14 CVE-Kandidaten sichten: Dashboard „Security and Updates“. Geprüfte False Positives in `nixos.system.vulnscan.ignore` eintragen.
- [ ] 13.24 ClamAV prüfen (seit 06.11.2026: nachts nur neue und geänderte Dateien, am 1. des Monats alles, niedrigste Priorität mit 2 Threads, clamd auf den Servern nur während des Scans, siehe [`docs/updates-and-vulnerabilities.md`](docs/updates-and-vulnerabilities.md)):
  - [ ] Zuerst auf Server1 wieder freigeben, falls noch gesperrt (am 06.11.2026 von Hand mit `mask --runtime --now` gestoppt, die Sperre hält bis zum nächsten Neustart). Prüfen mit `systemctl list-units --all 'clam*'`: Steht dort `masked`, freigeben mit `sudo systemctl unmask --runtime clamdscan.timer clamdscan.service clamav-daemon.socket clamav-daemon.service clamav-freshclam.timer clamav-freshclam.service` und `sudo systemctl start clamav-daemon.socket clamdscan.timer clamav-freshclam.timer`. Der Timer ist `Persistent`: Hat er einen Lauf verpasst, startet der Scan sofort. Soll er erst um 04:00 laufen, den Timer erst nach dem verpassten Termin starten.
  - [ ] Auf jedem Host einmal `sudo clamdscan-metrics full` (legt den Zeitstempel für die nächtlichen Läufe an, dauert auf Server1 viele Stunden, stört aber kaum noch). Danach im Dashboard „Security and Updates“ die Zeilen „Infected files“, „ClamAV findings“ und „Last ClamAV scan“. Alarme: `MalwareFound` (Fund) und `MalwareScanStale` (älter als 3 Tage).
  - [ ] Nach der nächsten Nacht: `journalctl -u clamdscan -b` zeigt einen kurzen Lauf, `grep changed_files /var/lib/prometheus-node-exporter/clamav.prom` die Zahl der neuen Dateien. Auf Server1 läuft clamd danach nicht mehr (`systemctl is-active clamav-daemon` → `inactive`).
  - [ ] On-Access auf jedem Client: die EICAR-Testdatei (harmlos, jeder Scanner erkennt sie) in den Download-Ordner legen, `curl -o ~/Downloads/eicar.com https://secure.eicar.org/eicar.com` (auf dem Desktop `/mount/Data/Datein/Downloads`), dann `cat` auf die Datei: Es muss „Operation not permitted“ kommen, im Journal `journalctl -u clamav-clamonacc` steht der Fund. Danach die Datei mit `sudo rm` löschen. Kommt kein Block, `systemctl status clamav-clamonacc` ansehen.
  - [ ] Funde auf Server1 (Stand 08.11.2026, 17 Dateien) selbst ansehen und entscheiden. Wie du davon erfährst: Jeder Scan schreibt die Funde als Metrik (`clamav_infected_file`, mit Pfad und Signatur) für Prometheus. Grafana zeigt sie im Dashboard „Security and Updates“, der Alarm `MalwareFound` geht über Alertmanager an ntfy und Mail, sobald Phase 10 eingerichtet ist (bis dahin nur das Dashboard). Was die Dateien sind:
    - `Papa File Share/Backup/ctnotwin/…`: `Pecmd.exe` (3-mal), `Imdisk_x86.7z`, `SetupImgBurn.exe` und `ImgBurn/$PLUGINSDIR/Fusion.dll`. Teile eines Bauprojekts für ein Windows-Notfallsystem (Win10XPE) und der ImgBurn-Installer. Solche Werkzeuge werden oft pauschal gemeldet (`Genericrxto`, `Autoit`, `Trojan.Generic`), der ImgBurn-Installer enthielt früher gebündelte Werbesoftware. Wahrscheinlich keine echte Schadsoftware, aber nicht ausführen.
    - `Software/Test  + Tools/ccsetup604.zip` (CCleaner 6.04, Signatur `Pikabot`) und `winlirc-0.8.7a.zip` (Signatur `Zeus`): alte Installer, vermutlich Fehlalarme. CCleaner hatte 2017 in Version 5.33 tatsächlich Schadcode, deshalb lieber löschen und bei Bedarf neu laden.
    - `Disketten_Digitalisierung/Have-Fun/have_fun.zip` (`Win.Joke`): ein altes Scherzprogramm von Diskette, harmlos, aber nutzlos.
    - Phishing-Mails in alten Mail-Kopien: `Papa File Share/Outlook Export/…/PC-Infos`, Melis Thunderbird-Kopie unter `Papa File Share/TFLapLatitudeE5570/Meli/…` (Cache und Ordner `PC-Infos`, `Trash`) und deine Sicherungen unter `jf/Dokumente/Wichtige Datein/Mail/…`. Dieselbe Mail wie auf dem Desktop (13.25).
    - Liste mit allen Pfaden: `ssh admin@NixOS-Server1 "grep -o 'path=\"[^\"]*\"' /var/lib/prometheus-node-exporter/clamav.prom | cut -d'\"' -f2"`.
    - Löschen, je Datei nach dem Ansehen: `ssh -t admin@NixOS-Server1 'sudo rm -v "/pool01/shares/document/Software/Test  + Tools/ccsetup604.zip"'` (Pfad aus der Liste, in Anführungszeichen wegen der Leerzeichen). Ganze Ordner nur löschen, wenn du sicher bist, dass sie nichts anderes enthalten: `sudo rm -rv "/pool01/shares/document/Papa File Share/Backup/ctnotwin"`. Nach dem nächsten nächtlichen Scan verschwinden die Einträge aus dem Dashboard.

- [ ] 13.25 ClamAV-Funde auf dem Desktop (13 Treffer, ausgewertet am 08.11.2026):
  - [ ] Die Phishing-Mail ist die Mail „LCD Ansteuerung“ vom 07.03.2003 von „Freund Torsten“ (Torsten.Freund@comverse.com) im 1&1-Ordner `TF-Mails/PC-Infos`, dazu ihre Kopien in `Wichtige Datein/Mail/2025-06-09 .thunderbird/…` und `…/2025-09-01 .thunderbird/…`. Eine 23 Jahre alte Arbeitsmail, die Signatur `Email.Phishing.VOF1` ist bei so alten Mails sehr wahrscheinlich ein Fehlalarm. In Thunderbird ansehen, Links nicht anklicken, behalten oder löschen. Die Kopien in den Sicherungen meldet ClamAV weiter, solange sie dort liegen. Der Fund `Heuristics.Phishing.Email.SpoofedDomain` im Proton-Export (`proton-mail-export-cli-linux_x86_64/…/ChQ6IPtAFAbH….eml`) ist eine einzelne Mail mit gefälschtem Absender, ansehen und löschen.
  - [ ] `Win.Trojan.Virut-248` in `d3d11.dll` (32 Bit) von DXVK: Heroic (`~/.config/heroic/tools/dxvk/dxvk-3.0`, `-3.0.2`, `-3.1`, `-3.1.1`, je `x32/d3d11.dll`), der winetricks-Cache (`~/.local/cache/winetricks/dxvk/dxvk-3.1.1.tar.gz`) und der Fusion-Prefix (fällt mit 27.5 weg). Sehr wahrscheinlich ein Fehlalarm, die Datei kommt aus unabhängigen Quellen und ist immer dieselbe. Prüfen: `sha256sum ~/.config/heroic/tools/dxvk/dxvk-3.1.1/x32/d3d11.dll`, den Hash auf virustotal.com suchen (nur den Hash, die Datei nicht hochladen). Bei Fehlalarm Claude Bescheid geben, dann kommt eine Option `ignoreSignatures` in `nixosModules/system/clamav.nix` (schreibt `local.ign2`).
  - [ ] Die alten DXVK-Versionen braucht Heroic nicht. Die Spiele und ihre Prefixe liegen woanders, Heroic lädt fehlende DXVK-Versionen bei Bedarf neu: `rm -r ~/.config/heroic/tools/dxvk/dxvk-3.0 ~/.config/heroic/tools/dxvk/dxvk-3.0.2 ~/.config/heroic/tools/dxvk/dxvk-3.1`. Der winetricks-Cache ist nur ein Download-Cache: `rm -r ~/.local/cache/winetricks/dxvk`.

- [ ] 13.27 Jellyfin transkodiert auf der CPU statt auf der Intel Arc (06.11.2026: 4K-HDR-Film ruckelt, Jellyfin zieht über 13 Kerne). Das Journal zeigt `libx264` und `tonemapx`, also Software. Ursache: `forceEncodingConfig = false` in `nixosModules/server/entertainment/jellyfin.nix`. NixOS schreibt die Einstellungen (QSV, `/dev/dri/renderD129`) nur, wenn noch keine `encoding.xml` existiert, die alte Datei gewinnt.
  - [ ] Sofort von Hand (erledigt, sobald das Dashboard QSV zeigt): Dashboard → Wiedergabe → Transkodierung → QSV, Gerät `/dev/dri/renderD129`, Hardware-Dekodierung für alle Formate, Hardware-Kodierung und Tone-Mapping an. Die Low-Power-Haken braucht es nicht: Arc-Karten (DG2) können nur Low-Power-Encoding und nutzen es von selbst (Jellyfin-Doku, Abschnitt Intel).
  - [ ] Prüfen: Film neu starten, im Dashboard unter Aktivität bzw. im Journal (`journalctl -u jellyfin -f`) muss `h264_qsv` oder `hevc_qsv` statt `libx264` stehen. `sudo intel_gpu_top -d drm:/dev/dri/renderD129` zeigt Last auf „Video“. HuC-Firmware (nötig für Low-Power): `sudo cat /sys/kernel/debug/dri/*/gt0/uc/huc_info` ohne `FAIL`/`ERROR`. Treiber (`intel-media-driver`, `vpl-gpu-rt`, `intel-compute-runtime` für OpenCL-Tone-Mapping) liefert schon `nixosModules/hardware/intelgpu.nix`.
  - [X] Dauerhaft: bleibt ein Handgriff nach der Installation, steht in `Notes/Post-Installation.md` (Abschnitt „Jellyfin (NixOS-Server1)“). `forceEncodingConfig = true` nicht setzen, das funktionierte im Test nicht richtig.
  - [ ] Trickplay (Vorschaubilder beim Spulen) rechnet für 4K-HDR ebenfalls auf der CPU und lief parallel zum Film. Mit QSV prüfen, ob es die Grafikkarte nutzt (Dashboard → Wiedergabe → Trickplay → „Hardware-Dekodierung“ und „Hardware-Kodierung“). Sonst nur nachts laufen lassen (Dashboard → Geplante Aufgaben → „Trickplay-Bilder generieren“ → Zeitplan) oder pro Bibliothek abschalten.
- [ ] 13.28 Radarr hat am 06.11.2026 zwischen 16:58 und 17:19 in 785 Filmordnern 3808 Dateien endgültig gelöscht (`folder.jpg`, `backdrop.jpg`, `logo.png`, `landscape.jpg`, `movie.nfo`, alle von Jellyfin). Ablauf laut Journal und Quellcode: Der Scan hielt die schon bekannten Filmdateien für neu („Assigning file … to movie“), ersetzte den alten Datenbankeintrag (`DeleteMediaFileReason.ManualOverride`), und dabei löscht Radarr alle Extra-Dateien, die an diesem Eintrag hängen. Die Bilder von Jellyfin hatte Radarr vorher als Extra-Dateien übernommen.
  - [X] (erledigt bis 08.11.2026) Bilder zurückholen: Der ZFS-Snapshot `pool01/shares/video@2026.05.14-10.39.43` enthält 3693 der 3808 gelöschten Dateien, mit den von Hand gewählten Bildern (Stand Mai). Nur fehlende Dateien kopieren, nichts überschreiben (Befehl siehe unten). Erst danach in Jellyfin die Bibliothek mit „Nach fehlenden Metadaten suchen“ aktualisieren, nie mit „Vorhandene Bilder ersetzen“, das überschreibt die zurückgeholten Bilder. Die restlichen 115 Dateien gehören zu Filmen ab Mai, dort neu wählen.

    ```
    sudo bash -c 'snap=/pool01/shares/video/.zfs/snapshot/2026.05.14-10.39.43; n=0; while IFS= read -r p; do src="$snap/${p#/pool01/shares/video/}"; if [ ! -e "$p" ] && [ -e "$src" ]; then cp -p "$src" "$p" && chown jellyfin:share "$p" && chmod 660 "$p" && n=$((n+1)); fi; done < <(journalctl -u radarr --since "2026-11-06 16:58" --until "2026-11-06 17:20" -o cat | grep "deleting permanently" | sed "s/.*deleting permanently\. //" | sort -u); echo "$n Dateien zurückgeholt"'
    ```

  - [X] Snapshots für alle Datasets: seit 08.11.2026 `services.zfs.autoSnapshot` in `hosts/NixOS-Server1/zfsmount.nix` (täglich 7, wöchentlich 4, monatlich 3), einschalten und den Mai-Snapshot löschen in 27.4 und 27.5.
  - [ ] Ursache klären: Warum hielt Radarr fast alle Dateien für neu? Es vergleicht nur den Pfad (Filmordner + relativer Pfad). Prüfen, ob sich am 06.11. kurz vor 16:58 Stammordner oder Filmpfade in Radarr geändert haben (Film-Editor, Bibliotheksimport).
  - [ ] Vorbeugen: In Jellyfin pro Bibliothek „Bilder in Medienordnern speichern“ ausschalten, dann liegen die Bilder im Datenordner von Jellyfin, wo Radarr nicht hinkommt. In Radarr unter Einstellungen → Medienverwaltung „Zusätzliche Dateien importieren“ aus oder `jpg`, `png`, `nfo` aus der Liste nehmen und einen Papierkorb setzen, damit Gelöschtes wiederherstellbar ist. Dasselbe in Sonarr prüfen.
- [ ] 13.29 Ollama- und ComfyUI-Modelle aussortieren (Auswahl vom 07.11.2026). Server1 hat einen Ryzen 5 7600, 124 GB RAM und eine Arc A310 mit 4 GB. Große Modelle laufen deshalb fast ganz auf der CPU, dort sind nur MoE-Modelle mit wenigen aktiven Parametern schnell.
  - [X] Ollama, im Code seit 08.11.2026: In `nixosModules/server/tools/ollama.nix` ist der Default von `models` jetzt `gemma4:26b-a4b` (18 GB, MoE, 4B aktiv), `gemma4:e4b` (6,6 GB), `qwen3.5:4b` (3,3 GB, passt ganz auf die A310) und `qwen3.6:35b-a3b` (23 GB, MoE, 3B aktiv, Hauptmodell). Wegen `syncModels = true` löscht `ollama-model-loader` beim Deploy alle anderen (deepseek-r1, gemma3, gpt-oss:20b, llama3.1/3.2, nemotron-3-nano, qwen3.5 9b/27b/35b, zusammen etwa 160 GB) und lädt die neuen (etwa 51 GB). Der Portable behält `qwen3.5:4b`.
  - [ ] Nach dem Deploy (27.3) prüfen:

    ```
    nixos-rebuild switch --flake .#NixOS-Server1 --build-host admin@NixOS-Server1 --target-host admin@NixOS-Server1 --sudo --ask-sudo-password
    ssh admin@NixOS-Server1 'journalctl -u ollama-model-loader -b --no-pager | tail -20; ollama list'
    ```

  - [ ] IPv6 prüfen: Mullvad lehnte Verbindungen zu IPv6-Adressen ab, der Loader brach deshalb 486-mal mit `connection refused` ab (Cloudflare-Speicher von Ollama) und startete ständig neu. Seit 08.11.2026 setzt `nixosModules/server/network/mullvad-server.nix` `mullvad tunnel set ipv6 on`. Nach dem Deploy:

    ```
    ssh admin@NixOS-Server1 'mullvad tunnel get | grep IPv6; curl -6 -s -o /dev/null -w "%{http_code}\n" https://registry.ollama.ai/v2/; systemctl show ollama-model-loader -p NRestarts -p ActiveState; journalctl -u ollama-model-loader -b --no-pager -o cat | grep -c "connection refused"'
    ```

    Erwartet: `IPv6: on`, `404` (Server erreichbar), der Loader endet ohne Neustarts, 0 Treffer. Danach schauen, ob andere Dienste mit IPv6 Probleme haben: `journalctl -b -p warning --no-pager | grep -iE "network is unreachable|connection refused|\[[0-9a-f:]+\]:[0-9]+" | tail -30`, und ob `curl -6 https://ifconfig.co` eine Adresse von Mullvad zeigt, nicht die der Fritzbox.

  - [ ] ComfyUI: In der Oberfläche Manager → Custom Nodes Manager → `ComfyUI-GGUF` (city96) installieren und ComfyUI neu starten. Ohne den Knoten lassen sich die `.gguf`-Dateien nicht laden. Die Knoten liegen unter `storage/ComfyUI/custom_nodes` und bleiben erhalten.
  - [ ] ComfyUI-Modelle laden (Z-Image Turbo und FLUX.2 klein 4B, beide Apache 2.0, zusammen etwa 7 GB):

    ```
    ssh -t admin@NixOS-Server1 sudo bash -c '"
    m=/pool01/applications/comfyui/models; hf=https://huggingface.co
    mkdir -p \$m/diffusion_models \$m/text_encoders \$m/vae
    curl -fL -o \$m/diffusion_models/z-image-turbo-Q4_K_M.gguf \$hf/unsloth/Z-Image-Turbo-GGUF/resolve/main/z-image-turbo-Q4_K_M.gguf
    curl -fL -o \$m/diffusion_models/flux-2-klein-4b-Q4_K_M.gguf \$hf/unsloth/FLUX.2-klein-4B-GGUF/resolve/main/flux-2-klein-4b-Q4_K_M.gguf
    curl -fL -o \$m/text_encoders/Qwen3-4B-Q4_K_M.gguf \$hf/unsloth/Qwen3-4B-GGUF/resolve/main/Qwen3-4B-Q4_K_M.gguf
    curl -fL -o \$m/vae/ae.safetensors \$hf/Comfy-Org/Z-Image-Turbo/resolve/main/split_files/vae/ae.safetensors
    curl -fL -o \$m/vae/flux2-vae.safetensors \$hf/Comfy-Org/Flux-2-Klein-4B/resolve/main/split_files/vae/flux2-vae.safetensors
    "'
    ```

  - [ ] Workflow: „Unet Loader (GGUF)“ mit dem Modell, „CLIPLoader (GGUF)“ mit `Qwen3-4B-Q4_K_M.gguf` (Typ `lumina2` für Z-Image, `flux2` für FLUX.2), „Load VAE“ mit `ae.safetensors` bzw. `flux2-vae.safetensors`. Z-Image Turbo: 8 Schritte, CFG 1. FLUX.2 klein: 4 Schritte. Lehnt der GGUF-Loader den Text-Encoder ab, stattdessen `qwen_3_4b.safetensors` (8 GB) aus `Comfy-Org/Z-Image-Turbo`, `split_files/text_encoders` nach `text_encoders` laden, beide Modelle nutzen ihn.
  - [ ] Alte Checkpoints aussortieren: `ssh -t admin@NixOS-Server1 'sudo du -sh /pool01/applications/comfyui/models/*/*'` zeigt, was noch liegt, alles außer den Dateien oben löschen.
  - [ ] Ollama und ComfyUI teilen sich die 4 GB der A310. Prüfen, ob ein Bild langsamer wird oder mit Speichermangel abbricht, solange Ollama ein Modell geladen hat (`ollama ps`, Ollama entlädt nach 5 Minuten ohne Anfrage). Falls ja, `OLLAMA_KEEP_ALIVE` kürzer setzen.
- [ ] 13.30 Reste der persistierten `/etc/ssh` löschen (seit 08.11.2026 liest sshd die Schlüssel direkt aus `/persistent/etc/ssh`). Auf jedem Rechner erst nach dem Deploy mit der neuen `ssh.nix`, vorher würde sshd seine Konfiguration verlieren. Betroffen: Framework, Convertible, Portable, Server1 (Desktop am 08.11.2026 geprüft, dort liegen nur noch die Host-Keys; ServerPublic und ServerGaming sind neu installiert). Auf dem jeweiligen Rechner:

    ```
    if findmnt /etc/ssh >/dev/null; then echo "noch alte Konfiguration, erst deployen"; else sudo rm -rv /persistent/etc/ssh/sshd_config /persistent/etc/ssh/ssh_config /persistent/etc/ssh/ssh_known_hosts /persistent/etc/ssh/authorized_keys.d; fi
    sudo ls -la /persistent/etc/ssh
    ```

    Übrig bleiben nur `ssh_host_*` und, wo vorhanden, `initrd_host_key*`. Danach mit einer neuen Verbindung `ssh` testen. Für Server1 vom Desktop: `ssh -t admin@NixOS-Server1 '<die Zeilen oben>'`.

- [ ] 13.31 SSH auf die VPS ohne WireGuard (08.11.2026): Bisher sollte SSH auf ServerPublic und ServerGaming nur noch auf der Tunnel-Adresse lauschen, sobald WireGuard steht, und die Namen `NixOS-ServerPublic`/`NixOS-ServerGaming` zeigten auf `10.100.0.1`/`10.100.0.6`. Jetzt lauscht sshd immer auf allen Adressen (Port 22, Schlüssel only, sshguard), die Namen zeigen auf die öffentlichen Adressen aus `$PRIV/site.nix` (`networking.hosts` in `nixosModules/system/networking.nix`). Entfernt im Code: `nixos.system.ssh.listenAddresses`, `nixos.system.wireguard.enrolled`, `nixos.system.wireguard.hasPeers`, die Zeilen dazu in `hosts/NixOS-ServerPublic/configuration.nix` und `hosts/NixOS-ServerGaming/configuration.nix`.
  - [ ] Deployen: Desktop `sudo nixos-rebuild switch --flake .#NixOS-Desktop`, Framework und Convertible ebenso lokal, Server1 `nixos-rebuild switch --flake .#NixOS-Server1 --build-host admin@NixOS-Server1 --target-host admin@NixOS-Server1 --sudo --ask-sudo-password`, ServerPublic `nixos-rebuild switch --flake .#NixOS-ServerPublic --build-host admin@<ipv4> --target-host admin@<ipv4> --sudo --ask-sudo-password`.
  - [ ] Prüfen vom Desktop: `getent hosts NixOS-ServerPublic` zeigt die öffentlichen Adressen, `ssh admin@NixOS-ServerPublic true` geht (beim ersten Mal den Host-Key mit dem Fingerprint in „Login NixOS-ServerPublic“ vergleichen und annehmen).
  - [ ] Händisch löschen: nichts. Die Beschränkung war nie aktiv (ServerPublic hatte noch keine Peers, ServerGaming ist noch nicht installiert), auf keinem Host liegt ein Rest. Die Regel `ssh` (22) in den Contabo-Firewalls bleibt stehen, nicht löschen.

## Phase 9 – WireGuard und Backups
- [ ] 8.18 WireGuard für ServerGaming, erst wenn 9.1 erledigt ist und vom Desktop `ping 10.100.0.1` geht: In `nixosModules/system/wireguard.nix` bei `NixOS-ServerGaming` die Zeile `publicKey = null;` durch `publicKey = "tcO5iL+oBwtgfpuyv0BDmKygMUNoXS2whRYdrcJtcVk=";` ersetzen (abgeleitet aus dem privaten Schlüssel in sops, 07.11.2026). Zuerst ServerPublic deployen (`nixos-rebuild switch --flake .#NixOS-ServerPublic --build-host admin@NixOS-ServerPublic --target-host admin@NixOS-ServerPublic --sudo --ask-sudo-password`), dann ServerGaming über seine öffentliche IP (`nixos-rebuild switch --flake .#NixOS-ServerGaming --build-host admin@<ipv4> --target-host admin@<ipv4> --sudo --ask-sudo-password`, die alte Sitzung hält dabei). SSH bleibt direkt erreichbar, an der Firewall ändert sich nichts. Prüfen: auf ServerPublic `sudo wg show` zeigt bei ServerGaming einen „latest handshake“, vom Desktop geht `ping -c 3 10.100.0.6`.
- [ ] 8.19 Restic-Zugang von ServerGaming auf Server1, erst mit 9.3: Das Passwort steht in „restic REST nixos-servergaming“ (Tabelle 9A). `nix shell nixpkgs#apacheHttpd -c htpasswd -B -n nixos-servergaming`, Passwort aus dem Eintrag einfügen, die ausgegebene Zeile `nixos-servergaming:$2y$…` mit `cd ~/Documents/nixos-private/secrets && sops nixos-server1.yaml` unter `resticserver/htpasswd` als neue Zeile ergänzen. Privates Repo committen, `cd ~/Documents/nixos && nix flake update private`, Server1 deployen: `nixos-rebuild switch --flake .#NixOS-Server1 --build-host admin@NixOS-Server1 --target-host admin@NixOS-Server1 --sudo --ask-sudo-password`. Prüfen: `ssh admin@NixOS-ServerGaming sudo systemctl start restic-backups-home` und danach `systemctl status restic-backups-home` ohne Fehler.

- [ ] 9.1 WireGuard einschalten. Die privaten Schlüssel aller Peers stehen seit 07.11.2026 in sops (`wireguard/<hostname klein>/private`) und in KeePassXC, GrapheneOS folgt in 23.1. Portable ist kein Peer.
  - [ ] In `nixosModules/system/wireguard.nix` bei den Peers jeweils `publicKey = null;` ersetzen (oder mir sagen, dass es losgeht):

    ```
    NixOS-Server1      publicKey = "u7uWZXVqbPSsfByc6KJX+PQDNSf4wkxzzw3LyY3w4Ew=";
    NixOS-Desktop      publicKey = "yqjMjIpctn+KX2gr3YOubZhquNdGSQzcnqTkD7heWGo=";
    NixOS-Framework    publicKey = "YIjtq3TGq6VlHKt4K5G9BWSc0OQfoRes38iXGWga2wY=";
    NixOS-Convertible  publicKey = "I4znLKv4z2FrHwN23QmldPQyYgMOyAyl7sI71Mi2QFk=";
    ```

    ServerGaming noch nicht, das ist 8.18.
  - [ ] In `hosts/NixOS-Server1/configuration.nix`, `hosts/NixOS-Desktop/configuration.nix`, `hosts/NixOS-Framework/configuration.nix` und `hosts/NixOS-Convertible/configuration.nix` je die Zeile `nixos.system.wireguard.enable = true;` unter `nixos.system.sops.file = …;` ergänzen.
  - [ ] Bauen: `cd ~/Documents/nixos && for h in NixOS-Desktop NixOS-Server1 NixOS-ServerPublic NixOS-Framework NixOS-Convertible; do nix build --no-link .#nixosConfigurations.$h.config.system.build.toplevel && echo "OK $h"; done`
  - [ ] Reihenfolge beim Deployen (SSH bleibt direkt erreichbar, der Tunnel betrifft nur Backups, Monitoring, Pi-hole und die internen Dienste):
    1. Desktop: `sudo nixos-rebuild switch --flake .#NixOS-Desktop`
    2. ServerPublic über die öffentliche IP: `nixos-rebuild switch --flake .#NixOS-ServerPublic --build-host admin@<ipv4> --target-host admin@<ipv4> --sudo --ask-sudo-password`
    3. Prüfen vom Desktop: `ping -c 3 10.100.0.1`. Geht das nicht, auf ServerPublic `sudo wg show` und `journalctl -u wireguard-wg0 -b` ansehen, oder zurückrollen: `ssh -t admin@NixOS-ServerPublic sudo nixos-rebuild switch --rollback`.
    4. Server1: `nixos-rebuild switch --flake .#NixOS-Server1 --build-host admin@NixOS-Server1 --target-host admin@NixOS-Server1 --sudo --ask-sudo-password`
    5. Framework und Convertible jeweils lokal: `sudo nixos-rebuild switch --flake .#NixOS-Framework` bzw. `sudo nixos-rebuild switch --flake .#NixOS-Convertible`
  - [ ] Prüfen: auf ServerPublic `sudo wg show` zeigt bei Server1, Desktop, Framework und Convertible einen „latest handshake“. Von jedem Client `ping -c 3 10.100.0.2` (Server1 durch den Tunnel).
- [ ] 9.2 Den Mullvad-Bypass auf Server1 prüfen: `nft list table inet wgMullvadBypass`, `wg show`.
- [ ] 9.2a restic-Werte aller Hosts neu nach Tabelle 9A, bevor 9.3 den rest-server einschaltet. Bis dahin gibt es kein Repository, `restic/password` ist also noch frei wählbar und die alten Werte richten keinen Schaden an. Auf den VPS bleiben bis hierhin die alten Werte aus der Installation stehen, ihre Backups scheitern, solange der rest-server aus ist.
- [ ] 9.3 `nixos.server.sync.resticserver` auf Server1 aktivieren. Secret `resticserver/htpasswd` mit dem Benutzer `nixos-serverpublic` und dem Passwort aus `restic/home-env` von ServerPublic anlegen (`htpasswd -B -n nixos-serverpublic`).
- [ ] 9.4 Proton-Drive-Backup von Server1 (`hosts/NixOS-Server1/backup.nix`, seit 08.11.2026 nur das Unersetzliche: `photo` komplett, `jf/Dokumente`, `document/Office Dokumente`, `document/Wiso Mein Geld`; Alarm `ResticRepositoryFull` ab 1,9 TB, der Duo-Speicher hat 2 TB). Vorher die Größe prüfen: `ssh -t admin@NixOS-Server1 'sudo du -shc /pool01/shares/photo /pool01/shares/jf/Dokumente "/pool01/shares/document/Office Dokumente" "/pool01/shares/document/Wiso Mein Geld"'`, liegt die Summe über 1,9 TB, zuerst aufräumen (9.7). Secrets: `restic/password` ist eine Passphrase, die du selbst festlegst und dir merkst (Notfallzugriff ohne eigene Geräte, `docs/proton-drive.md` → „Emergency access“): KeePassXC `NixOS/Server1` → „restic repository NixOS-Server1“ ins Passwortfeld, dann `cd ~/Documents/nixos-private/secrets && sops nixos-server1.yaml`, unter `restic:` die Zeile `password: <passphrase>`. `restic/rclone-proton` ist die rclone-Config mit `[proton]`, Typ `protondrive`, erstellt mit `rclone config` (Proton-Login mit 2FA), der Inhalt von `~/.config/rclone/rclone.conf` kommt unter `restic:` als `rclone-proton: |` (mehrzeilig, eingerückt). Danach in `backup.nix` `enable = true`, committen, deployen, den ersten Lauf starten (`ssh -t admin@NixOS-Server1 sudo systemctl start restic-backups-proton`, dauert bei 1,5 TB Tage) und einen Restore nach `docs/proton-drive.md` testen, auch einmal den Notfallweg von einem fremden Gerät aus. Notizfeld in KeePassXC (der Eintrag „restic repository NixOS-Server1“ steht in 9A):

  ```
  Proton:
  nixos-server1.yaml → restic/rclone-proton
  ```
- [ ] 9.5 Disaster-Recovery-Plan umsetzen ([`docs/disaster-recovery.md`](docs/disaster-recovery.md)):
  - [ ] Schlüssel-Liste offline sichern (Papier und zwei USB-Sticks)
  - [ ] LUKS-Header-Backups aller Platten: `cryptsetup luksHeaderBackup <dev> --header-backup-file <datei>`
  - [X] Videos: keine zweite Kopie (Entscheidung 08.11.2026), sie lassen sich wiederbeschaffen.
  - [X] Kopie der Repos außer Haus: Beide Repos liegen per Syncthing in `pool01/shares/jf`, das Proton-Backup von Server1 (9.4) sichert diesen Ordner verschlüsselt mit restic. Kein zusätzliches Remote nötig, kein Anbieter sieht `site.nix`. Prüfen nach 9.4: `restic snapshots` enthält `shares/jf/Dokumente/nixos-private`.
  - [ ] Wiederherstellung vierteljährlich testen (Testplan im Dokument)
- [X] 9.6 ZFS-Auto-Snapshots auf Server1: seit 08.11.2026 aktiv im Code (`hosts/NixOS-Server1/zfsmount.nix`), Einrichtung in 27.4.
- [ ] 9.7 Bald: `pool01/shares/document`, `pool01/shares/photo`, `pool01/shares/jf/Dokumente` und `pool01/shares/jf` insgesamt neu sortieren und aufräumen (Doppeltes, alte Sicherungen, Papas Ordner). Danach die Größe aus 9.4 neu prüfen, eventuell passt dann mehr ins Proton-Backup, und `zfsSubdirs` in `hosts/NixOS-Server1/backup.nix` an neue Ordnernamen anpassen (oder Claude Bescheid geben).

9A – restic-Werte (für 9.2a bis 9.4):

Was restic hier tut: ServerPublic und ServerGaming sichern ihre Daten jede Nacht verschlüsselt auf Server1 (rest-server, `rest:http://10.100.0.2:8000/<host>/`, nur über WireGuard erreichbar), Server1 sichert sich selbst zu Proton Drive. `restic/password` verschlüsselt das Backup-Repository, `restic/home-env` ist die Anmeldung am rest-server auf Server1, `resticserver/htpasswd` die Gegenseite dort. In `nixos-serverpublic.yaml` und `nixos-servergaming.yaml` stehen `restic/password` und `restic/home-env` noch aus der Vorlage (in der Sitzung mit Claude erzeugt). Sie bleiben bis 9.2a stehen, weil die Backups in der Konfiguration fest eingeschaltet sind und der Build sie verlangt. Bis Phase 9 läuft keine Sicherung (kein Tunnel, kein rest-server), es entsteht also nichts mit dem alten Passwort. Die KeePassXC-Einträge erst hier anlegen, Notizfeld:

```
restic repository NixOS-ServerPublic:
nixos-serverpublic.yaml → restic/password

restic repository NixOS-ServerGaming:
nixos-servergaming.yaml → restic/password

restic repository NixOS-Server1:
nixos-server1.yaml → restic/password

restic REST nixos-serverpublic:
nixos-serverpublic.yaml → restic/home-env (line RESTIC_REST_PASSWORD=)
nixos-server1.yaml → resticserver/htpasswd (line nixos-serverpublic:, bcrypt)

restic REST nixos-servergaming:
nixos-servergaming.yaml → restic/home-env (line RESTIC_REST_PASSWORD=)
nixos-server1.yaml → resticserver/htpasswd (line nixos-servergaming:, bcrypt)
```

| sops | KeePassXC (Gruppe → Titel) | KeePassXC-URL (Autofill) | Format | Erzeugen | Später beachten |
|---|---|---|---|---|---|
| `nixos-serverpublic.yaml` → `restic/password` | `NixOS/ServerPublic` → „restic repository NixOS-ServerPublic“ | keine | Repository-Passwort, nur der Wert | KeePassXC → Reiter „Passwort“, 128 Zeichen, nur A-Z, a-z, 0-9 | Frei wählbar, solange es das Repo nicht gibt. **Später nie nur in sops ändern**, sonst ist das Backup unlesbar: `restic key add`, prüfen, `restic key remove <alte-id>`, erst dann sops. |
| `nixos-serverpublic.yaml` → `restic/home-env` | `NixOS/Server1` → „restic REST nixos-serverpublic“ (derselbe Eintrag wie die Zeile in `resticserver/htpasswd`) | keine | zwei Zeilen: `RESTIC_REST_USERNAME=nixos-serverpublic`, `RESTIC_REST_PASSWORD=<passwort>` | KeePassXC → Reiter „Passwort“, 72 Zeichen, nur A-Z, a-z, 0-9 (auf Server1 als bcrypt-Zeile, bcrypt wertet nur 72 Bytes aus; keine `@ : /`, die brechen die Repository-URL) | muss zur Zeile in `resticserver/htpasswd` passen |
| `nixos-servergaming.yaml` → `restic/password` | `NixOS/ServerGaming` → „restic repository NixOS-ServerGaming“ | keine | Repository-Passwort | KeePassXC → Reiter „Passwort“, 128 Zeichen, nur A-Z, a-z, 0-9, eigener Wert | Frei wählbar, solange es das Repo nicht gibt. **Später nie nur in sops ändern**, sonst ist das Backup unlesbar: `restic key add`, prüfen, `restic key remove <alte-id>`, erst dann sops. |
| `nixos-servergaming.yaml` → `restic/home-env` | `NixOS/Server1` → „restic REST nixos-servergaming“ (derselbe Eintrag wie die Zeile in `resticserver/htpasswd`) | keine | zwei Zeilen: `RESTIC_REST_USERNAME=nixos-servergaming`, `RESTIC_REST_PASSWORD=<passwort>` | KeePassXC → Reiter „Passwort“, 72 Zeichen, nur A-Z, a-z, 0-9, eigener Wert (auf Server1 als bcrypt-Zeile, bcrypt wertet nur 72 Bytes aus; keine `@ : /`, die brechen die Repository-URL) | muss zur Zeile in `resticserver/htpasswd` passen: `nix shell nixpkgs#apacheHttpd -c htpasswd -B -n nixos-servergaming` |
| `nixos-server1.yaml` → `resticserver/htpasswd` | `NixOS/Server1` → „restic REST nixos-serverpublic“, „restic REST nixos-servergaming“ (dieselben Einträge wie bei `restic/home-env` der VPS) | keine | eine Zeile pro VPS, `<name>:$2y$…` | ServerPublic: `nix shell nixpkgs#apacheHttpd -c htpasswd -B -n nixos-serverpublic`, ServerGaming: `nix shell nixpkgs#apacheHttpd -c htpasswd -B -n nixos-servergaming`, jeweils das Passwort aus KeePassXC einfügen, die Ausgabe ist die Zeile | zusammen mit `restic/home-env` des jeweiligen VPS deployen |
| `nixos-server1.yaml` → `restic/password` (Proton Drive, 9.4) | `NixOS/Server1` → „restic repository NixOS-Server1“ | keine | Repository-Passwort | selbst festgelegte Passphrase, die du dir merkst (Entscheidung 08.11.2026, Notfallzugriff ohne eigene Geräte), zusätzlich auf dem Papier aus 9.5 | Frei wählbar, solange es das Repo nicht gibt. **Später nie nur in sops ändern**, sonst ist das Backup unlesbar: `restic key add`, prüfen, `restic key remove <alte-id>`, erst dann sops. |

## Phase 10 – Benachrichtigungen, Killswitch, Monitoring

- [ ] 10.1 Mail-Alarme: In Stalwart das Konto `alerts@<domain>` anlegen (Passwort zuerst in KeePassXC `NixOS/ServerPublic` → „Mailbox alerts@“, Benutzername `alerts@<domain>`, URL `https://mail.<domain>`, KeePassXC → Reiter „Passwort“, 128 Zeichen, nur A-Z, a-z, 0-9; lehnt der Dienst das ab, in KeePassXC auf das erlaubte Maximum kürzen und das im Notizfeld vermerken), pro Host das Secret `notify/mail-password` setzen und `nixos.system.notify.mail` einschalten. Notizfeld in KeePassXC (ohne Alarme auf Portable die Zeile mit `nixos-portable.yaml` weglassen):

  ```
  Mailbox alerts@:
  clients.yaml → notify/mail-password
  nixos-portable.yaml → notify/mail-password
  nixos-server1.yaml → notify/mail-password (also used by Alertmanager)
  nixos-serverpublic.yaml → notify/mail-password
  nixos-servergaming.yaml → notify/mail-password
  ```
- [ ] 10.2 ntfy auf ServerPublic: Secret `ntfy/env` mit `NTFY_AUTH_USERS`, `NTFY_AUTH_TOKENS` und `NTFY_AUTH_ACCESS` (muss `*:up*:write-only` enthalten), dann `nixos.server.public.ntfy.declarativeAuth` einschalten. Notizfeld in KeePassXC (die Tokens bekommen in 10.3 und 10.4 weitere Zeilen):

  ```
  ntfy jf:
  nixos-serverpublic.yaml → ntfy/env (line NTFY_AUTH_USERS=, bcrypt hash)
  ```
- [ ] 10.3 ntfy-Alarme pro Host: Secret `notify/ntfy-env` (`NTFY_TOKEN`, `ALERT_TOPIC`), dann `nixos.system.notify.ntfy` einschalten. Notizfeld in KeePassXC (ohne Alarme auf Portable die Zeile mit `nixos-portable.yaml` weglassen, `monitoring/…` kommt in 10.5):

  ```
  ntfy token alerts:
  nixos-serverpublic.yaml → ntfy/env (line NTFY_AUTH_TOKENS=)
  clients.yaml → notify/ntfy-env (line NTFY_TOKEN=)
  nixos-portable.yaml → notify/ntfy-env (line NTFY_TOKEN=)
  nixos-server1.yaml → notify/ntfy-env (line NTFY_TOKEN=)
  nixos-server1.yaml → monitoring/ntfy-token
  nixos-server1.yaml → monitoring/ntfy-url (ALERT_TOPIC in the URL)
  nixos-serverpublic.yaml → notify/ntfy-env (line NTFY_TOKEN=)
  nixos-servergaming.yaml → notify/ntfy-env (line NTFY_TOKEN=)
  ```
- [ ] 10.4 Killswitch: Pro Host das Secret `killswitch/env` (`NTFY_TOKEN` mit Leserecht, `KILLSWITCH_TOPIC`), dann `nixos.system.killswitch` einschalten (Server1 mit `delay = 60`). Dazu `killswitch/ha-env` (Schreib-Token) und `nixos.server.management.homeassistant.killswitch = true`, außerdem eine Button-Karte für `script.killswitch` mit Bestätigung im Dashboard. Notizfeld in KeePassXC (ohne Killswitch auf Portable die Zeile mit `nixos-portable.yaml` weglassen):

  ```
  ntfy token killswitch read:
  nixos-serverpublic.yaml → ntfy/env (line NTFY_AUTH_TOKENS=)
  clients.yaml → killswitch/env (line NTFY_TOKEN=)
  nixos-portable.yaml → killswitch/env (line NTFY_TOKEN=)
  nixos-server1.yaml → killswitch/env (line NTFY_TOKEN=)
  nixos-serverpublic.yaml → killswitch/env (line NTFY_TOKEN=)
  nixos-servergaming.yaml → killswitch/env (line NTFY_TOKEN=)

  ntfy token killswitch write:
  nixos-serverpublic.yaml → ntfy/env (line NTFY_AUTH_TOKENS=)
  nixos-server1.yaml → killswitch/ha-env
  ```
- [ ] 10.5 Grafana/Alertmanager: `nixos.server.management.monitoring.alerts.{ntfy,mail}` mit den Secrets `monitoring/ntfy-url` (`https://push.<domain>/<topic>?template=alertmanager`) und `monitoring/ntfy-token`. Pi-hole-Metriken mit `monitoring/pihole-env` (Zeile `PIHOLE_PASSWORD=<app-passwort aus „Pi-hole app password“>`). Keine neuen KeePassXC-Einträge: `monitoring/ntfy-token` und `monitoring/ntfy-url` stehen schon im Notizfeld von „ntfy token alerts“ (10.3), `monitoring/pihole-env` in dem von „Pi-hole app password“.
- [ ] 10.6 Den Loki-Alarm aus 6.7 testen (6.7 steht direkt unten).

- [ ] 6.7 Loki-Alarm „ExecOutsideNixStore“ testen: per ssh eine Kopie von `/run/current-system/sw/bin/true` nach `/tmp` legen und ausführen. Innerhalb von 5 Minuten muss ein Alarm kommen (nach Phase 10).
- [ ] 6.8 Glance prüfen: Seite „Server“ mit den Abschnitten pro Server. Die externen Server zeigen erst Daten, wenn WireGuard steht (Phase 9).
- [ ] 13.10 MollySocket (Entscheidung 08.11.2026: ja, nach 10.2, weil es ntfy braucht) (`nixos.server.public.mollysocket`, Secret `mollysocket/env`). KeePassXC `NixOS/ServerPublic` → „MollySocket VAPID“, ohne URL, Notizfeld:

  ```
  MollySocket VAPID:
  nixos-serverpublic.yaml → mollysocket/env (line MOLLY_VAPID_PRIVKEY=)
  ```
- [ ] 13.26 CVEs der Clients: Ergebnisse liegen jetzt in der Persistenz (`/var/lib/prometheus-node-exporter`), das Dashboard zeigt für nicht erreichbare Hosts den letzten Stand der letzten 14 Tage. Prüfen: auf einem Laptop `sudo systemctl start vulnscan`, danach erscheint er im Dashboard, auch nachdem er wieder aus ist. Voraussetzung ist, dass Prometheus den Laptop erreicht (LAN oder WireGuard, Phase 9).
## Phase 11 – Mail, PGP, JMAP

Ausführlich in [`docs/mail-pgp-jmap.md`](docs/mail-pgp-jmap.md).

- [ ] 11.1 Den PGP-Schlüssel erzeugen oder den vorhandenen verwenden. Den Public Key nach `$PRIV/pgp/public.asc` legen und `pgpFingerprint` in `site.nix` setzen (Entscheidung 08.11.2026: PGP komplett, mit WKD und Encryption at Rest).
- [ ] 11.2 Den DNS-Eintrag `openpgpkey.<domain>` anlegen, ServerPublic neu bauen und WKD prüfen: `gpg --auto-key-locate clear,wkd --locate-keys <adresse>`.
- [ ] 11.3 Stalwart Encryption at Rest, erst nach 11.4 und erst, wenn auch das Handy PGP entschlüsseln kann (sonst sind neue Mails dort unlesbar). Was es tut: Stalwart verschlüsselt jede eingehende Mail mit deinem Public Key, bevor es sie speichert. Lesen kann sie nur ein Programm mit dem geheimen Schlüssel (Thunderbird, das Handy). Das schützt gegen jeden, der die Platte oder ein Backup liest (Contabo, das restic-Repo auf Server1, ein gestohlener Datenträger). Nicht geschützt ist die Mail auf dem Weg zum Server und im Speicher während des Empfangs. Nachteile: Die Suche auf dem Server findet im Text nichts mehr, Programme ohne Schlüssel zeigen nur einen verschlüsselten Anhang, Mails von vor dem Einschalten bleiben unverschlüsselt. Einstellung pro Konto, nicht in NixOS:
  1. Als `jf@<domain>` auf `https://stalwart.<domain>` anmelden → Account → Encryption at rest.
  2. Methode „OpenPGP“, Algorithmus „AES256“, den Public Key aus `$PRIV/pgp/public.asc` einfügen (Inhalt mit `-----BEGIN PGP PUBLIC KEY BLOCK-----`), speichern.
  3. Prüfen: eine Mail von außen an `jf@<domain>` schicken. Thunderbird zeigt sie mit PGP-Schloss und entschlüsselt sie, am Handy ebenso.
  4. `alerts@` (10.1) und `mailadmin` nicht verschlüsseln.
- [ ] 11.4 Thunderbird: Den geheimen Schlüssel importieren oder per GnuPG/Smartcard nutzen. Das Konto, die Signatur und CalDAV/CardDAV kommen deklarativ.
- [ ] 11.5 Thunderbird: Proton (Hauptkonto über die Bridge), Stalwart, DLRG und 1&1 kommen deklarativ aus `mailAccounts` und `mailAddress`, angezeigt werden sie mit ihrer Adresse. Einmalig: Bridge einrichten (`systemctl --user stop protonmail-bridge`, `protonmail-bridge --cli`, `login`, `info` zeigt das Bridge-Passwort) und deren Zertifikat in Thunderbird bestätigen, je Konto das Passwort eingeben. Zu prüfen: DLRG `mail.dlrg.de` (Quelle ist das DLRG-Wiki) und 1&1 `imap.1und1.de`/`smtp.1und1.de`, beide nicht getestet. Die Add-ons LanguageTool und CardBook bleiben manuell (siehe `Notes/Post-Installation.md`). In CardBook unter Einstellungen → Thunderbird den Haken „Spalten hinzufügen“ entfernen, sonst erscheinen in jedem Ordner die Spalten From (CB), Recipient (CB) und Correspondents (CB). Die Einstellung liegt in der Datenbank des Add-ons, nicht in der Config.
- [ ] 11.6 JMAP: Thunderbird Desktop kann noch kein JMAP. Auf dem Handy Sterna Mail (F-Droid) verwenden, optional Bulwark als Webmail auf ServerPublic. Sobald Thunderbird JMAP unterstützt: Konto umstellen.
## Phase 14 – Security, später entschieden

- [ ] 14.3 SMT ist seit 08.11.2026 nur auf ServerPublic aus (`security.allowSimultaneousMultithreading = false` in `hosts/NixOS-ServerPublic/machine.nix`). Der VPS zeigt einen Thread pro Kern, die Einstellung wirkt dort also erst, wenn Contabo die Topologie ändert. Server1 und ServerGaming behalten SMT (Leistung). Nach dem Deploy prüfen: `ssh admin@NixOS-ServerPublic 'lscpu | grep -E "^CPU\(s\)|Thread"'` zeigt weiter alle 4 CPUs.

- [ ] 14.9 Sandboxing statt Container (Entscheidung 08.11.2026): Die Bridges (mautrix-signal, -whatsapp, -telegram, -discord) und ntfy haben seit 08.11.2026 zusätzliche systemd-Härtung (`bridgeHardening` in `nixosModules/server/public/matrix.nix`, ntfy in `ntfy.nix`). Nach dem Deploy (27.3) prüfen:
  - `ssh admin@NixOS-ServerPublic 'systemd-analyze security --no-pager | grep -E "mautrix|ntfy"'`: vorher Telegram 7,8, die übrigen 4,0 bis 4,6. Ziel: alle unter 4.
  - Jede Bridge antwortet auf `ping`, Nachrichten gehen hin und zurück, ntfy stellt eine Testnachricht zu. Bricht etwas: `journalctl -u mautrix-telegram -b | grep -i -E "denied|permission|seccomp"` an Claude.
  - Briar-Mailbox (9,8 für den Podman-Dienst, der Dienst selbst läuft im Container): bleibt vorerst. Später prüfen, ob Podman rootless läuft (mit Claude).

- [ ] 14.7 Gehärteter Kernel: `linuxPackages_hardened` gibt es nicht mehr. Alternative: eigener Kernel-Build (kein Binary Cache).
- [ ] 14.8 Clients: auch `udf` blockieren, falls nicht gebraucht.
- [ ] 14.10 Secure Boot auf allen Clients und Server1 (Desktop am 08.11.2026: `Secure Boot: enabled`, TPM2 dort noch prüfen) (Keys enrollen: Setup-Mode, `sudo sbctl enroll-keys --microsoft --firmware-builtin`), danach TPM2 + PIN (README).
- [ ] 14.11 Laptops: DNS läuft über Quad9 mit TLS, bis WireGuard steht. Captive Portals brauchen `nmcli` mit temporärem DNS.
- [ ] 14.13 Radicale auf bcrypt (Entscheidung 08.11.2026: ja, zusammen mit 20.4; Claude baut das Modul um, sobald du bei 20.4 bist): Heute steht in `radicale/htpasswd` die Zeile `jf:<passwort>` im Klartext (`htpasswd_encryption = "plain"` in `nixosModules/server/sync/radicale.nix`). Dieselbe Zeile liegt auch auf den Clients, weil der Kalender-Sync unter Hyprland das Passwort daraus liest (`homeModules/desktop/windowManager/hyprland/popups.nix`, alles nach `jf:`). Mit bcrypt stünde auf Server1 nur noch ein Hash (`jf:$2y$…`): Wer die Datei vom Server stiehlt, kennt das Passwort dann nicht. Dafür bräuchten die Clients ein eigenes Secret mit dem Klartext (z. B. `radicale/password`), und das Modul muss umgebaut werden (mir Bescheid geben). Lohnt sich vor allem zusammen mit 20.4, dann änderst du das Radicale-Passwort nur einmal.
- [ ] 14.12 Lynis und kernel-hardening-checker einmal pro Host laufen lassen (`sudo lynis audit system`, `kernel-hardening-checker -c /proc/config.gz -l /proc/cmdline -s <(sysctl -a)`) und die Ergebnisse auswerten.

## Phase 19 – Test-Anwendungen auf ServerGaming (zuletzt wieder entfernen)

Nextcloud mit Collabora, code-server und die Countdown-Seite laufen nur zum Testen auf ServerGaming, nicht auf ServerPublic. Alles steht in `hosts/NixOS-ServerGaming/temp/`, die Module bleiben in `nixosModules/`. Auf ServerPublic bleiben Stalwart, Matrix mit Bridges und coturn, ntfy, Miniflux, CryptPad und Briar Mailbox.

Einrichten (nach 8B, wenn ServerGaming läuft):

- [X] 19.1 (08.11.2026 geprüft: `codeserver` steht nur noch in `nixos-servergaming.yaml`) Secrets: `codeserver/env` (`HASHED_PASSWORD=<argon2-Hash>`) aus `nixos-serverpublic.yaml` nach `nixos-servergaming.yaml` übertragen (`cd $PRIV/secrets && sops nixos-servergaming.yaml`), dann in `nixos-serverpublic.yaml` löschen, committen, `nix flake update private`.
- [ ] 19.2 DNS: A/AAAA für `cloud`, `office` und `code` auf den Gaming-VPS umstellen (`countdown` steht schon in 8.16).
- [X] 19.3 (08.11.2026: kein `murmur` mehr in den sops-Dateien; Firewall-Regel „mumble-test“, DNS-Eintrag `murmur` und den KeePassXC-Eintrag selbst nachsehen und ggf. löschen) Murmur ist seit 07.11.2026 entfernt (Modul, Testdienst, Glance-Eintrag). Reste löschen, falls schon angelegt: Firewall-Regel „mumble-test“ (64738) im Contabo-Panel, DNS-Eintrag `murmur`, `murmur/env` in `nixos-serverpublic.yaml` und `nixos-servergaming.yaml`, KeePassXC-Eintrag „Mumble server password“.
- [ ] 19.4 Nextcloud-Konten anlegen, NixOS setzt den Admin seit dem Update vom 03.11.2026 nicht mehr selbst. Admin und persönliches Konto sind getrennt. Passwörter jeweils zuerst in KeePassXC erzeugen (Reiter „Passwort“, 128 Zeichen, nur A-Z, a-z, 0-9; lehnt der Dienst das ab, auf das erlaubte Maximum kürzen und im Notizfeld vermerken), nur dort speichern.
  - [ ] Admin: KeePassXC `NixOS/ServerGaming` → „Nextcloud admin“, Benutzername `admin`, URL `https://cloud.<domain>`. Auf ServerGaming `sudo nextcloud-occ user:add admin` (fragt nach dem Passwort) und `sudo nextcloud-occ group:adduser admin admin`.
  - [ ] Persönlich: KeePassXC „Nextcloud jf“, Benutzername `jf`. `sudo nextcloud-occ user:add jf`, ohne Admin-Gruppe. Den Nextcloud-Client und Kalender/Kontakte nur mit `jf` verbinden.
  - [ ] Talk hat hier keinen TURN-Server (coturn läuft auf ServerPublic).

## Phase 15 – Neue Dienste und Projekte (optional, nach Priorität)

- [ ] 15.3 Lokaler Binary Cache und Offline-Installer (Entscheidung 08.11.2026, mit Claude umsetzen, Hintergrund in [`docs/offline-installation.md`](docs/offline-installation.md)):
  - Cache: Server1 baut jede Nacht die Systeme aller Hosts und liefert sie per harmonia im LAN und über WireGuard aus. Gehalten wird nur der aktuelle Stand (ein Nix-GC-Root pro Host, ältere Stände räumt die Garbage Collection weg), dazu die Quell-Tarballs (`keep-outputs`), damit alles auch ohne Upstream neu baubar bleibt. Größe: die Systeme aller Hosts zusammen etwa 70 bis 90 GB (gemessen 08.11.2026: Desktop 51,5 GB, Server1 23,1 GB, ServerGaming 18,1 GB, ServerPublic 9,0 GB, viele Pakete gemeinsam). Signierschlüssel in sops, die anderen Hosts vertrauen ihm.
  - Offline-Image: ein Host `NixOS-Installer` (Live-System auf einer USB-SSD, komprimiert etwa 40 bis 60 GB) mit den fertigen Systemen aller Hosts, dem Repo und dem privaten Input (`site.nix`, verschlüsselte sops-Dateien, keine age-Keys). Das Image enthält Domains und Login-Hashes, also privat aufbewahren. Neu bauen etwa alle 3 Monate.
  - `NixOSInstaller.sh` wird dafür umgebaut: installiert vom Image statt von GitHub (Host, Platte, Passphrase, age-Key wie heute). Die Online-Variante entfällt.
  - Empfohlener Weg für Installationen bleibt nixos-anywhere vom Desktop (README → Installation), das Image ist der Weg ohne zweiten Rechner oder ohne Netz.

- [ ] 15.8 Optional, nur ausprobieren (kein Dauerbetrieb): RDP über Plasma KRDP. Am Zielrechner Systemeinstellungen → Remote Desktop → aktivieren, Benutzer und Passwort festlegen, Port 3389 bleibt in der NixOS-Firewall zu, für den Test kurz `sudo nft insert rule inet nixos-fw input tcp dport 3389 ip saddr 10.75.0.0/16 accept` (verschwindet beim nächsten Deploy). Vom Laptop mit KRDC (`rdp://<host>`) verbinden. Danach Remote Desktop wieder ausschalten und das Ergebnis hier notieren.

- [ ] 15.10 Wiki: In Forgejo unter dem Benutzer `xerhaxs` das Repository `wiki` anlegen und das Wiki aktivieren. Die Inhalte stehen in [`WIKI-TODO.md`](WIKI-TODO.md).

- [ ] 15.11 Forgejo-Spiegel löschen (Entscheidung 08.11.2026: keine Spiegel aller Quellen, den Schutz gegen verschwindende Projekte übernimmt der Binary Cache mit `keep-outputs`, 15.3). In Forgejo (`https://forgejo.<homeDomain>`) → Verwaltung → Repositorys, Filter „Spiegel“: bei jedem Spiegel-Repo, das nicht dir gehört, Einstellungen → Gefahrenzone → „Dieses Repository löschen“. Eigene Repos und Spiegel deiner eigenen Projekte (Push-Spiegel zu GitHub/Codeberg) bleiben.

## Phase 16 – Deklarative Konfiguration weiterer Programme (niedrige Priorität, zuletzt)

Ziel: Erst das Programm von Hand einstellen, dann die Konfiguration übernehmen. Bevorzugt deklarativ (Home Manager oder Aktivierungsskript wie bei Clementine/Element), sonst per Impermanence persistieren.

| Programm | Konfiguration | Persistenz heute | Vorgehen |
|---|---|---|---|
| FreeCAD | `~/.config/FreeCAD/user.cfg` (XML), `~/.local/share/FreeCAD` | persistiert (3dprinting.nix) | Einstellungen von Hand setzen, die relevanten Parameter aus `user.cfg` per Aktivierungsskript (`xmlstarlet ed`) setzen |
| OrcaSlicer | `~/.config/OrcaSlicer/` (JSON: Drucker-, Filament- und Prozessprofile) | persistiert | eigene Profile als JSON ins Repo, per `xdg.configFile` (nur die Profile, nicht `OrcaSlicer.conf`) |
| rclone | `~/.config/rclone/rclone.conf` (enthält Tokens) | prüfen | Home Manager `programs.rclone.remotes` mit Secrets aus sops, `.config/rclone` persistieren |
| Rnote | GSettings `com.github.flxzt.rnote` (dconf) | dconf persistiert | `dconf watch /` beim Einstellen, Werte nach `dconf.settings` übernehmen |
| Xournal++ | `~/.config/xournalpp/settings.xml` | prüfen | Einstellungen von Hand, danach per Aktivierungsskript (`xmlstarlet`) setzen und `.config/xournalpp` persistieren |

- [ ] 16.1 FreeCAD
- [ ] 16.2 OrcaSlicer
- [ ] 16.4 rclone
- [ ] 16.5 Rnote
- [ ] 16.6 Xournal++

## Phase 18 – Hyprland (später)

Alle Hyprland-Punkte an einer Stelle, zusammengeführt am 04.11.2026 aus 4.12, 5.2, 5.3, 13.1, 13.4, 13.15, 13.16 und 16.7. Hyprland ist seit 03.11.2026 auf allen Clients aus (`hyprland.enable = false` in `hosts/<Host>/configuration.nix`), Plasma ist der einzige Desktop. Die Module bleiben im Repo, das Touch-Modul wirkt nur mit Hyprland.

- [ ] 18.1 Wieder einschalten: in `hosts/<Host>/configuration.nix` die Zeile `hyprland.enable = false;` entfernen, bauen, abmelden → SDDM → Session „Hyprland“. Der Wetterort kommt aus sops (`weather-location`: Name, Breite, Länge als JSON, in `$PRIV/secrets/clients.yaml` und `$PRIV/secrets/nixos-portable.yaml`). Tastenkürzel: Super+X → System → Keybindings oder `homeModules/desktop/windowManager/hyprland/README.md`.
- [ ] 18.2 Plugins: `hyprtasking` (Super+Tab) und `hyprgrass` (Touch am Convertible) bauen gegen Hyprland 0.57 nicht, auch nicht in der neuesten Version. Neue Versionen prüfen oder die Plugins weglassen.
  - [ ] hyprgrass: prüfen, ob `pkgs.hyprlandPlugins.hyprgrass` wieder baut. Dann `pkgs/hyprgrass` löschen und in `touch.nix` `pkgs.hyprlandPlugins.hyprgrass` verwenden.
  - [ ] hypr-dynamic-cursors: Die Version aus nixpkgs (2026-07-21) warf auf Hyprland 0.56.2 beim Laden eine Exception und ist deshalb aus `plugins` in `homeModules/desktop/windowManager/hyprland/hyprland.nix` entfernt. Wieder eintragen und mit `hyprctl plugin list` prüfen, die Einstellungen in `config/hyprland.lua` sind noch da.
- [ ] 18.3 Abmelden testen: Super+Shift+Q, Power-Menü und Waybar nutzen `session-logout`. Es stoppt die Dienste, beendet Hyprland und beendet nach 5 Sekunden die Session per `loginctl`, falls Hyprland hängt. Am 03.11.2026 auf dem Framework noch fehlerhaft, die Ursache ist ungeklärt: `journalctl --user -b -g "session-logout|hyprland"` dabei mitschneiden. Hintergrund: Die Hooks in `hyprland.shutdown` (auch der von Home Manager) stoppen die Dienste blockierend, der Compositor wartet auf die Dienste und die Dienste auf ihn. Erwartet: Abmelden dauert wenige Sekunden, `coredumpctl list -S today` zeigt nichts Neues.
- [ ] 18.4 Lag beim Klick auf Waybar-Elemente beobachten. In der Sandbox nicht reproduzierbar: rofi, wlogout, pavucontrol und kitty öffnen in 0,06 bis 0,27 s, auch mit den echten 87 `XDG_DATA_DIRS`, Waybar liegt im Leerlauf bei 0 % CPU. Geändert wurden die wahrscheinlichsten Ursachen: Unter Hyprland lief das KDE-Portal (`portals.conf` mit `default=kde` hatte Vorrang), jetzt `hyprland;gtk`. Außerdem keine CSS-Übergänge mehr in Waybar und weniger Blur. Tritt es noch auf, zuerst notieren, welches Element es trifft (Tray-Menüs, Tooltips oder alles), dann `hyprctl plugin unload` für hyprtasking testen (das Plugin hängt an den Mausklicks) und `journalctl --user -b | grep -iE "portal|timeout"` ansehen.
- [ ] 18.5 Prüfen, ob der Waybar-Patch für Workspace-Klicks noch nötig ist (`waybar.nix`).
- [ ] 18.6 In der echten Session testen: Enter im Dashboard, Helligkeit per DDC, Kalender-Sync mit Radicale, Lag aus 18.4, danach in Plasma die Titelleisten (nach einem Wechsel von Hyprland zu Plasma: `systemctl --user show-environment | grep -c NIXOS_OZONE_WL` ist 0).
- [ ] 18.7 Convertible: Touch-Gesten, Bildschirmtastatur (Wisch vom unteren Rand nach oben) und automatische Drehung (`iio-hyprland`) testen.
- [ ] 18.8 Laptops: kanshi-Profile prüfen (Laptop allein / mit externem Monitor). Positionen bei Bedarf in `hosts/<host>/home/hyprland.nix` anpassen.
- [ ] 18.9 Journal prüfen: in Hyprland einmal an- und abmelden, neu starten, dann `journalctl -b -p err` und `coredumpctl list -S today`. Jede Meldung bewerten und in 13.1 eintragen. Erwartet: keine Coredumps nach dem Abmelden, kein `ordering cycle`, `systemctl --failed` und `systemctl --user --failed` sind leer.

## Phase 17 – Merge nach `main`
Entscheidung 08.11.2026: Die Server werden von Hand aktualisiert (`nix flake update`, bauen, deployen, siehe README → Maintenance). Kein Auto-Upgrade, kein Online-Privat-Repo, keine Deploy-Keys. Der Auto-Upgrade-Code ist entfernt. Das private Repo bleibt lokal und per Syncthing auf den Clients und Server1, die Kopie außer Haus kommt über das Proton-Backup (9.5).

Erst wenn die Hosts auf dem neuen Stand laufen. Bis dahin ist `system.autoUpgrade` aus, sonst würden die Server nachts auf den alten Stand von `main` zurückspringen.

- [ ] 17.6 `rework` nach `main` mergen und pushen, vorher Prüfung aus 2.3 auf dem gesamten Diff.
- [ ] 17.8 Abschluss, wenn alles steht (nach 17.6): Journal und Coredumps auf allen Clients (Desktop, Framework, Convertible, Portable) und allen Servern (Server1, ServerPublic, ServerGaming) noch einmal prüfen, auch wenn 5.1a und 13.1 schon erledigt sind. Pro Host einmal neu starten, auf Clients in Plasma an- und abmelden, dann `journalctl -b -p err` und `coredumpctl list -S today`. Jede neue Meldung in 13.1 bewerten.

## Phase 20 – Login, Festplatten und alles, was Handy oder andere Geräte betrifft (ganz zum Schluss)

Alle übrigen Secrets erneuert Phase 7 (7B bis 7E). Hier bleiben die Passwörter, die du selbst tippst: Login der Benutzer (`jf` auf den Clients, `admin` auf den Servern) und das WLAN-Passwort. Dazu kommen die Werte, die du am Handy oder an anderen Geräten neu eintragen musst (20.4: SMB, Radicale, Mailkonten bei Anbietern). Die Postfächer in Stalwart entstehen erst in 8.8 und 10.1 mit endgültigem Passwort, sie fehlen hier deshalb. Alles in einem Zug, damit du jedes Gerät nur einmal anfasst. Die LUKS-Passphrasen werden nicht geändert, sie bekommen nur einen ordentlichen KeePassXC-Eintrag (20.2). SSH-Schlüssel und Syncthing folgen nach dem Funktionstest in Phase 22.

Wo sie bekannt geworden sein könnten:

- Öffentliche Git-Historie seit 2024 (`Initial Commit`, `update` und folgende): Dort stehen sha512crypt-Hashes alter Login-Passwörter im Klartext. Sie lassen sich offline knacken. Jedes Passwort, das damals galt, und jedes ähnliche gilt als bekannt, auch wenn du es heute an anderer Stelle nutzt (Festplatte, Router, Konten).
- `secrets/initial-passwords.yaml` im privaten Repo (01.11.2026, inzwischen gelöscht, aber in der privaten Historie): Startpasswörter aller Hosts, erzeugt in einer Sitzung mit Claude. Die heutigen Login-Passwörter hast du danach selbst gesetzt (1.2). Hast du eines der Startpasswörter irgendwo weiterverwendet, auch als LUKS-Passphrase, gilt es als bekannt.
- `nixosModules/server/network/pihole.nix` und `hosts/NixOS-Server1/syncthing.nix`: die Hashes des Pi-hole- und des Syncthing-GUI-Passworts standen im öffentlichen Repo (seit 07.11.2026 entfernt, neu in 7.8a). Nutzt du eines dieser Passwörter woanders, gilt es als bekannt.
- LUKS-Passphrasen standen nie in einem Repo und werden nicht rotiert (Entscheidung 07.11.2026).
- WLAN (`wifi` in `clients.yaml` und `nixos-portable.yaml`): stand nur verschlüsselt in der alten gemeinsamen Datei, deren Schlüssel es nicht mehr gibt. Die Portable-Datei wurde mit Claude angelegt, die WLAN-Werte hast du aber selbst eingetragen (1.5). Kein bekannter Weg nach außen, deshalb ohne Eile.

- [ ] 20.1 Login-Passwörter (Desktop, Framework, Convertible, Portable: `jf`; Server1, ServerPublic, ServerGaming: `admin`). Seit 07.11.2026 lesen alle Hosts den Hash aus sops (`nixos.system.user.passwordFromSops = true`), `initialHashedPasswords` in `site.nix` gilt nur noch für die VMs. Sind die Hashes vom 07.11. schon deine neuen Passwörter, ist hier nur der letzte Punkt offen. Sonst pro Host:
  - [ ] KeePassXC: Eintrag „Login <Host>“ in `NixOS/Devices`, Reiter „Passphrase“, 7 Wörter (wird getippt, deshalb Wörter statt Zeichen). URL: keine, nur „Login NixOS-Server1“ bekommt `https://cockpit.<homeDomain>`. Speichern.
  - [ ] Hash erzeugen und direkt in sops schreiben (fragt zweimal nach dem Passwort, das nicht angezeigt wird). Beispiel Desktop, für die anderen Hosts Datei und Pfad tauschen: Framework `clients.yaml '["user"]["nixos-framework"]["jf"]'`, Convertible `clients.yaml '["user"]["nixos-convertible"]["jf"]'`, Portable `nixos-portable.yaml '["user"]["nixos-portable"]["jf"]'`, Server1 `nixos-server1.yaml '["user"]["nixos-server1"]["admin"]'`, ServerPublic `nixos-serverpublic.yaml '["user"]["nixos-serverpublic"]["admin"]'`, ServerGaming `nixos-servergaming.yaml '["user"]["nixos-servergaming"]["admin"]'`:

    ```
    cd ~/Documents/nixos-private/secrets
    h=$(nix shell nixpkgs#mkpasswd -c mkpasswd -m sha-512 -R 500000) && printf '"%s"' "$h" | sops set --value-stdin clients.yaml '["user"]["nixos-desktop"]["jf"]'; unset h
    ```

  - [ ] Committen (`cd ~/Documents/nixos-private && git add -A && git commit -m "new login hash"`), `cd ~/Documents/nixos && nix flake update private`, deployen. Vorher in einem zweiten Terminal eine Root-Shell öffnen (`sudo -i`, bei Servern `ssh -t admin@<Host> sudo -i`), danach in einem dritten `sudo -k; sudo -v` mit dem neuen Passwort. Klappt es nicht, in der Root-Shell `nixos-rebuild switch --rollback`.
  - [ ] Aufräumen, wenn alle Hosts laufen: in `$PRIV/site.nix` unter `initialHashedPasswords` alle Einträge außer `nixos-vmdesktop`, `nixos-vmserver1`, `nixos-vmserverpublic` (und `nixos-vmservergaming`, falls angelegt) löschen, committen, `nix flake update private`.
- [ ] 20.2 Festplatten: nicht rotieren, nur ordentlich in KeePassXC ablegen. Pro Host (Desktop, Framework, Convertible, Portable, Server1, ServerPublic, ServerGaming):
  - [ ] Eintrag „LUKS <host>“ in `NixOS/Devices`, Passwortfeld = die jetzige Passphrase, keine URL. Notizfeld: Partition (`lsblk -o NAME,PARTLABEL,FSTYPE | grep -i crypto` zeigt sie, meist `disk-NIXOS-LUKS`, beim Mirror zusätzlich `disk-NIXOS2-LUKS`), ob TPM2 gebunden ist, ob Remote-Unlock per initrd-ssh (Port 2222) läuft.
  - [ ] Prüfen, dass die gespeicherte Passphrase stimmt, ohne etwas zu ändern: `sudo cryptsetup open --test-passphrase /dev/disk/by-partlabel/disk-NIXOS-LUKS`, Passphrase aus KeePassXC einfügen. Keine Ausgabe heißt richtig.
  - [ ] Belegte Schlüsselplätze ansehen: `sudo systemd-cryptenroll /dev/disk/by-partlabel/disk-NIXOS-LUKS` (zeigt `password`, `tpm2`, `recovery`). Gibt es einen Recovery-Key, ihn unter Erweitert → Zusätzliche Attribute als `recovery key` (geschützt) eintragen und auf Papier sichern. Gibt es keinen und du willst einen: `sudo systemd-cryptenroll --recovery-key /dev/disk/by-partlabel/disk-NIXOS-LUKS` (fügt einen Platz hinzu, die Passphrase bleibt).
  - [ ] Server1: Die Daten-Datasets und das Cache-Laufwerk hängen am Eintrag „ZFS pool01“ (7D-2), der bleibt ebenfalls unverändert.
- [ ] 20.4 Werte, die auch am Handy oder an anderen Geräten stehen (SMB, Radicale, Mailkonten bei Anbietern). Syncthing: Phase 22. Erzeugen und Format laut Tabelle 20A am Ende. Gleiche Reihenfolge wie in 7B: KeePassXC, Dienst, sops, committen, `nix flake update private`, deployen, prüfen. Handy, Melis Rechner und Windows-Geräte folgen gesammelt in Phase 23, bis dahin haben sie mit den alten Passwörtern keinen Zugriff.
  - [ ] SMB jf (127 Zeichen): `nixos-server1.yaml` → `smb-share/user-jf`, `clients.yaml` und `nixos-portable.yaml` → `nas-smb/user` (Zeile `password=`). Server1, alle Clients und Portable im selben Zug deployen. Handy und Windows-Geräte: 23.3.
  - [ ] SMB meli (127 Zeichen): `nixos-server1.yaml` → `smb-share/user-meli`, deployen. Melis Rechner und ihr Bitwarden: 23.4.
  - [ ] Radicale jf (128 Zeichen, kein `:`): `nixos-server1.yaml`, `clients.yaml` und `nixos-portable.yaml`, jeweils → `radicale/htpasswd`. Alle im selben Zug deployen. Danach in Thunderbird (Kalender → Eigenschaften, beim nächsten Abruf fragt es nach dem Passwort). DAVx5 am Handy: 23.5. Vorher Claude Bescheid geben: Er baut Radicale auf bcrypt um (14.13), dann änderst du das Passwort nur einmal und bekommst dazu das neue Secret für die Clients.
  - [ ] Mailkonten bei Anbietern (Proton, DLRG, 1&1): beim Anbieter ändern, dann Thunderbird (fragt beim nächsten Abruf). Handy: 23.6. Proton: danach `restic/rclone-proton` auf Server1 neu erstellen (`rclone config`, 9.4) und einen Testlauf des Backups starten.

20A – Werte für 20.4:

| Wert | KeePassXC (Gruppe → Titel) | KeePassXC-URL (Autofill) | Format | Erzeugen | Ändern ohne Ausfall | Eintragen in |
|---|---|---|---|---|---|---|
| SMB jf: `smb-share/user-jf` (Server1), `nas-smb/user` (Clients, Portable) | `NixOS/Server1` → „SMB jf“ (ein Eintrag für alle Dateien) | keine (`smb://NixOS-Server1` nur im Notizfeld) | Server1: Passwort, eine Zeile. Clients: zwei Zeilen `username=jf`, `password=<passwort>` | KeePassXC → Reiter „Passwort“, 127 Zeichen, nur A-Z, a-z, 0-9 (127 ist das Maximum, das Windows bei SMB annimmt) | Server1 setzt es beim Deploy per `smbpasswd`. Alle drei Dateien gleichzeitig ändern, Server1, Clients und Portable im selben Zug deployen | `nixos-server1.yaml` → `smb-share/user-jf`, `clients.yaml` und `nixos-portable.yaml` → `nas-smb/user` (Zeile `password=`); Handy-Dateimanager, Windows-Geräte |
| SMB meli: `smb-share/user-meli` | `NixOS/Server1` → „SMB meli“ | keine | Passwort, eine Zeile | KeePassXC → Reiter „Passwort“, 127 Zeichen, nur A-Z, a-z, 0-9 (127 ist das Maximum, das Windows bei SMB annimmt), eigener Wert | wird beim Deploy gesetzt | Melis Rechner und ihr Bitwarden (23.4) |
| Radicale jf: `radicale/htpasswd` | `NixOS/Server1` → „Radicale jf“ (ein Eintrag für alle drei Dateien) | `https://radicale.<homeDomain>` | eine Zeile `jf:<passwort>` (Klartext, die Clients lesen daraus das Passwort für den Kalender) | KeePassXC → Reiter „Passwort“, 128 Zeichen, nur A-Z, a-z, 0-9 (kein `:`, das trennt Benutzer und Passwort) | in allen drei Dateien derselbe Wert, im selben Zug deployen | `nixos-server1.yaml`, `clients.yaml`, `nixos-portable.yaml`, jeweils → `radicale/htpasswd`; DAVx5 am Handy, Thunderbird |
| Mailkonten bei Anbietern (Proton, DLRG, 1&1) | `NixOS/Providers` → „Proton“, „DLRG“, „1&1“ | „Proton“ `https://account.proton.me`, „DLRG“ Adresse des DLRG-Webmails, „1&1“ Login-Seite von 1&1 | Passwort | KeePassXC → Reiter „Passwort“, so lang wie der Anbieter zulässt (128 versuchen, sonst kürzen) | beim Anbieter ändern, danach in Thunderbird neu anmelden (Handy: 23.6). 2FA prüfen, Wiederherstellungscodes als Anhang sichern | Proton: `restic/rclone-proton` auf Server1 neu erstellen (9.4) |

## Phase 21 – Kompletter Funktionstest (ganz am Ende)

Einmal alles durchgehen, nachdem alle Werte erneuert sind. Was scheitert, als neuen Punkt in Phase 13 eintragen (mit Datum und Fehlermeldung), nicht sofort umbauen. Webdienste mit den KeePassXC-Einträgen anmelden, dann ist zugleich das Autofill geprüft.

- [ ] 21.1 Jeder Host, zuerst ohne, dann nach einem Neustart noch einmal (`/` und `/home` sind tmpfs, erst der Neustart zeigt, ob die Persistenz stimmt):
  - [ ] `systemctl --failed` und `systemctl --user --failed` sind leer, `journalctl -b -p err` enthält nichts Neues.
  - [ ] Clients: `systemctl status home-manager-jf` ohne Fehler (scheitert er, fehlen alle Links im Home).
  - [ ] sops: `journalctl -b | grep -i sops` ohne `failed`, `ls /run/secrets` zeigt die erwarteten Pfade.
  - [ ] Secure Boot und Entsperren: `bootctl status` (Secure Boot: enabled), TPM-Entsperrung bzw. Remote-Unlock per initrd-ssh (Port 2222) bei den Servern.
  - [ ] Updates: `systemctl list-timers` zeigt die Timer (Update-Check, vulnscan, ClamAV nach 13.24).
- [ ] 21.2 Server1, Netz:
  - [ ] Mullvad verbunden (`mullvad status`), Pi-hole und unbound antworten: von einem Client `dig @NixOS-Server1 nixos.org` liefert eine Adresse, eine Domain aus der Blockliste `0.0.0.0`.
  - [ ] Zertifikate: `systemctl list-units 'acme-*' --failed` leer.
  - [ ] Alle Webdienste erreichbar, von einem Client aus: `ssh admin@NixOS-Server1 "sudo nginx -T 2>/dev/null" | awk '$1=="server_name"{for(i=2;i<=NF;i++)print $i}' | tr -d ';' | sort -u | while read h; do curl -s -o /dev/null -m 15 -w "%{http_code} $h\n" "https://$h"; done`. Erwartet sind 200, 301, 302 oder 401, nie 000, 502 oder 504.
  - [ ] ZFS: `zpool status -x` meldet „all pools are healthy“, `zfs mount` zeigt alle Datasets von `pool01`.
- [ ] 21.3 Server1, Dienste (anmelden und eine echte Aktion pro Dienst):
  - [ ] Jellyfin: 4K-HDR-Film mit Transkodierung abspielen, im Journal `h264_qsv` oder `hevc_qsv` (13.27), Cover und Hintergründe vorhanden (13.28).
  - [ ] Sonarr, Radarr, Lidarr, Readarr: Einstellungen → Download-Clients → „Test“ für SABnzbd, Indexer → „Test“ für NZBHydra2. NZBHydra2: Suche liefert Treffer. SABnzbd: ein kleiner Test-Download kommt an und wird importiert.
  - [ ] SMB (`/mount/...` am Client), WebDAV (`https://dav.<homeDomain>` im Browser, nach 27.4 `/mount/dav`), Radicale (ein Testtermin in Thunderbird erscheint nach dem Abruf auf `https://radicale.<homeDomain>`).
  - [ ] Forgejo: Anmeldung mit 2FA (Code aus KeePassXC), `git push` per SSH, die Spiegel zeigen „Zuletzt synchronisiert“ mit aktueller Zeit.
  - [ ] Linkwarden: Link speichern, Archiv wird erzeugt. HomeBox: Gegenstand anlegen. Home Assistant: Integrationen ohne Fehler, ein Gerät schalten.
  - [ ] Glance: alle Widgets zeigen Daten (Pi-hole, Jellyfin, Kalender, Home Assistant, Miniflux, Server-Seite).
  - [ ] Monitoring: Grafana-Dashboards haben Daten, in Prometheus unter Status → Targets alles „up“, Loki zeigt Logs aller Hosts. Cockpit: Anmeldung als `admin`.
  - [ ] Syncthing: Oberfläche anmelden, alle Geräte verbunden, alle Ordner „Aktuell“.
  - [ ] Werkzeuge: SearXNG sucht, Invidious spielt ein Video, Redlib zeigt einen Subreddit, Kiwix öffnet eine ZIM, LanguageTool prüft einen Satz (Thunderbird oder LibreOffice), LibreTranslate übersetzt, Ollama antwortet, ComfyUI erzeugt ein Bild auf der Intel-GPU, Monero-Node synchron (`monerod status` bzw. Glance), networkingtoolbox lädt.
  - [ ] ClamAV (nach 13.24): EICAR-Testdatei in einem überwachten Ordner wird erkannt und gemeldet, danach löschen.
- [ ] 21.4 ServerPublic:
  - [ ] Mail: von einem externen Konto an Stalwart und zurück. mail-tester.com (10/10), Header zeigen `spf=pass`, `dkim=pass`, `dmarc=pass`. IMAP und SMTP in Thunderbird. Eine Alarm-Mail von `alerts@` kommt an.
  - [ ] Matrix: Anmeldung in Element, Nachricht an einen fremden Server (Federation, z. B. federationtester.matrix.org) (Sprachanruf über coturn: 23.13). Bridges Signal, WhatsApp, Telegram, Discord: je eine Nachricht hin und zurück.
  - [ ] ntfy: `curl -d test https://push.<domain>/<topic>` mit Token kommt in der Weboberfläche an (Handy: 23.9). Miniflux: Feeds werden aktualisiert, Fluent Reader synchronisiert. CryptPad: Dokument anlegen und teilen.
  - [ ] fail2ban: `sudo fail2ban-client status` zeigt die Jails.
- [ ] 21.5 ServerGaming: Minecraft beitreten, BlueMap und Countdown laden. Testdienste nur, solange Phase 19 sie noch nicht entfernt hat.
- [ ] 21.6 Zwischen den Hosts:
  - [ ] WireGuard: `sudo wg show` auf ServerPublic zeigt für alle Peers einen frischen Handshake, `ping 10.100.0.1` und `ping 10.100.0.2` gehen von einem Client, `ssh admin@NixOS-ServerPublic` und `ssh admin@NixOS-ServerGaming` gehen direkt, auch ohne Tunnel.
  - [ ] Backups: Back In Time von Server1 auf die externe Platte, restic der VPS auf Server1 und Server1 nach Proton Drive: je `restic snapshots` zeigt einen Lauf von heute, eine Datei probehalber zurückholen.
  - [ ] Alarme: auf Server1 einen Test-Alarm schicken: `nix shell nixpkgs#prometheus-alertmanager -c amtool alert add Testalarm severity=critical --alertmanager.url=http://localhost:9093`, er kommt per ntfy und per Mail an. Killswitch nur testen, wenn ein Herunterfahren gerade passt.
- [ ] 21.7 Clients (Desktop, Framework, Convertible, Portable):
  - [ ] Anmeldung in Plasma und Hyprland, Autostart und Erweiterungen da, `hyprctl configerrors` leer.
  - [ ] KeePassXC: Datenbank öffnen, Browser-Integration füllt eine Seite aus, `ssh-add -l` zeigt den Schlüssel, `ssh admin@NixOS-Server1` geht, `sops` entschlüsselt mit dem Admin-Schlüssel.
  - [ ] Netz: WLAN (Heimnetz), Mullvad verbindet, SMB- und WebDAV-Mounts, Syncthing synchronisiert eine Testdatei auf alle Geräte.
  - [ ] Thunderbird: alle Konten empfangen und senden, Kalender und Adressbuch synchron, signierte Mail geht raus.
  - [ ] Ton, Bluetooth-Kopfhörer, Kamera, Drucker bzw. Scanner, ein Spiel über Steam.
- [ ] 21.8 Handy: gesammelt in 23.13.
- [ ] 21.9 Härtung, Netz und Einzelprüfungen (übernommen aus der früheren `CHECKLIST.md`, seit 08.11.2026 gelöscht). Auf einem Client und auf Server1, bei „Server“ auf allen drei Servern:
  - [ ] Kernel und sysctl: `sysctl kernel.kptr_restrict dev.tty.ldisc_autoload vm.unprivileged_userfaultfd` zeigt `2`, `0`, `0`. `cat /proc/cmdline` enthält `pti=on` und `audit=1`. Server zusätzlich: `sysctl vm.mmap_rnd_bits kernel.panic` zeigt `32` und `10`, `/proc/cmdline` enthält `oops=panic`.
  - [ ] Weniger Angriffsfläche: `ls /run/wrappers/bin` enthält kein `su`, `sg`, `newgrp`, `sudoedit`, `sudo -i` geht trotzdem. `which nano` findet nichts. Server: `systemctl is-active ModemManager avahi-daemon` ist `inactive` (auf Server1 darf avahi für Home Assistant laufen).
  - [ ] Zeit: `chronyc -N authdata` zeigt NTS-Quellen.
  - [ ] Server, Audit: `sudo auditctl -l | grep -c execve` größer 0.
  - [ ] ServerPublic: `cat /etc/ld-nix.so.preload` nennt den hardened malloc, alle Dienste laufen. `ping -4 <ipv4>` bekommt keine Antwort, `ping -6` schon.
  - [ ] Dateisysteme: `findmnt -o TARGET,OPTIONS /boot /secrets` zeigt `nosuid,nodev,noexec`, bei `/boot` auch `fmask=0077`. `journalctl --list-boots | wc -l` größer 1 (machine-id persistiert).
  - [ ] SSH: `ssh -v admin@NixOS-Server1 true 2>&1 | grep -E "kex: algorithm|Authentications that can continue"` zeigt `mlkem768x25519-sha256` und nur `publickey`.
  - [ ] sops: `ls /run/secrets` zeigt nur Secrets des Hosts, `nix path-info -r /run/current-system | grep -c nixos-private` ist 0 (nur die eigene Datei kommt auf den Host).
  - [ ] DNS: `dig +dnssec sigfail.ippacket.stream @NixOS-Server1` liefert `SERVFAIL` (DNSSEC prüft), `resolvectl status` zeigt DNSSEC. Web: `curl -sI https://grafana.<homeDomain> | grep -i strict-transport` zeigt HSTS.
  - [ ] Repo: `nix run nixpkgs#nixfmt -- --check $(git ls-files '*.nix')` ohne Meldung, die Prüfung aus 2.3 auf den gesamten Stand findet keine Domain, `nix run .#update-images -- --check` läuft durch.
  - [ ] Versionsstand: `cat /var/lib/prometheus-node-exporter/nixos-version.prom` auf jedem Host, Grafana-Dashboard „Security and Updates“ zeigt alle Hosts.
  - [ ] Clients: `kscreen-doctor -o` zeigt am Desktop VRR automatisch und HDR an. LibreWolf: https://coveryourtracks.eff.org (Fingerprinting-Schutz) und https://get.webgl.org (WebGL an). EasyEffects mit dem Preset `microphone` nur am Desktop. Persistierte Dateien sind Symlinks (`ls -la ~/.config/gwenviewrc ~/.bash_history`), `readlink ~/.ssh/id_ed25519.pub` zeigt in den Store, `~/.config/sops` gibt es nicht. In Plasma laufen keine Hyprland-Dienste: `systemctl --user is-active hypridle swaync` ist `inactive`.
  - [ ] Back In Time am Desktop: `ls /mount/Backup/backintime/NixOS-PC/jf/1/` zeigt tägliche Snapshots, ältere werden ausgedünnt.
  - [ ] Thunderbird: Kalender und Adressbuch von Stalwart erscheinen (Pfade `/dav/cal/<adresse>/default/` und `/dav/card/<adresse>/default/`; fehlen sie, Claude Bescheid geben, dann wird die URL in `thunderbird.nix` angepasst). Eine neue Mail im DLRG-Konto zeigt die Signatur.

## Phase 12 – Portable SSD (NixOS-Portable)

- [ ] 12.1 SSD anstecken, die ID ermitteln: `ls -l /dev/disk/by-id/ | grep -v part`. Die ID in `hosts/NixOS-Portable/disko.nix` statt `REPLACE-WITH-SSD-ID` eintragen und committen.
- [ ] 12.2 Den age-Key erzeugen: `nix shell nixpkgs#age -c age-keygen -o keys.txt` (außerhalb beider Repos), Public Key mit `nix shell nixpkgs#age -c age-keygen -y keys.txt`, Sicherung in KeePassXC als „age NixOS-Portable“ in `NixOS/Keys`, ohne URL. Dann in `.sops.yaml` als `sops_portable` eintragen und `sops updatekeys secrets/nixos-portable.yaml`.
- [X] 12.2b SSH-Schlüssel für Portable: am 07.11.2026 erzeugt, KeePassXC „SSH jf@NixOS-Portable“, Public Key in `nixosModules/system/ssh.nix`. Die Server lassen ihn nach ihrem nächsten Deploy herein. Zur Erinnerung, so wurde er angelegt:
  - [X] KeePassXC: neuer Eintrag „SSH jf@NixOS-Portable“ in `NixOS/Keys`, Benutzername `jf`, keine URL, Passwortfeld: neues Passwort (Reiter „Passwort“, 128 Zeichen, nur A-Z, a-z, 0-9). Speichern.
  - [X] Schlüssel im RAM erzeugen, als Passphrase das Passwort aus dem Eintrag einfügen: `d=$(mktemp -d -p /run/user/1000); ssh-keygen -t ed25519 -a 100 -C jf@NixOS-Portable -f "$d/id_ed25519"`
  - [X] Im Eintrag unter Erweitert → Anhänge die Datei `$d/id_ed25519` hinzufügen (der Pfad steht in `echo "$d"`). Reiter „SSH Agent“: Private key = Attachment `id_ed25519`, „Schlüssel zum Agenten hinzufügen, wenn die Datenbank geöffnet/entsperrt wird“ und „Schlüssel vom Agenten entfernen, wenn die Datenbank geschlossen/gesperrt wird“ anhaken. Den Public Key (`cat "$d/id_ed25519.pub"`) ins Notizfeld, speichern.
  - [X] Den Public Key in `nixosModules/system/ssh.nix` bei `authorizedKeys` als neue Zeile nach `jf@NixOS-Framework` eintragen (oder mir geben). Home Manager schreibt daraus auf Portable `~/.ssh/id_ed25519.pub`, die Server lassen den Schlüssel nach ihrem nächsten Deploy herein.
  - [X] Aufräumen: `shred -u "$d/id_ed25519" "$d/id_ed25519.pub"; rmdir "$d"`.
  - [ ] Nach der Installation (12.3) auf Portable: KeePassXC-Datenbank öffnen, `ssh-add -l` zeigt `jf@NixOS-Portable`, `ssh admin@NixOS-Server1 true` geht.
- [ ] 12.2a Die Werte des Server-Modus stehen seit 7.9a unter `server/` (7D-5). Hier nur noch die Klartext-Passwörter löschen, die keine Konfiguration liest (code-server nutzt nur den Hash in `codeserver/env`, Radicale nur `htpasswd`; beide Passwörter gehören nur in KeePassXC): `cd ~/Documents/nixos-private/secrets && for k in codeserver radicale; do sops unset nixos-portable.yaml "[\"server\"][\"$k\"][\"password\"]"; sops unset nixos-portable.yaml "[\"$k\"][\"password\"]"; done`. Fehlermeldungen für Schlüssel, die es nicht gibt, sind egal. Dann committen, `cd ~/Documents/nixos && nix flake update private && nix build --no-link .#nixosConfigurations.NixOS-Portable.config.system.build.toplevel` (ein fehlender Eintrag bricht mit `the key '…' cannot be found` ab).
- [ ] 12.3 Installieren (von diesem Rechner aus, die SSD ist angesteckt):
  - [ ] Passphrase-Datei (ohne Zeilenumbruch, landet nicht in der Shell-History): `(umask 077; read -rsp "LUKS passphrase: " p; printf '%s' "$p" > /tmp/secret.key); echo`
  - [ ] `sudo nix run github:nix-community/disko -- --mode destroy,format,mount --flake .#NixOS-Portable`
  - [ ] `sudo nixos-install --flake .#NixOS-Portable --root /mnt --no-root-passwd`
  - [ ] `sudo install -m 400 keys.txt /mnt/secrets/keys.txt; shred -u /tmp/secret.key`
- [ ] 12.3a Journal prüfen: in Plasma einmal an- und abmelden, neu starten, dann `journalctl -b -p err` und `coredumpctl list -S today`. Jede Meldung bewerten und in 13.1 eintragen. Erwartet: keine Coredumps nach dem Abmelden, kein `ordering cycle`, `systemctl --failed` und `systemctl --user --failed` sind leer. Eine einzelne Meldung `Failed to activate with specified passphrase` ist nur ein Tippfehler bei der LUKS-Eingabe.
- [ ] 12.4 Testen: Einen UEFI-Rechner (Secure Boot aus) und einen alten BIOS-Rechner davon booten. In der Bootauswahl den Eintrag mit `server` wählen: Die Dienste sind dann unter `https://<dienst>.portable.internal` erreichbar (selbstsigniertes Zertifikat einmal akzeptieren). Seit 07.11.2026 ohne Minecraft, Nextcloud und Collabora. Die Anmeldungen nutzen die Einträge aus `NixOS/Portable`, nicht die von Server1.
- [ ] 12.5 Kiwix-ZIMs, Jellyfin-Medien und die Ollama-/ComfyUI-Modelle (im Server-Modus `qwen3.5:4b`) nach `/persistent/server/...` kopieren.
- [ ] 12.6 Regelmäßig aktualisieren: `nixos-rebuild switch --flake .#NixOS-Portable --target-host` ist nicht möglich, wenn die SSD steckt. Stattdessen von ihr booten und `sudo nixos-rebuild switch --flake .#NixOS-Portable` ausführen.
- [ ] 12.7 Syncthing auf Portable einbinden (nach 12.3, Portable läuft):
  - [ ] Die Device ID aus „Syncthing NixOS-Portable“ (Notizfeld, aus 7F-S) mir geben oder selbst eintragen, in `nixosModules/userEnvironment/syncthing.nix` und in `hosts/NixOS-Server1/syncthing.nix` jeweils unter `devices` nach `NixOS-Framework`:

    ```nix
    NixOS-Portable = {
      name = "NixOS-Portable";
      id = "<Device ID>";
      autoAcceptFolders = false;
    };
    ```

    Dazu in beiden Dateien bei den Ordnern `Desktop`, `Documents`, `Downloads`, `Music`, `Pictures`, `aqbanking` und `FreeTube` in der Liste `devices` die Zeile `"NixOS-Portable"` nach `"NixOS-Framework"` ergänzen. `Videos` und die Handy-Ordner bleiben ohne Portable. Alle diese Ordner liegen auf Portable in der Persistenz.
  - [ ] Vorher auf Portable prüfen, ob genug Platz ist: `df -h /persistent` gegen die Größe der Ordner auf Server1 (`ssh admin@NixOS-Server1 'sudo du -sh /pool01/shares/jf/{Desktop,Dokumente,Downloads,Musik,Bilder,.aqbanking,FreeTube}'`).
  - [ ] Bauen und deployen: Server1 (`nixos-rebuild switch --flake .#NixOS-Server1 --build-host admin@NixOS-Server1 --target-host admin@NixOS-Server1 --sudo --ask-sudo-password`), Desktop (`sudo nixos-rebuild switch --flake .#NixOS-Desktop`), Framework und Convertible jeweils lokal, zuletzt Portable lokal (`sudo nixos-rebuild switch --flake .#NixOS-Portable`).
  - [ ] Prüfen: auf Portable `http://127.0.0.1:8384` zeigt alle anderen Geräte „Verbunden“, die Ordner gleichen ab (der erste Lauf überträgt alles, das dauert). Auf Server1 (`https://syncthing.<homeDomain>`) erscheint NixOS-Portable als verbunden.

## Phase 22 – SSH-Schlüssel und Syncthing erneuern (ganz zuletzt)

Erst wenn alles andere erledigt ist und der Funktionstest (Phase 21) passt. Grundregel: Der alte Schlüssel bleibt gültig, bis der neue nachweislich funktioniert. Zu jedem Server immer eine zweite SSH-Sitzung offen lassen, sie überlebt alle Schritte. Notfallzugang vorher prüfen: Server1 vor Ort (Monitor, Tastatur, Login `admin`), VPS über die VNC-Konsole im Contabo-Panel.

Deploy-Befehle, die unten gebraucht werden (im öffentlichen Repo auf dem Client, an dem du gerade arbeitest, die Repos liegen per Syncthing auf allen Clients):

```
nixos-rebuild switch --flake .#NixOS-Server1 --build-host admin@NixOS-Server1 --target-host admin@NixOS-Server1 --sudo --ask-sudo-password
nixos-rebuild switch --flake .#NixOS-ServerPublic --build-host admin@NixOS-ServerPublic --target-host admin@NixOS-ServerPublic --sudo --ask-sudo-password
nixos-rebuild switch --flake .#NixOS-ServerGaming --build-host admin@NixOS-ServerGaming --target-host admin@NixOS-ServerGaming --sudo --ask-sudo-password
```

- [ ] 22.1 Vorbereitung:
  - [ ] Beide Repos sauber (`git status`), Syncthing überall „Aktuell“.
  - [ ] Alte Fingerprints notieren. Client: `ssh-add -l`. Jeder Host: `for f in /persistent/etc/ssh/ssh_host_*_key.pub /persistent/etc/ssh/initrd_host_key.pub; do [ -e "$f" ] && ssh-keygen -lf "$f"; done`.
- [ ] 22.2 Benutzerschlüssel, ein Client nach dem anderen. Reihenfolge: Framework, Convertible, zuletzt Desktop (Portable hat seinen Schlüssel erst in 12.2b neu bekommen und bleibt hier außen vor; der Desktop deployt und steht in der initrd-Liste von Server1, bis zum Schluss bleibt er der funktionierende Zugang). Alles auf dem jeweiligen Client:
  - [ ] Neuen Schlüssel im RAM erzeugen (`<Host>` ersetzen, z. B. `NixOS-Framework`): `d=$(mktemp -d -p /run/user/1000); ssh-keygen -t ed25519 -a 100 -C jf@<Host> -f "$d/id_ed25519"`. Als Passphrase ein neues Passwort aus KeePassXC (Reiter „Passwort“, 128 Zeichen, nur A-Z, a-z, 0-9).
  - [ ] KeePassXC: neuer Eintrag „SSH jf@<Host> neu“ in `NixOS/Keys`, Passwortfeld = diese Passphrase, unter Erweitert → Anhänge `$d/id_ed25519` hinzufügen, Reiter „SSH Agent“: Private key = Attachment `id_ed25519`, beide Haken setzen, speichern. `ssh-add -l` zeigt jetzt beide Schlüssel.
  - [ ] Den neuen Public Key (`cat "$d/id_ed25519.pub"`) in `nixosModules/system/ssh.nix` bei `authorizedKeys` **unter** die alte Zeile mit `jf@<Host>` setzen, beide bleiben. Beim Desktop zusätzlich in `hosts/NixOS-Server1/machine.nix` bei `initrdssh.authorizedKeys` unter die alte Zeile. Solange die alte Zeile zuerst steht, schreibt Home Manager weiter den alten Key nach `~/.ssh/id_ed25519.pub`, ssh nutzt also noch den alten.
  - [ ] Alle drei Server deployen (Befehle oben), dann jeden Server mit dem neuen Schlüssel testen, am Agenten vorbei: `ssh -o IdentitiesOnly=yes -o IdentityAgent=none -i "$d/id_ed25519" admin@NixOS-Server1 true`, ebenso `admin@NixOS-ServerPublic` und `admin@NixOS-ServerGaming`. Fragt nach der Passphrase und endet ohne Fehler. Erst weiter, wenn alle drei gehen.
  - [ ] Umschalten: In `nixosModules/system/ssh.nix` (beim Desktop auch in `hosts/NixOS-Server1/machine.nix`) die alte Zeile `jf@<Host>` löschen. Diesen Client lokal neu bauen: `sudo nixos-rebuild switch --flake .#<Host>`. Prüfen: `cat ~/.ssh/id_ed25519.pub` zeigt den neuen Key, `ssh admin@NixOS-Server1 true` geht.
  - [ ] Alle drei Server noch einmal deployen, jetzt mit dem neuen Schlüssel. Damit ist der alte überall entfernt. Die übrigen Clients bekommen die Änderung bei ihrem nächsten Rebuild.
  - [ ] KeePassXC aufräumen: den alten Eintrag löschen (aus 5.1b heißt er „SSH id_ed25519 <Host>“), „SSH jf@<Host> neu“ in „SSH jf@<Host>“ umbenennen, Papierkorb der Datenbank leeren, speichern. Dann `shred -u "$d/id_ed25519" "$d/id_ed25519.pub"; rmdir "$d"`.
  - [ ] Forgejo (`https://forgejo.<homeDomain>` → Einstellungen → SSH-/GPG-Schlüssel): neuen Public Key hinzufügen, alten löschen. Dasselbe bei GitHub und Codeberg, falls dort ein Schlüssel dieses Clients hinterlegt ist. Prüfen: `git fetch` in einem Repo mit SSH-Remote.
  - [ ] Nur Desktop: Der neue Key steht erst im neuen initrd von Server1. Beim nächsten Neustart von Server1, solange du vor Ort bist: `ssh -p 2222 root@NixOS-Server1` und entsperren.
- [ ] 22.3 SSH-Hostkeys, Host für Host (Server1, ServerPublic, ServerGaming, dann die Clients). sshd startet pro Verbindung (`startWhenNeeded`) und liest die Schlüssel dabei neu, ein Neustart des Dienstes ist nicht nötig:
  - [ ] Sitzung A zum Host öffnen und offen lassen (bei Clients lokal im Terminal).
  - [ ] In Sitzung A: `sudo rm -f /persistent/etc/ssh/ssh_host_ed25519_key /persistent/etc/ssh/ssh_host_ed25519_key.pub /persistent/etc/ssh/ssh_host_rsa_key /persistent/etc/ssh/ssh_host_rsa_key.pub && sudo ssh-keygen -t ed25519 -N "" -f /persistent/etc/ssh/ssh_host_ed25519_key && sudo ssh-keygen -t rsa -b 4096 -N "" -f /persistent/etc/ssh/ssh_host_rsa_key && ssh-keygen -lf /persistent/etc/ssh/ssh_host_ed25519_key.pub`. Den angezeigten Fingerprint notieren. `/etc/ssh` liegt in der Persistenz, der initrd-Key (`initrd_host_key`) wird hier nicht angefasst.
  - [ ] Auf jedem Client den alten Eintrag entfernen, für jeden Namen, unter dem du den Host ansprichst: `ssh-keygen -R NixOS-Server1` (ebenso `ssh-keygen -R 10.100.0.1` usw. für WireGuard-Adressen). Dann `ssh admin@NixOS-Server1 true`, den Fingerprint mit dem notierten vergleichen, erst dann `yes`.
  - [ ] Sops ist nicht betroffen, die Hosts entschlüsseln mit `/secrets/keys.txt`. Zur Sicherheit den Host einmal deployen, die Dienste mit Secrets müssen danach laufen (`systemctl --failed` leer).
- [ ] 22.4 initrd-Hostkeys der Server (Server1, ServerPublic, ServerGaming), nur mit Konsolenzugang in Reichweite:
  - [ ] In einer Sitzung auf dem Server: `sudo rm -f /persistent/etc/ssh/initrd_host_key /persistent/etc/ssh/initrd_host_key.pub && sudo ssh-keygen -t ed25519 -N "" -f /persistent/etc/ssh/initrd_host_key && ssh-keygen -lf /persistent/etc/ssh/initrd_host_key.pub`. Fingerprint notieren.
  - [ ] Den Server deployen (Befehl oben). Erst damit kommt der neue Key ins initrd.
  - [ ] Auf jedem Client: `ssh-keygen -R '[NixOS-Server1]:2222'` (bzw. den Namen oder die IP des VPS mit `:2222`).
  - [ ] Beim nächsten geplanten Neustart: `ssh -p 2222 root@<host>`, Fingerprint vergleichen, entsperren. Klappt es nicht, über die Konsole entsperren. Der alte Key ist dann noch im initrd, sonst ist nichts kaputt.
- [ ] 22.5 Syncthing, alle fünf Hosts in einem Zug (neues Zertifikat heißt neue Geräte-ID, die Ordner und Daten bleiben):
  - [ ] Vorher: Alle Geräte online und überall „Aktuell“ (Server1: `https://syncthing.<homeDomain>`, Clients: `http://127.0.0.1:8384`). Bis zum Ende von 22.5 nichts in synchronisierten Ordnern ändern, sonst entstehen Konflikte.
  - [ ] Auf dem Desktop alle fünf Zertifikate im RAM erzeugen: `for h in desktop framework convertible portable server1; do mkdir -p /run/user/1000/st/$h; echo "== $h"; nix shell nixpkgs#syncthing -c syncthing generate --home /run/user/1000/st/$h 2>&1 | grep -i 'device id'; done`. Die fünf Device IDs notieren.
  - [ ] KeePassXC: in jedem Eintrag „Syncthing NixOS-<Host>“ (`NixOS/Keys`) die Anhänge `cert.pem` und `key.pem` durch die neuen aus `/run/user/1000/st/<host>/` ersetzen, die neue Device ID ins Notizfeld, speichern.
  - [ ] Sops, ohne die Dateien im Editor zu öffnen (jq macht aus der PEM-Datei einen JSON-String, `--value-stdin` hält den Schlüssel aus der Prozessliste):

    ```
    cd ~/Documents/nixos-private/secrets
    for h in desktop framework convertible; do for k in cert key; do nix shell nixpkgs#jq -c jq -Rs . < /run/user/1000/st/$h/$k.pem | sops set --value-stdin clients.yaml "[\"syncthing\"][\"nixos-$h\"][\"$k\"]"; done; done
    for k in cert key; do nix shell nixpkgs#jq -c jq -Rs . < /run/user/1000/st/portable/$k.pem | sops set --value-stdin nixos-portable.yaml "[\"syncthing\"][\"nixos-portable\"][\"$k\"]"; done
    for k in cert key; do nix shell nixpkgs#jq -c jq -Rs . < /run/user/1000/st/server1/$k.pem | sops set --value-stdin nixos-server1.yaml "[\"syncthing\"][\"nixos-server1\"][\"$k\"]"; done
    ```

  - [ ] Die fünf neuen Device IDs in `nixosModules/userEnvironment/syncthing.nix` und `hosts/NixOS-Server1/syncthing.nix` bei `devices` eintragen (jeweils die alte ID des Hosts ersetzen, das Handy `GraphenOS` bleibt).
  - [ ] Beide Repos committen, `nix flake update private`, dann alle fünf Hosts direkt nacheinander deployen: Server1 (Befehl oben), Desktop lokal `sudo nixos-rebuild switch --flake .#NixOS-Desktop`, Framework, Convertible und Portable jeweils lokal mit ihrem Namen. Bis ein Host deployt ist, verbindet er sich nicht mit den anderen, Daten gehen dabei nicht verloren.
  - [ ] Prüfen: In jeder Oberfläche sind alle Geräte „Verbunden“ und alle Ordner nach dem Abgleich wieder „Aktuell“. Der erste Abgleich vergleicht alle Dateien und dauert, überträgt aber nur Unterschiede.
  - [ ] Handy: 23.2.
  - [ ] Aufräumen: `find /run/user/1000/st -type f -exec shred -u {} +; rm -r /run/user/1000/st`.
- [ ] 22.6 Danach aus Phase 21 wiederholen: 21.1 (alle Hosts), 21.6 (WireGuard und SSH), den Syncthing-Teil von 21.3 und 21.7.

## Phase 23 – Handy und andere Geräte (ganz am Ende)

Alles, was du am Handy (GrapheneOS), an Melis Rechner und an anderen Geräten nachtragen musst, gesammelt in einem Zug. Bis hierhin fehlen dort die neuen Werte aus Phase 20 und 22: Syncthing, SMB, Kalender und WLAN gehen am Handy so lange nicht. Die Werte immer aus KeePassXC kopieren (am Handy aus KeePassDX mit der neuen Datenbank, 23.0 zuerst), nie abtippen, nie per Chat oder Mail verschicken.

- [ ] 20.3 WLAN-Passwort, zusammen mit der Neueinrichtung des Heimnetzes (Entscheidung 08.11.2026: am Ende) (nur noch das Heimnetz `HOME`, der Hotspot ist seit 07.11.2026 nicht mehr vordefiniert):
  - [ ] Neues Passwort in KeePassXC („WiFi HOME“ in `NixOS/Devices`), Reiter „Passwort“, 63 Zeichen, nur A-Z, a-z, 0-9. WPA erlaubt 8 bis 63 Zeichen, die FRITZ!Box höchstens 63. Abgetippt wird es nie: neue Geräte per QR-Code aus der FRITZ!Box (WLAN → Sicherheit) verbinden.
  - [ ] Zuerst in der FRITZ!Box (WLAN → Sicherheit, WPA3) ändern, sofort danach in sops `wifi` die Zeile `ENV_HOME_PSK=…` ersetzen, in `clients.yaml` und `nixos-portable.yaml`.
  - [ ] Committen, `nix flake update private`, alle Clients deployen. Laptops bis dahin per Kabel oder von Hand mit dem Handy-Hotspot verbinden. Die übrigen WLAN-Geräte (Handy, TV, Drucker, …) verlieren das WLAN bis 23.7.
  - [ ] Alten KeePassXC-Eintrag „WiFi HOTSPOT“ löschen. Auf jedem Client prüfen, dass kein altes Profil übrig ist: `nmcli connection show` zeigt nur noch das Heimnetz als vordefiniertes Profil.

- [ ] 23.0 Zuerst die KeePassXC-Datenbank aufs Handy bringen (Syncthing geht erst nach 23.2): per USB-Kabel in den Ordner von KeePassDX kopieren, in KeePassDX öffnen, ein Eintrag aus Phase 20 zeigt den neuen Wert.
- [ ] 23.1 WireGuard: In der WireGuard-App „+“ → „Neu erstellen“, Name `wg0`, beim privaten Schlüssel auf „Generieren“ tippen, Adressen `10.100.0.10/24`, DNS-Server `10.100.0.2`. „Peer hinzufügen“: Öffentlicher Schlüssel `WM3RI8KfcnWXoPzSWc0k/Xv3ZDC9vEsWER7w7u+y4w8=` (ServerPublic), Endpunkt `<ipv4 von ServerPublic>:51820` (`$PRIV/site.nix` → `serverPublic.ipv4`), Zulässige IPs `10.100.0.0/24`, Persistentes Keepalive `25`. Speichern. Den öffentlichen Schlüssel der App (steht unter dem privaten) in KeePassXC „WireGuard GrapheneOS“ (`NixOS/Keys`) ins Notizfeld und in `nixosModules/system/wireguard.nix` bei `GrapheneOS` statt `publicKey = null;` eintragen (oder mir geben). Dann ServerPublic deployen: `nixos-rebuild switch --flake .#NixOS-ServerPublic --build-host admin@NixOS-ServerPublic --target-host admin@NixOS-ServerPublic --sudo --ask-sudo-password`. Prüfen: Tunnel in der App einschalten, im mobilen Netz `https://grafana.<homeDomain>` öffnen, auf ServerPublic zeigt `sudo wg show` bei GrapheneOS einen Handshake.
- [ ] 23.2 Syncthing (nach 22.5): In der Syncthing-App unter „Geräte“ die alten Einträge NixOS-Desktop, NixOS-Framework, NixOS-Convertible und NixOS-Server1 löschen. Mit „+“ jeweils neu anlegen: Geräte-ID aus dem Notizfeld von „Syncthing NixOS-<Host>“ (`NixOS/Keys`), Name wie der Host. Dann unter „Ordner“ bei `Downloads`, `Android`, `GraphenOS`, `Pixel 6a Kamera`, `Pixel 6a Musik` und `Wichtige Dateien` jeweils NixOS-Server1 (und bei `Downloads` die Clients) wieder freigeben. Die Daten bleiben, der erste Abgleich vergleicht nur. Prüfen: alle Ordner „Aktuell“, eine neue Datei in `Downloads` erscheint auf dem Desktop.
- [ ] 23.3 SMB jf (nach 20.4): im Dateimanager des Handys die Freigabe `smb://NixOS-Server1` bearbeiten, Benutzer `jf`, Passwort aus „SMB jf“ (`NixOS/Server1`), speichern, einen Ordner öffnen. Windows-Geräte: Systemsteuerung → Anmeldeinformationsverwaltung → Windows-Anmeldeinformationen → Eintrag `NixOS-Server1` → Bearbeiten, neues Passwort, dann `\\NixOS-Server1` im Explorer öffnen.
- [ ] 23.4 SMB meli (nach 20.4): Meli das Passwort aus „SMB meli“ (`NixOS/Server1`) persönlich geben, am besten direkt an ihrem Rechner aus KeePassXC kopiert, nicht per Messenger. An ihrem Rechner: Windows wie in 23.3 (Anmeldeinformationsverwaltung → `NixOS-Server1` → Bearbeiten, Benutzer `meli`), unter Linux im Dateimanager die gespeicherte Freigabe bearbeiten bzw. das Passwort im Schlüsselbund ersetzen. In ihrem Bitwarden den Eintrag für den Server (Benutzer `meli`) öffnen → Bearbeiten → Passwort ersetzen → Speichern, damit der alte Wert nicht weiter angeboten wird. Prüfen: Meli öffnet einen Ordner auf `\\NixOS-Server1`.
- [ ] 23.5 Radicale (nach 20.4): DAVx5 → Konto `jf` → Einstellungen → Passwort aus „Radicale jf“ (`NixOS/Server1`) einfügen, „Jetzt synchronisieren“. Prüfen: ein Testtermin aus Thunderbird erscheint im Kalender des Handys.
- [ ] 23.6 Mail (nach 8.8 und 20.4): In der Mail-App (Sterna Mail für JMAP, sonst die vorhandene App) die Stalwart-Konten einrichten: Adresse, Passwort aus „Mailbox jf@“ (`NixOS/ServerPublic`), Server `mail.<domain>`. Bei Proton, DLRG und 1&1 das neue Passwort aus „Proton“, „DLRG“, „1&1“ (`NixOS/Providers`) eintragen. Prüfen: eine Mail an dich selbst kommt am Handy an.
- [ ] 23.7 WLAN (direkt nach 20.3): In der FRITZ!Box unter WLAN → Sicherheit den QR-Code anzeigen, am Handy unter Einstellungen → Netzwerk → Internet → „+“ → QR-Symbol scannen. Ebenso TV, Drucker und alle übrigen WLAN-Geräte, die Gästen gehören über das Gast-WLAN.
- [ ] 23.8 Briar-Mailbox (nach 8.8): auf ServerPublic `journalctl -u podman-briar-mailbox | tail -40` zeigt den QR-Code. In Briar → Einstellungen → Mailbox → „Mailbox einrichten“ → scannen. Prüfen: Briar zeigt die Mailbox als verbunden.
- [ ] 23.9 ntfy (nach 10.2): ntfy-App → Einstellungen → Benutzer → „+“, Server `https://push.<domain>`, Benutzer `jf`, Passwort aus „ntfy jf“ (`NixOS/ServerPublic`). Das Alarm-Topic abonnieren (`ALERT_TOPIC`, steht in `ntfy/env`). Prüfen: der Test-Alarm aus 21.6 kommt an.
- [ ] 23.10 Apps mit Token, die angemeldet bleiben sollten (Home Assistant, Jellyfin, Element, Molly): je einmal öffnen. Fragt eine nach dem Passwort, aus dem passenden KeePassXC-Eintrag eintragen („Home Assistant“, „Jellyfin“ in `NixOS/Server1`, „Matrix jf“ in `NixOS/ServerPublic`).
- [ ] 23.12 Optional neue Apps: Capy Reader oder Read You für Miniflux (Server `https://rss.<domain>`, eigener API-Schlüssel in Miniflux → Einstellungen → API-Schlüssel, in KeePassXC „Miniflux“ als zusätzliches Attribut), Sterna Mail für JMAP, ntfy für UnifiedPush (README).
- [ ] 23.13 Abschlusstest am Handy, im mobilen Netz mit WireGuard: Dateimanager (SMB), DAVx5, Mail, Element (Sprachanruf über coturn mit einem zweiten Gerät im WLAN), Molly/ntfy, Home Assistant, Jellyfin, Syncthing, KeePassDX öffnet die aktuelle Datenbank.

## Phase 19 (Ende) – Testdienste auf ServerGaming entfernen
- [ ] 19.5 Daten sichern, die bleiben sollen (Nextcloud-Dateien, Kalender und Kontakte), z. B. per Nextcloud-Client oder `sudo -u nextcloud nextcloud-occ` Export.
- [ ] 19.6 `hosts/NixOS-ServerGaming/temp/` löschen und die Zeile `./temp` in `hosts/NixOS-ServerGaming/default.nix` und `hosts/NixOS-VMServerGaming/default.nix` entfernen. Den Abschnitt „ServerGaming: Test“ in `nixosModules/server/management/glance-server-page.nix` löschen. Bauen, deployen.
- [ ] 19.7 Reste auf dem Server löschen: `/persistent/var/lib/nextcloud`, die PostgreSQL-Datenbank `nextcloud` (`sudo -u postgres dropdb nextcloud`), `/persistent/var/lib/redis-nextcloud`.
- [ ] 19.8 DNS-Einträge `cloud`, `office`, `code` und `countdown` löschen, Secret `codeserver/env` aus `nixos-servergaming.yaml` entfernen.

## Phase 24 – Wartung und Beobachten, ohne Termin

- [ ] 24.1 Invidious: Die Wiedergabe braucht seit 2025 den eigenen Dienst Invidious companion. Er fehlt in nixpkgs (kein Paket, keine Option im Modul `services.invidious`, Stand 07.11.2026), deshalb zeigt Invidious auf Server1 nur Seiten und Suche, keine Videos. Bei Updates von nixpkgs nachsehen: `nix search nixpkgs invidious-companion` und die Optionen von `services.invidious` (Suche nach `companion` auf search.nixos.org). Gibt es ein Paket oder eine Option, companion mit gemeinsamem Schlüssel aus sops einbinden (`invidious_companion` und `invidious_companion_key` in den Einstellungen) und das auskommentierte `sig-helper` in `nixosModules/server/tools/invidious.nix` entfernen. Bis dahin wäre nur ein Podman-Container möglich (`quay.io/invidious/invidious-companion`, Updates von Hand). Prüfen, ob YouTube die Adresse von Server1 sperrt („Sign in to confirm you're not a bot“), wenn der Verkehr über Mullvad geht.
- [ ] 24.2 KeePassXC Auto-Type unter Plasma-Wayland: Solange die Plasma-Bildschirmtastatur als Eingabemethode aktiv ist, bleibt nach Auto-Type mit Großbuchstaben Shift systemweit hängen, bis zum Abmelden ([keepassxc#13846](https://github.com/keepassxreboot/keepassxc/issues/13846), Ursache in KDE: [Bug 520990](https://bugs.kde.org/show_bug.cgi?id=520990), am 08.11.2026 noch offen, ein Merge Request für KWin ist verlinkt, getestet mit Plasma 6.8.2 und KeePassXC 2.8.0). Die Bildschirmtastatur bleibt bewusst auf allen Clients aktiv, Auto-Type mit Großbuchstaben ist bis zum Fix kaputt. Bei Plasma-Updates prüfen: `curl -s 'https://bugs.kde.org/rest/bug/520990?include_fields=status,resolution,cf_versionfixedin'` zeigt `RESOLVED`/`FIXED` und die Version. Ist die Version installiert (`plasmashell --version`), in Kate ein Passwort mit Großbuchstaben per Auto-Type tippen lassen, danach muss Shift wieder normal funktionieren.
- [ ] 24.3 CryptPad: nixpkgs hat noch 2025.9.0 (Stand 08.11.2026), aktuell ist 2026.10.0. Das Update liegt als [nixpkgs#511890](https://github.com/NixOS/nixpkgs/pull/511890) offen (seit 20.04.2026, das Paket bündelt OnlyOffice und ist aufwendig). Nach jedem `nix flake update` prüfen: `nix eval --raw .#nixosConfigurations.NixOS-ServerPublic.config.services.cryptpad.package.version`. Ein eigenes Overlay lohnt nicht, die Versionen hängen an den OnlyOffice-Builds.

- [ ] 13.5 Ventoy ist mit Version (1.1.18) als unsicheres Paket erlaubt (`nixosModules/system/nixos.nix`). Die Version nach nixpkgs-Updates anpassen.
- [ ] 13.13 Blocklisten aktualisiert `nix flake update` (`blocklistproject`, `perflyst`, `stevenBlack` sind `github:`-Inputs). Die Grafana-Dashboards haben kein Repo, ihre Revision steht als Zahl in `flake.nix` und wird dort von Hand erhöht, `revisions/latest` bricht auf frischen Hosts mit `mismatch in field narHash` ab. Pins aktuell halten: Der Update-Check meldete am 01.11.2026 Dangerzone v0.11.1 (gepinnt ist v0.11.0), dazu neuere Commits und Images. Ablauf in [`docs/updates-and-vulnerabilities.md`](docs/updates-and-vulnerabilities.md).
- [ ] 13.18 Server nach dem Einspielen von Updates neu starten. Kernel und initrd greifen erst dann, Server1 und die VPS warten danach auf die LUKS-Entsperrung per SSH.
- [ ] 13.19 `flake.lock` am 03.11.2026 aktualisiert (Kernel 7.3.1, Hyprland 0.57). Angepasst: `boot.initrd.systemd.enable` und `preLVM` entfallen, Nextcloud-Admin per `nextcloud-occ` (8.8), Ventoy 1.1.18. Nach jedem Update alle Hosts bauen.
- [ ] 13.20 Lutris ist auf NixOS-Portable aus, die FHS-Umgebung braucht GTK2, das nixpkgs als kaputt markiert. Nach einem Update wieder in `hosts/NixOS-Portable/home/home.nix` aktivieren.
- [ ] 13.21 Overlay `pkgs/default.nix`: `sqliteschema` und `SimpleSQLite` verlangen `typepy < 2`, nixpkgs liefert 2.0 (für `sbomnix` bzw. `vulnscan`). Die Grenze ist per `pythonRelaxDeps` gelockert. Nach einem Update prüfen, ob nixpkgs das selbst behoben hat, dann den Block entfernen.
- [ ] 13.22 `nixosModules/virtualisation/kvm.nix`: `vendor-reset` installiert in nixpkgs nur die `.ko`. Seit Kernel 7.3 erwartet `aggregateModules` zu jedem externen Modul eine `.ko.cer`, sonst scheitert `linux-*-modules`. Der Override installiert über kbuilds `modules_install` (wie `broadcom-sta` in nixpkgs). Nach einem Update prüfen, ob das Paket in nixpkgs selbst `modules_install` nutzt, dann den Override entfernen.
- [ ] 11.7 Die JMAP-Unterstützung von Thunderbird regelmäßig prüfen: roadmaps.thunderbird.net (Desktop, Android, iOS).

## Ideen für später (keine Aufgaben)
Gesammelt, damit sie nicht verloren gehen. Erst bei Bedarf in eine Phase übernehmen.

- [ ] 15.5 Cloudflare ersetzen: Registrar, DNS (deSEC) und DDoS-Schutz auswählen ([`docs/providers.md`](docs/providers.md)), dann `dnsProvider` und `nginx/acme/api_key` anpassen.
