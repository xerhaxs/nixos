# Kontext für Claude Code

Das Repo ist öffentlich: Hier nichts Privates ablegen (keine Domains, Adressen, Secrets). Private Daten liegen in `/mount/Data/Datein/Dokumente/nixos-private` (Flake-Input `private`).

## Einstieg

- Offene Arbeit: [`TODO.md`](TODO.md) (Reihenfolge) und [`CHECKLIST.md`](CHECKLIST.md) (Abnahme). Dort steht der Stand, hier nur das, was man sonst neu herausfinden müsste.
- Aufbau: [`README.md`](README.md), jeder Ordner hat eine eigene `README.md`.
- Hintergrund: [`docs/`](docs/README.md). `Notes/` ist per `.gitignore` lokal.

## Regeln

- Mit dem Benutzer Deutsch sprechen. `TODO.md` und `CHECKLIST.md` sind deutsch, READMEs und Code-Kommentare englisch, Kommentare minimal.
- Nur committen, wenn es ausdrücklich verlangt wird. Branch ist `rework`, `main` erst in Phase 17.
- Flakes ignorieren untracked Dateien: Neue `.nix`-Dateien vor dem Build mit `git add` aufnehmen.
- `.nix` mit nixfmt formatieren, Import- und Bundle-Listen alphabetisch, neue Optionen in der README des Ordners nachtragen.
- Die Claude-Shell hat kein `sudo` (Passwort nötig). Was root braucht (`nixos-rebuild`, `chown`), führt der Benutzer aus. Bauen geht ohne root: `nix build .#nixosConfigurations.<host>.config.system.build.toplevel`.

## Stolperfallen dieses Systems

- `/` und `/home/jf` sind tmpfs. Was nicht in `home.persistence."/persistent"` steht, ist nach dem Reboot weg. Neue Programme also immer mit Persistenz anlegen.
- Die Aktivierung läuft im initrd (`initrd-nixos-activation-start`). Alles, was sie unter `/persistent` anlegt, muss dort schon gemountet sein, deshalb `neededForBoot` auf `/persistent/home`. Ohne das landen neue Ordner verdeckt im root-Subvolume, systemd legt die echten als `root:root` an.
- Persistierte Dateien immer mit `method = "symlink"`. Bind-Mounts vertragen kein Ersetzen per Rename (`EBUSY`), das trifft KDE-Konfigurationen und `~/.claude.json`.
- Scheitert `home-manager-jf.service`, fehlen alle Links im Home, und zwar auf einmal: Hyprland ohne Konfiguration, Plasma ohne Autostart-Skripte, keine Erweiterungen. Bei seltsamem Desktop-Verhalten zuerst `systemctl status home-manager-jf` ansehen.
- Alle `home.activation`-Schritte teilen sich eine Shell. `USER`, `HOME`, `PATH` nicht überschreiben, und ein `exit` beendet die gesamte Aktivierung, auch mit Status 0. Ein `exit=0` beweist also nichts, die Schritte bis `waypaperConfig` zählen.
- `home.activation` läuft mit `set -eu -o pipefail`. `befehl | grep -q` kann dort trotz Treffer falsch sein (SIGPIPE, Status 141). Ausgabe erst in eine Variable lesen. Dasselbe Skript verhält sich in `writeShellScript` anders, dort gilt kein `pipefail`.
- Dienste, die sich bei einem Anbieter anmelden, brauchen ihren Zustand in der Persistenz, auch im Server-Modul (Beispiel Mullvad: `/etc/mullvad-vpn`, sonst ein neues Gerät pro Boot).
- Hyprland-Dienste gehören an `hyprland-session.target`, nicht an `graphical-session.target`, sonst laufen sie auch in Plasma. D-Bus-aktivierbare Dienste brauchen zusätzlich `ConditionEnvironment=XDG_CURRENT_DESKTOP=Hyprland` (Beispiel swaync).
- Nerd-Font-Icons aus U+E000 bis U+F8FF gehen beim Schreiben von Dateien verloren und hinterlassen leere Strings. Glyphen ab U+F0000 verwenden, per `printf` einsetzen und danach mit `grep -cP` prüfen.
- `findmnt` zeigt keine `x-`-Optionen. Für `x-initrd.mount` in `/etc/fstab` nachsehen.

## Testen ohne Reboot

Eine Home-Manager-Generation lässt sich mit bubblewrap gegen ein leeres Home ausführen (`--ro-bind / /`, leeres `/home/jf`, `/run/user/1000` als tmpfs, `<generation>/activate --driver-version 1`). Hyprland startet darin verschachtelt, wenn der Wayland-Socket hineingereicht wird, `hyprctl configerrors`, `binds`, `plugin list` funktionieren dann.

Design prüfen: Die Fenster sieht man nur auf Screenshots wirklich. Im verschachtelten Hyprland `hyprctl output create headless PREVIEW` ausführen, `WAYLAND-1` per `hyprctl eval` deaktivieren und mit `grim` aufnehmen. Der Wayland-Ausgang liefert keine Frames, wenn Plasma gesperrt ist. Für Konfigurationen reicht `XDG_CONFIG_HOME=<generation>/home-files/.config`, dann ist keine Aktivierung nötig und es liegen keine Secrets in der Sandbox. Das Home-Manager-Paket allein baut schneller: `...users.jf.home.activationPackage`.

Achtung: `home.activation` spricht mit laufenden System-Daemons. `/run/mullvad-vpn` mit `--ro-bind /dev/null` abdecken, sonst loggt `mullvadSetup` den echten Daemon ein. Die Sandbox enthält danach echte Secrets, also wieder löschen.
