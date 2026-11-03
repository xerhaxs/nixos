# Abnahme-Checkliste

Prüf- und Abnahmeprotokoll aller Änderungen, aus beiden Arbeitsrunden. Die Reihenfolge der Umsetzung (Commit, Rebuild, Secrets) steht in [`TODO.md`](TODO.md). Hier geht es darum, ob alles richtig umgesetzt ist und funktioniert.

Spalte „Prüfung“: Befehl oder Handgriff, mit dem du die Änderung bestätigst. Ein Häkchen setzt du, wenn sie bestanden ist. „Eval“ heißt: Ich habe nur geprüft, dass die Konfiguration evaluiert. „Build“ heißt: Ich habe die relevante Ableitung gebaut. Laufzeittests auf echter Hardware stehen bei allen Punkten noch aus.

Stand der Verifikation durch mich: Alle neun Hosts evaluieren (`nix eval .#nixosConfigurations.<host>.config.system.build.toplevel.drvPath`). Gebaut habe ich DangerZone, hyprgrass, hyprtasking, hypr-dynamic-cursors, die Hyprland-Lua-Konfiguration (`Hyprland --verify-config`: „config ok“), die sshd-Konfiguration (`sshd -t`), chrony.conf (`chronyd -p`), die nginx-Konfiguration mit gixy (ServerPublic, Portable-Server-Modus), WKD (Testschlüssel), die Loki-Regeln und die auditd-Unit. Komplette Systembuilds und Laufzeittests habe ich nicht durchgeführt.

## A. Struktur und Repositories

| ✓ | Änderung | Wo | Prüfung |
|---|---|---|---|
| [ ] | Privates Repo als Flake-Input `private` (Domains, Adressen, Secrets) | `flake.nix`, `$PRIV/site.nix` | `nix flake metadata \| grep private` |
| [ ] | Domains als Variablen: `domain`, `homeDomain`, `mailDomain`, dazu `acmeEmail`, `alertEmail`, `mailAddress`, `pgpFingerprint` | `nixosModules/system/site.nix` | `nix eval .#nixosConfigurations.NixOS-Server1.config.nixos.site.homeDomain` |
| [ ] | Keine privaten Domains im öffentlichen Repo (SearXNG-Footer jetzt per Variable) | gesamtes Repo | `git grep -iE "<domain>\|<maildomain>"` findet nur die Git-Autoradresse |
| [ ] | Hosts: Profil (`configuration.nix`, `server.nix`) getrennt von Maschine (`machine.nix`, `disko.nix`, `hardware-configuration.nix`) | `hosts/*` | `hosts/README.md` lesen |
| [ ] | VM-Hosts als schlanke Kopien: VMDesktop, VMServer, VMServerPublic (neu) | `hosts/NixOS-VM*` | `nixos-rebuild build-vm --flake .#NixOS-VMServer` |
| [ ] | Neuer Host NixOS-Portable | `hosts/NixOS-Portable` | Abschnitt H |
| [ ] | Eigene Pakete als Overlay (`pkgs/`), `nix build .#dangerzone` | `pkgs/`, `flake.nix` | `nix build .#dangerzone` |
| [ ] | Englische README in jedem Ordner (einheitlich, ohne Emojis), Kommentare minimal und englisch | `*/README.md` | Stichproben, z. B. `homeModules/desktop/windowManager/hyprland/README.md` |
| [ ] | Hintergrunddokumente | `docs/` | `docs/README.md` |
| [ ] | Import- und Bundle-Listen alphabetisch (Ordner vor Dateien), alle `.nix` mit nixfmt formatiert | gesamtes Repo | `nix run nixpkgs#nixfmt -- --check $(git ls-files '*.nix')` |

## B. System und Sicherheit

| ✓ | Änderung | Wo | Prüfung |
|---|---|---|---|
| [ ] | `stateVersion` pro Host, Flake-autoUpgrade (Server, ohne Reboot) | `hosts/*/machine.nix`, bei Framework und Convertible `configuration.nix` | `systemctl list-timers \| grep nixos-upgrade` auf den Servern |
| [ ] | Power-Taste fährt sofort herunter, logind auf allen Hosts, upower `PowerOff` bei 3 % | `nixosModules/system/powermanagement.nix` | Laptop: `upower -d \| grep -i action` |
| [ ] | Hardening: sysctls, Kernel-Parameter, Modul-Blacklist, hidepid, auditd, sudo-Log, Coredump-Limits | `nixosModules/system/hardening.nix` | `sysctl kernel.kptr_restrict`, `cat /proc/cmdline`, `mount \| grep hidepid` |
| [ ] | Neu: `dev.tty.ldisc_autoload=0`, `vm.unprivileged_userfaultfd=0` | dito | `sysctl dev.tty.ldisc_autoload vm.unprivileged_userfaultfd` |
| [ ] | Neu (Server): `vm.mmap_rnd_bits=32`, `mmap_rnd_compat_bits=16`, `oops=panic`, `kernel.panic=10` | dito | auf Server1: `sysctl vm.mmap_rnd_bits kernel.panic`, `grep oops /proc/cmdline` |
| [ ] | Neu: `pti=on`, `audit=1` | dito | `cat /proc/cmdline`, `grep -i pti /sys/devices/system/cpu/vulnerabilities/meltdown` |
| [ ] | Neu: setuid-Wrapper su, sg, newgrp, sudoedit entfernt | dito | `ls /run/wrappers/bin` (kein `su`), `sudo -i` funktioniert |
| [ ] | Neu: `environment.defaultPackages = []` | dito | `which nano` findet nichts (rsync/strace weiterhin aus `common.nix`) |
| [ ] | Neu: chrony mit NTS statt timesyncd | dito | `chronyc -N authdata` (NTS-Quellen mit `NTS`), `chronyc sources` |
| [ ] | Neu: lynis, kernel-hardening-checker | dito | `sudo lynis audit system` |
| [ ] | Neu (Server): auditd protokolliert jedes execve, Rotation 5 × 50 MB, Audit im Journal | dito | `sudo auditctl -l \| grep exec`, `ls -la /var/log/audit` |
| [ ] | Neu (Server): geoclue, ModemManager, avahi aus (außer wo ein Modul sie braucht, z. B. Home Assistant) | dito | `systemctl status ModemManager` auf Server1/ServerPublic |
| [ ] | Neu: Hardened Malloc auf ServerPublic | `hosts/NixOS-ServerPublic/configuration.nix` | `cat /etc/ld-nix.so.preload`, alle Dienste laufen: `systemctl --failed` |
| [ ] | Neu: ServerPublic antwortet nicht auf IPv4-Ping | dito | `ping <ip>` ohne Antwort, `ping6` funktioniert |
| [ ] | Neu: ESP mit `fmask/dmask=0077`, `nosuid,nodev,noexec`; `/secrets` mit `nosuid,nodev,noexec` | `nixosModules/disko/disko-luks-btrfs-tmpfs.nix` | `findmnt /boot /secrets`, keine `bootctl`-Warnung im Journal |
| [ ] | Neu (Fix): LUKS sucht beim Boot nicht mehr `/tmp/secret.key` (disko `passwordFile`) | dito | `journalctl -b -p err \| grep secret.key` ist leer |
| [ ] | Neu (Fix): `/etc/machine-id` persistiert | `nixosModules/system/persistent.nix` | Nach zwei Reboots: `journalctl --list-boots` zeigt mehrere Boots |
| [ ] | SSH: nur Keys, AllowUsers, LoginGraceTime, sshguard, `listenAddresses` (ServerPublic nur über WireGuard) | `nixosModules/system/ssh.nix` | `ssh -v` zeigt `publickey` als einzige Methode |
| [ ] | Neu: SSH PQ-KEX (mlkem768x25519), AEAD-Ciphers, ETM-MACs, MaxAuthTries 3, LogLevel VERBOSE, ClientAlive | dito | `ssh -vv server 2>&1 \| grep "kex: algorithm"` zeigt `mlkem768x25519-sha256` |
| [ ] | Neu: SSH-Client bietet den Servern nur den eigenen Key an | `homeModules/base/ssh.nix` | `ssh -v NixOS-Server1 2>&1 \| grep Offering` (nur ein Key) |
| [ ] | Initrd-SSH zum Entsperren der Server | `nixosModules/system/initrdssh.nix` | nach Reboot: `ssh root@<server>` (ServerPublic Port 2222) |
| [ ] | Secure Boot: Keys werden jetzt automatisch erzeugt (`autoGenerateKeys`) | `nixosModules/system/secureboot.nix` | `sudo sbctl status` |
| [ ] | TPM2 + PIN optional | disko `tpm2` | README → TPM2 + PIN |
| [ ] | Neu: Initiale Passwörter pro Host (sha512crypt, 500 000 Runden) aus dem privaten Repo, Klartext in sops | `nixosModules/system/user.nix`, `$PRIV/site.nix`, `$PRIV/secrets/initial-passwords.yaml` | Login mit dem Passwort aus `sops -d initial-passwords.yaml` |
| [ ] | sops: Secrets in den Modulen deklariert, pro Host eine Datei (`perHostFile`) | `nixosModules/system/sops.nix` | `ls /run/secrets` enthält nur die Secrets des Hosts |
| [ ] | ClamAV mit zusätzlichen Verzeichnissen und Ausnahmen, Alarm per Mail/ntfy | `nixosModules/system/clamav.nix` | `systemctl list-timers \| grep clamdscan` |
| [ ] | Benachrichtigungen (Mail über msmtp, ntfy) bei fehlgeschlagenen Units, SMART, ZFS | `nixosModules/system/notify.nix` | nach Phase 10: `systemctl start notify-test` bzw. eine Unit absichtlich scheitern lassen |
| [ ] | Killswitch über ntfy (Home-Assistant-Button) | `nixosModules/system/killswitch.nix` | nach Phase 10: Test-Topic an eine VM senden |

## C. Netzwerk

| ✓ | Änderung | Wo | Prüfung |
|---|---|---|---|
| [ ] | LAN-Optionen (`lan.*`) als einzige Quelle für `/etc/hosts` und Pi-hole | `nixosModules/system/networking.nix` | `getent hosts grafana.<homeDomain>` |
| [ ] | Neu: DNS-Namen `comfyui`, `grafana`, `homebox`, Liste sortiert | dito | `dig @10.75.0.21 homebox.<homeDomain>` |
| [ ] | WLAN-Profile aus sops (nicht editierbar), eigene WLANs weiterhin über NetworkManager | dito | `nmcli connection` |
| [ ] | DNSSEC (resolved), privateDns (Quad9 DoT auf Laptops), MAC-Zufall außer im Heimnetz | dito | `resolvectl status`, `nmcli -f 802-11-wireless.cloned-mac-address c show <wlan>` |
| [ ] | WireGuard-Hub 10.100.0.0/24, Pi-hole durch den Tunnel, Mullvad-Bypass | `nixosModules/system/wireguard.nix` | nach Phase 9: `wg show` |
| [ ] | nginx: Catch-all-vHost, Security-Header, ACME (Cloudflare dns-01, Mail-Domain http-01), gixy-geprüft | `nixosModules/server/network/nginx.nix` | `curl -sI https://<dienst>` zeigt HSTS |
| [ ] | Neu: nginx-Modus `selfsigned` (offline/portabel) | dito | Portable-Server-Modus: `curl -kI https://jellyfin.portable.internal` |
| [ ] | Pi-hole mit Unbound (rekursiv, DNSSEC), fail2ban für Webdienste | `nixosModules/server/network/` | `dig +dnssec sigfail.ippacket.stream` (SERVFAIL) |

## D. Server-Dienste

| ✓ | Änderung | Wo | Prüfung |
|---|---|---|---|
| [ ] | `nixos.server.dataDir` statt fester `/pool01`-Pfade | `nixosModules/server/default.nix` | Server1: Dienste schreiben nach `/pool01/applications` |
| [ ] | ServerPublic: Stalwart (JMAP, IMAP, SMTP, DAV), Nextcloud mit Collabora, Talk, E2EE, Matrix mit vier Bridges, CryptPad, Murmur, ntfy, coturn, Miniflux, Briar Mailbox, MollySocket, Minecraft, code-server | `nixosModules/server/public/` | Phase 8, `systemctl --failed` |
| [ ] | Neu: WKD für den eigenen PGP-Schlüssel auf `openpgpkey.<mailDomain>` | `nixosModules/server/public/stalwart.nix` | `gpg --auto-key-locate clear,wkd --locate-keys <adresse>` |
| [ ] | Server1: Home Assistant (Tankerkönig, Killswitch), HomeBox, Monitoring (Prometheus, Alertmanager, Loki, Grafana mit Dashboards), Monero-Node mit P2Pool, Proton-Backup | `hosts/NixOS-Server1/` | `https://grafana.<homeDomain>`: alle Targets „up“ |
| [ ] | Neu: Loki-Alarm „ExecOutsideNixStore“ (Benutzersitzung startet ein Programm außerhalb des Stores) | `nixosModules/server/management/monitoring.nix` | TODO 6.7 |
| [ ] | Neu: Ollama auf der Intel-GPU (`gpu = "intel"` über `VK_DRIVER_FILES`), Modellliste als Option | `nixosModules/server/tools/ollama.nix` | `journalctl -u ollama \| grep -i vulkan` nennt die Intel-GPU |
| [ ] | Neu: ComfyUI (Stable Diffusion) als Podman-Container mit Intel XPU, `comfyui.<homeDomain>`, Image per Digest gepinnt, Link in Glance | `nixosModules/server/tools/comfyui.nix` | Weboberfläche öffnen, Bild generieren, `intel_gpu_top` zeigt Last |
| [ ] | Neu: `backup-external` für die externe Backup-Platte von Server1 | `hosts/NixOS-Server1/backintime.nix` | `sudo backup-external /dev/sdX1` |
| [ ] | Restic-REST-Server (append-only) auf Server1, Restic auf ServerPublic (nach Server1) | `nixosModules/server/sync/resticserver.nix`, `hosts/NixOS-ServerPublic/backup.nix` | `restic snapshots` |
| [ ] | Neu: Samba-Share-Modul kollidiert nicht mehr mit einem Login-Benutzer `jf` | `nixosModules/server/fileshare/share.nix` | Portable-Server-Modus: `id jf` zeigt die Gruppen `share`, `tmjf` |

## E. Desktop und Anwendungen

| ✓ | Änderung | Wo | Prüfung |
|---|---|---|---|
| [ ] | Neu: Hyprland auf allen Clients als zweite Sitzung (Lua-Konfiguration, Catppuccin) | `homeModules/desktop/windowManager/hyprland/` | SDDM → Hyprland |
| [ ] | Waybar als schwebende Inseln (Workspaces, Fenster, Uhr, MPRIS, CPU/RAM/Temp, Audio, Mikro, Netz, Bluetooth, Akku, Tray, Benachrichtigungen, Power) | `waybar.nix` | Leiste sichtbar, Klicks funktionieren |
| [ ] | Rofi (Apps, Rechner, Zwischenablage, Bluetooth) | `rofi.nix` | Super+R, Super+., Super+V |
| [ ] | SwayNC (Benachrichtigungszentrale), Dunst entfernt | `swaync.nix` | `notify-send test`, Super+N |
| [ ] | awww (swww) + waypaper, Slideshow alle 10 min aus dem Host-Ordner | `wallpaper.nix`, `hosts/*/home/hyprland.nix` | Super+W, Super+Shift+W |
| [ ] | hyprlock + hypridle (dimmen 4 min, sperren 5 min, Bildschirm aus 6 min, Suspend 30 min), Swaylock entfernt | `hypridle.nix`, `hyprlock.nix` | Super+L, warten |
| [ ] | wlogout mit fünf Karten über `power-menu` (Hibernate entfernt, das System bootet mit `nohibernate`) | `wlogout.nix` | Super+Shift+E |
| [ ] | Flameshot (über das Screenshot-Portal) | Keybinds | Print, Shift+Print, Super+Print |
| [ ] | hyprsunset (21–7 Uhr 4000 K), kanshi-Profile pro Host | `display.nix`, `hosts/*/home/hyprland.nix` | `kanshictl status`, abends wärmere Farben |
| [ ] | pyprland: Dropdown-Terminal, Lautstärkemixer, Zoom | `pyprland.nix` | Super+`, Super+A, Super+Z |
| [ ] | Workspace-Übersicht (hyprtasking); hypr-dynamic-cursors ist vorerst entfernt (TODO 13.15) | `hyprland.nix` | Super+Tab |
| [ ] | imv, hyprpicker, cliphist, hyprpolkitagent, nwg-look, playerctl, brightnessctl, pavucontrol | `utilities.nix` | Super+C, Medientasten |
| [ ] | Touch (Convertible, Portable): hyprgrass-Gesten, wvkbd, iio-hyprland, Touchpad-Gesten | `touch.nix` | Wisch von unten (Tastatur), Drehen |
| [ ] | Neu: DangerZone auf allen Clients (aus dem Quellcode gebaut, Podman rootless) | `pkgs/dangerzone`, `homeModules/applications/tools/dangerzone.nix` | PDF umwandeln (TODO 4.9) |
| [ ] | Neu: Fusion 360 über Wine (Desktop, Portable) | `homeModules/applications/editing/fusion360.nix` | `fusion360-install`, dann `fusion360` |
| [ ] | Neu: EasyEffects mit Mikrofon-Kette (DeepFilterNet, Gate, EQ, Kompressor, De-Esser, Limiter) | `homeModules/applications/media/easyeffects*.{nix,json}` | EasyEffects öffnen → Eingang → Preset „microphone“ aktiv, Aufnahme testen |
| [ ] | Neu: Fluent Reader (Miniflux-Sync vorbelegt, Taskleiste zwischen Clementine und FreeTube) | `homeModules/applications/media/fluentreader.nix`, `plasma6.nix` | Icon in der Taskleiste, Einstellungen → Dienst zeigt Miniflux |
| [ ] | Neu: KeePassXC-SSH-Agent funktionsfähig (ssh-agent-Dienst + `SSH_AUTH_SOCK`) | `homeModules/applications/tools/keepassxc.nix` | `echo $SSH_AUTH_SOCK`, `ssh-add -l` nach dem Entsperren |
| [ ] | Neu: GnuPG (WKD, gpg-agent, eigener Public Key) | `homeModules/base/gpg.nix` | `gpg --list-keys`, `gpgconf --list-options gpg-agent` |
| [ ] | Thunderbird: Datenschutz-Prefs, Stalwart-Konto (jetzt `primary`), neu: PGP-Identität, externes GnuPG, CalDAV/CardDAV von Stalwart | `homeModules/applications/communication/thunderbird.nix` | Konto, Kalender und Adressbuch erscheinen, Signieren aktiv |
| [ ] | LibreWolf/Brave: Fingerprinting-Schutz, WebRTC, DoH, eigene Dienste erlaubt | `homeModules/applications/browser/` | https://coveryourtracks.eff.org |
| [ ] | Back In Time täglich über cron (siehe M) | `homeModules/applications/tools/backintime.nix` | TODO 4.7 |
| [ ] | Neu: VRR/HDR des Hauptmonitors beim Login | `hosts/NixOS-Desktop/home/machine.nix` | `kscreen-doctor -o` zeigt VRR automatisch, HDR an |
| [ ] | Neu: WebDAV-Mount `dav.<homeDomain>` auf `/mount/dav` (ausgeschaltet, bis das Secret existiert) | `nixosModules/userEnvironment/networkshares.nix` | nach TODO 13.11: `ls /mount/dav` |
| [ ] | Software-Auswahl pro Gerät (Bundles, CLI-Gruppen) nach deinen Antworten aus Runde 1 | `homeModules/applications/*/default.nix`, `nixosModules/base/common.nix` | `nvd diff` (TODO 3.3) |

## F. Mail, PGP, JMAP

| ✓ | Änderung | Wo | Prüfung |
|---|---|---|---|
| [ ] | Anleitung PGP (Stalwart Encryption at Rest, WKD, Thunderbird, GnuPG) | `docs/mail-pgp-jmap.md` | Phase 11 |
| [ ] | JMAP-Clients: Sterna (Android), Bulwark (Webmail), aerc; Thunderbird-JMAP als TODO | dito | – |

## G. Analysen und Antworten (Dokumente)

| ✓ | Thema | Wo |
|---|---|---|
| [ ] | SIM-Karten-Server (Gammu): Nutzen, Risiken, Empfehlung | `docs/sms-gateway.md` |
| [ ] | SSH-Keys in KeePassXC: Einrichtung und Sicherheitsgewinn | `docs/keepassxc-ssh-agent.md` |
| [ ] | E2EE, Laufzeitschutz, Ente Photos/Auth mit Vor- und Nachteilen | `docs/e2ee-and-runtime-protection.md` |
| [ ] | Proton Drive über rclone/restic, Zugriff vom Handy | `docs/proton-drive.md` |
| [ ] | microvm.nix vs. NixOS-Container | `docs/isolation.md` |
| [ ] | Deklarative VMs (NixVirt) | `docs/virtual-machines.md` |
| [ ] | Offline-Installation, lokaler Binary Cache, Hydra | `docs/offline-installation.md` |
| [ ] | Registrare (Monero), DNS, DDoS-Schutz, Hoster | `docs/providers.md` |
| [ ] | Disaster-Recovery-Plan | `docs/disaster-recovery.md` |
| [ ] | RSS: Fluent Reader, Apps fürs Handy | `docs/rss.md` |
| [ ] | UnifiedPush auf GrapheneOS | `README.md` |
| [ ] | Boot-Log-Analyse und nscd | `TODO.md` Phase 13 |
| [ ] | Security-Abgleich mit xeiaso.net und saylesss88 (umgesetzt: siehe B; abgelehnt: Forwarding-Verbot, ed25519-only, kexec, ASLR auf Clients, malloc auf Clients, Polkit; wirkungslos auf NixOS-Kernels: `lockdown=`, `module.sig_enforce`, weil `SECURITY_LOCKDOWN_LSM` und `MODULE_SIG` deaktiviert sind) | dieser Abschnitt |

## H. NixOS-Portable

| ✓ | Änderung | Wo | Prüfung |
|---|---|---|---|
| [ ] | Eine SSD, LUKS, tmpfs-Root, Swap 8 GB | `hosts/NixOS-Portable/disko.nix`, `machine.nix` | Installation TODO Phase 12 |
| [ ] | Hybrid-Boot: limine für BIOS (EF02-Partition) und UEFI als Wechselmedium | `nixosModules/system/bootloader.nix` (`removable`, `biosPartitionIndex`), disko `biosBoot` | Boot auf UEFI- und BIOS-Rechner |
| [ ] | Alle CPU-/GPU-Treiber, redistributable Firmware, breite initrd-Module | `machine.nix`, `hardware-configuration.nix` | LUKS-Abfrage erscheint auf fremden Rechnern, Tastatur geht |
| [ ] | Alle Anwendungen (auch die sonst abgeschalteten, außer Back In Time), Plasma + Hyprland mit Touch | `hosts/NixOS-Portable/home/home.nix` | Anwendungsmenü |
| [ ] | Boot-Eintrag `server`: Jellyfin, Kiwix, Ollama (`qwen3.5:4b`), ComfyUI, LanguageTool, LibreTranslate, Nextcloud + Collabora, Forgejo, Radicale, Linkwarden, HomeBox, Miniflux, Home Assistant, Monitoring, Samba + WebDAV, Glance, SearXNG, code-server, CryptPad, Minecraft (4 GB) | `hosts/NixOS-Portable/server.nix` | `https://glance.portable.internal` |
| [ ] | Eigene sops-Datei (Server-Secrets zufällig erzeugt, persönliche Werte als `REPLACE_ME`) | `$PRIV/secrets/nixos-portable.yaml` | `sops -d` zeigt keine `REPLACE_ME` mehr (TODO 1.5) |

## I. Offene Punkte, die ich nicht prüfen konnte

- Laufzeitverhalten aller neuen Dienste und Desktop-Komponenten auf echter Hardware (Hyprland-Plugins, Touch, ComfyUI auf der Intel-GPU, Ollama-Gerätewahl, DangerZone-Konvertierung, Fusion 360 unter Wine).
- Ob Stalwart die CalDAV/CardDAV-Pfade `/dav/cal/<adresse>/default/` und `/dav/card/<adresse>/default/` so bereitstellt. Falls nicht, die URL in `thunderbird.nix` anpassen.
- Hardened Malloc auf ServerPublic: zuerst in VMServerPublic testen (TODO 8.5).
- Ob der Loki-Alarm im Audit-Format deiner Kernel-Version greift (TODO 6.7).

## J. Dritte Arbeitsrunde

Stand der Verifikation: Alle elf Hosts evaluieren (mit dem uncommitteten privaten Repo per `--override-input`). Real getestet habe ich den CVE-Scan auf NixOS-Desktop (SBOM, grype, Metrik-Export, `promtool`), `update-check` gegen die echten Upstreams, die 13 Alarmregeln, alle Glance-Widgets gegen Stub-APIs und die Countdown-Seite im Browser (Handy- und Desktop-Breite). Nicht getestet sind Grafana-Darstellung, BlueMap, die Thunderbird-Konten und das EasyEffects-Preset mit echtem Mikrofon.

| ✓ | Änderung | Wo | Prüfung |
|---|---|---|---|
| [ ] | Pins über `flake.lock`: Dangerzone, hyprgrass, wf-touch, Briar Mailbox, Weishaupt-API, BlueMap, Fabric API, Grafana-Dashboards | `flake.nix`, `pkgs/`, Module | `git grep -n 'sha256-' -- '*.nix'` zeigt nur auskommentierte Kiwix-Einträge |
| [ ] | Container-Images per Digest, ein Ort, Update-Befehl | `pkgs/images.json`, `pkgs/update-images.nix` | `nix run .#update-images -- --check` |
| [ ] | CVE-Scan auf allen Hosts | `nixosModules/system/vulnscan.nix` | `sudo systemctl start vulnscan`, `cat /var/lib/prometheus-node-exporter/vulnscan.prom` |
| [ ] | Versionsstand pro Host (Commit, Neustart nötig, Alter der Inputs) | `nixosModules/system/monitoring-agent.nix` | `cat /var/lib/prometheus-node-exporter/nixos-version.prom` |
| [ ] | Update-Prüfung auf Server1 | `nixosModules/server/management/update-check.nix` | `sudo systemctl start update-check`, Dashboard |
| [ ] | Grafana-Dashboard „Security and Updates“, vier neue Alarme | `nixosModules/server/management/dashboards/`, `monitoring.nix` | Grafana → NixOS |
| [ ] | Glance: Seite „Server“ mit Abschnitten pro Server, Stats aus Prometheus, Alarme, CVEs, Minecraft | `nixosModules/server/management/glance-server-page.nix` | `https://glance.<homeDomain>/server` |
| [ ] | Glance-Widgets Jellyfin, Kalender, Miniflux, Home Assistant (aus, bis die Keys existieren) | dito | TODO 13.12 |
| [ ] | Neuer Host NixOS-ServerGaming und NixOS-VMServerGaming, Minecraft von ServerPublic dorthin verschoben | `hosts/NixOS-ServerGaming` | TODO 8B |
| [ ] | BlueMap auf `bluemap.<domain>` (`flolserver.<domain>` als Alias) | `hosts/NixOS-ServerGaming/minecraft.nix` | Karte im Browser |
| [ ] | Countdown-Seite auf `countdown.<domain>`, Datum in `server.nix` | `nixosModules/server/game/countdown.*` | Seite auf dem Handy öffnen |
| [ ] | EasyEffects-Preset für Rode Procaster und Behringer UMC22 | `homeModules/applications/media/`, `docs/microphone.md` | Probeaufnahme |
| [ ] | Thunderbird mit vier Konten, Proton als Hauptkonto | `homeModules/applications/communication/thunderbird.nix` | nach TODO 1.3 und 11.5 |
| [ ] | Schul-WLAN entfernt (Modul, `secrets.yaml`, `nixos-portable.yaml`) | `nixosModules/system/networking.nix` | `nmcli connection`, kein Profil `school` |
| [ ] | `system.autoUpgrade` auf den Servern aus, bis gemergt ist | `hosts/*/configuration.nix` | TODO Phase 17 |
| [ ] | Fix: fail2ban setzte die Nextcloud-Filterdatei auch ohne Nextcloud | `nixosModules/server/network/fail2ban.nix` | Eval von NixOS-ServerGaming |
| [ ] | Fix: Claude-Code-Erweiterung im Unfree-Prädikat, Clients evaluierten sonst nicht | `nixosModules/system/nixos.nix` | TODO 3.1 |
| [ ] | Wiki-Inhaltsliste | `WIKI-TODO.md` | TODO 15.10 |

## K. Vierte Arbeitsrunde: Reparatur nach dem ersten Boot

Stand der Verifikation: Die bestehende Home-Manager-Generation lief in einer Sandbox mit leerem Home vollständig durch (`exit 0`), der einzige Blocker sind also die `root:root`-Ordner. Hyprland lief darin verschachtelt mit `hyprland.lua`: keine Konfigurationsfehler, 74 Binds, Optionen gesetzt, hyprtasking geladen. Die Plasma-Skripte brauchen eine echte Sitzung und sind nur auf Syntax geprüft. Der Neustart selbst steht aus, deshalb sind `neededForBoot` und die Persistenz noch nicht zur Laufzeit bestätigt.

| ✓ | Änderung | Wo | Prüfung |
|---|---|---|---|
| [ ] | Fix: `/persistent/home` im initrd gemountet, neue persistierte Ordner gehören dem Benutzer | `nixosModules/disko/disko-luks-btrfs-tmpfs.nix` | TODO 4.5e |
| [ ] | Persistierte Dateien bleiben Symlinks, auch mit gemountetem Home | `bash.nix`, `clementine.nix`, `gwenview.nix`, `kile.nix`, `plasma6.nix`, `vscodium.nix` | `ls -la ~/.config/gwenviewrc ~/.bash_history` zeigt Symlinks |
| [ ] | Neu: `~/.claude`, `~/.claude.json`, `~/.vscode-oss/extensions` persistiert | `homeModules/applications/development/vscodium.nix` | Nach zwei Neustarts: Erweiterung da, angemeldet, Speicher vorhanden |
| [ ] | Fix: hypridle läuft nur noch in Hyprland, nicht mehr in Plasma | `nixosModules/desktop/windowManager/hyprland.nix` | In Plasma: `systemctl --user is-active hypridle` ist `inactive` |
| [ ] | Fix: OBS-Aktivierung überschrieb `$USER` für alle folgenden Schritte | `homeModules/applications/media/obs-studio.nix` | Keine `pkill: invalid user name`-Zeile in `journalctl -b -u home-manager-jf` |
| [ ] | Fix: `mullvadSetup` beendete bei nicht erreichbarem Daemon die gesamte Aktivierung still mit `exit 0` | `homeModules/applications/vpn/mullvad.nix` | `journalctl -b -u home-manager-jf` endet mit `waypaperConfig` |
| [ ] | Fix: Server1 meldet Mullvad nicht mehr bei jedem Boot neu an (`/etc/mullvad-vpn` persistiert) | `nixosModules/server/network/mullvad-server.nix` | TODO 6.2a |
| [ ] | Fix: Mullvad-Autologin erkennt widerrufene Geräte (`has been revoked`) | `mullvad.nix`, `mullvad-server.nix` | Nach einem Widerruf meldet sich der Dienst beim nächsten Start neu an |
| [ ] | Fix: Mullvad-Prüfung scheiterte unter `pipefail` an `grep -q` (SIGPIPE), Clients meldeten sich bei jeder Aktivierung neu an und tauschten dabei ihr Gerät | `homeModules/applications/vpn/mullvad.nix`, `mullvad-server.nix` | `journalctl -b -u mullvad-daemon \| grep login_account` ist leer, `Device name` bleibt gleich |
| [ ] | hypr-dynamic-cursors entfernt, lädt nicht auf Hyprland 0.56.2 | `homeModules/desktop/windowManager/hyprland/hyprland.nix` | `hyprctl plugin list` zeigt nur Hyprtasking, keine rote Meldung beim Login |
| [ ] | `CLAUDE.md` als Kontextspeicher, `result` in `.gitignore` | Repo-Wurzel | `git status` zeigt `result` nicht |

## L. Fünfte Arbeitsrunde: Hyprland-Design und Plasma-Benachrichtigungen

Stand der Verifikation: Die Reparatur aus K ist nach dem Neustart bestätigt. Das Design habe ich per Screenshot geprüft: Hyprland lief isoliert mit einem Headless-Ausgang in 2560x1080, darin Waybar, Rofi, swaync, wlogout und hyprlock. Nicht real getestet sind die Darstellung auf 3840x1600 sowie Klicks und Tastenkürzel. Dass Plasma den Benachrichtigungsdienst behält, ist bisher nur über die Bedingung der Unit geprüft.

| ✓ | Änderung | Wo | Prüfung |
|---|---|---|---|
| [ ] | Fix: swaync startet in Plasma nicht mehr per D-Bus-Aktivierung | `homeModules/desktop/windowManager/hyprland/swaync.nix` | In Plasma: `busctl --user status org.freedesktop.Notifications \| grep Comm` zeigt `plasmashell` |
| [ ] | Fix: 11 leere Icons in Waybar, Workspaces waren unsichtbar | `waybar.nix` | Icons und Nummern sichtbar, `grep -c 'format = ""' waybar.nix` ist 0 |
| [ ] | Neu: Rofi-Thema, wlogout-Karten, hyprlock mit Uhr und Blur, schwebendes swaync-Panel | `rofi.nix`, `wlogout.nix`, `hyprlock.nix`, `swaync.nix` | Super+R, Super+Shift+E, Super+L, Super+N |
| [ ] | Neu: Transparente Terminals nur unter Hyprland, Gradient-Rahmen, mehr Blur | `config/hyprland.lua`, `pyprland.nix` | Super+Return, in Plasma bleibt kitty deckend |
| [ ] | Fix: wlogout-Icons als PNG, GTK lud die SVGs nicht | `wlogout.nix` | Icons sichtbar |
| [ ] | Fix: GTK-Dark-Einstellung stand als ungültiger Schlüssel `Settings` in der `settings.ini` | `homeModules/theme/catppuccin.nix` | Keine Meldung `Unknown key Settings` im Journal |
| [ ] | Fix: CPU-Temperatur in Waybar auf dem Desktop (k10temp) | `hosts/NixOS-Desktop/home/hyprland.nix` | Temperatur sichtbar |
| [ ] | `audit_backlog_limit` auf 8192 | `nixosModules/system/hardening.nix` | TODO 13.1 |

## M. Sechste Arbeitsrunde: Journal, Rice, Back In Time, Fusion 360

Stand der Verifikation: Waybar, Widgets, Rofi, wlogout und hyprlock sind per Screenshot auf 3840x1600 in einem isolierten Hyprland geprüft, Klicks in der echten Session nicht. Der Shutdown-Hook ist mit einem `systemctl`-Stub geprüft, die Fusion-Schritte in einem Test-Prefix unter Xvfb.

| ✓ | Änderung | Wo | Prüfung |
|---|---|---|---|
| [ ] | Fix: Dienste stoppen beim Abmelden, solange der Compositor läuft (Coredump-Kette) | `config/hyprland.lua` | Aus Hyprland abmelden, `coredumpctl list -S today` zeigt nichts Neues |
| [ ] | Fix: Unter Hyprland das Hyprland-Portal statt KDE | `nixosModules/desktop/xdg.nix` | In Hyprland `cat /etc/xdg/xdg-desktop-portal/hyprland-portals.conf`, `systemctl --user status plasma-xdg-desktop-portal-kde` ist inaktiv |
| [ ] | Fix: `ordering cycle` von wallpaper-random | `wallpaper.nix` | `journalctl -b --user | grep -c "ordering cycle"` ist 0, Wallpaper wechselt beim Login |
| [ ] | Alle Texte in Hyprland englisch | `wlogout.nix`, `hyprlock.nix`, `rofi.nix`, `waybar.nix`, `widgets.nix` | Power-Menü, Sperrbildschirm, Suche, Datum |
| [ ] | Neu: Desktop-Widgets (Uhr, Wetter mit Stunden und 7 Tagen, CPU, RAM, GPU, Netz, Laufwerke, Prozesse, Favoriten-Dock) | `widgets.nix`, `config/eww.yuck` | Leerer Workspace, Super+Shift+B blendet sie aus |
| [ ] | Neu: Favoriten aus der Plasma-Taskleiste in Rofi | `homeModules/desktop/favorites.nix`, `rofi.nix` | Super+D, Stern in Waybar, Plasma-Taskleiste unverändert |
| [ ] | Neu: Quick-Menü mit Untermenüs (Screenshot, Audio, Netzwerk, Aussehen, System) | `rofi.nix` | Super+X oder Klick aufs NixOS-Logo |
| [ ] | Neu: Waybar mit Wetter, Laufwerk, VPN, Energieprofil, Werkzeug- und Session-Schublade | `waybar.nix` | Über Werkzeug- und Power-Symbol fahren, Mittelklick auf Audio |
| [ ] | Fix: Back In Time über cron, Crontab-Pfad des Pakets, `bin/backintime` vorhanden | `backintime.nix`, `nixosModules/system/cron.nix` | TODO 4.7 |
| [ ] | Fix: `fusion360-install` scheiterte in winetricks am fehlenden `wine64` | `fusion360.nix` | TODO 4.13 |
| [ ] | D-Bus-Duplikate aus dem Journal gefiltert | `nixosModules/system/dbus.nix` | TODO 13.1 |

## N. Siebte Arbeitsrunde: Server, Titelleisten, Thunderbird

| ✓ | Änderung | Wo | Prüfung |
|---|---|---|---|
| [ ] | Fix: Hyprland-Variablen gelangen nicht mehr in die Plasma-Sitzung | `homeModules/desktop/windowManager/hyprland/hyprland.nix` | TODO 13.17 |
| [ ] | Neu: Netzwerk der VPS ohne Interface-Namen, statisch oder per DHCP, auch im initrd | `hosts/vps-uplink.nix` | Evaluiert für beide Fälle, echter Boot steht aus (TODO 8.6) |
| [ ] | Thunderbird zeigt Konten mit ihrer Adresse, Konto-IDs bleiben gleich | `homeModules/applications/communication/thunderbird.nix` | Kontenliste, bestehende Konten bleiben erhalten |
| [ ] | Stalwart-Konto für Thunderbird vorbereitet, aktiv sobald `mailAddress` gesetzt ist | `thunderbird.nix` | Mit Testadresse gebaut, echter Login nach TODO 8.8 |
| [ ] | KeePassXC: `SSHAgent.Enabled` und weitere Schlüsselnamen korrigiert | `homeModules/applications/tools/keepassxc.nix` | SSH-Agent-Seite am Eintrag sichtbar |
| [ ] | SSH nutzt `~/.ssh/id_ed25519` statt `.pub` | `homeModules/base/ssh.nix` | `ssh admin@NixOS-Server1` |
| [ ] | Fix: Der Start von Fusion 360 fand den Ordner `production` nicht, Wine legt keine Menüeinträge mehr an | `fusion360.nix` | `fusion360` |
| [ ] | Input `private` fest auf `/home/jf/Documents/nixos-private` | `flake.nix` | Auf einem Laptop bauen, TODO 5.1 |
| [ ] | Blocklisten als `github:`-Inputs, Grafana-Dashboards mit fester Revision, `oisd` entfernt | `flake.nix`, `nixosModules/system/networking.nix` | Build auf einem frischen Host, kein `mismatch in field narHash` |
| [ ] | JetBrains entfernt | `homeModules/applications/development/` | `grep -ri pycharm` findet nichts |
| [ ] | Deploy mit `--build-host`, weil Server unsignierte Pakete ablehnen | TODO 6.2 | Server1 bootet die neue Generation |
| [ ] | Fix: Hyprland fror beim Abmelden ein, neu `session-logout` | `hyprland.nix`, `config/hyprland.lua`, `wlogout.nix`, `waybar.nix` | Super+Shift+Q, Abmelden über Waybar und Power-Menü |
| [ ] | Fix: Workspaces per Klick wechseln (Waybar gepatcht) | `waybar.nix` | Klick auf eine Nummer in der Leiste |
| [ ] | Fix: Bluetooth-Menü, `rofi-bluetooth` fehlte im PATH | `rofi.nix` | Klick auf Bluetooth, Gerät verbinden |
| [ ] | WLAN-Profile heißen wie die SSID | `nixosModules/system/networking.nix` | Plasma-Netzwerkliste, `nmcli connection` |
| [ ] | Quick-Menü: KeePassXC, Energieprofil, Auto-Lock | `rofi.nix` | Super+X |
| [ ] | Hyprland auf allen Clients deaktiviert, nur Plasma | `hosts/<Host>/configuration.nix` | SDDM bietet nur Plasma an, TODO 16.7 |
| [ ] | flake.lock aktualisiert, Anpassungen für nixpkgs (initrd, preLVM, Nextcloud-Admin, Ventoy, Lutris auf Portable) | `flake.lock`, `nixosModules/` | Alle Hosts bauen |
| [ ] | Neu: Dashboard mit Suche, Favoriten, Zuletzt, Clipboard, Schaltern, Lautstärke, Akku | `popups.nix`, `config/eww-popups.yuck` | Super+R, Tippen und Enter, Escape, Klick daneben |
| [ ] | Neu: Kalender-Popup mit Radicale-Terminen | `popups.nix` | Klick auf die Uhr, `systemctl --user status desktop-calendar-sync` |
| [ ] | Neu: Sound-Popup mit Geräten, Apps und Helligkeit, Media-Popup mit Fortschrittsleiste | `popups.nix` | Klick auf Audio und Player |
| [ ] | Fix: `update-check` scheiterte an shellcheck (`$prefix[0-9.]`), Build von Server1 brach ab | `nixosModules/server/management/update-check.nix` | Build von Server1 |
| [ ] | Ab Mitte November: Snapshots von Back In Time kontrollieren. Entstehen sie täglich, werden alte gelöscht, stimmt der Platz auf der Platte? | Back In Time, `/mount/Backup/backintime/NixOS-PC/jf/1/` | `ls /mount/Backup/backintime/NixOS-PC/jf/1/` zeigt tägliche Snapshots, `readlink last_snapshot` ist aktuell, `new_snapshot` existiert nicht dauerhaft, `journalctl -t backintime -p err` ist leer, ein Restore einer Testdatei klappt |
| [ ] | Wetterort aus sops statt lokaler Datei, `weather-location` entfällt | `widgets.nix`, `nixosModules/system/sops.nix` | Wetterkarte zeigt Wilnsdorf |
| [ ] | Storage Box aus den Backups der VPS entfernt, Sicherung nach Server1 bleibt | `hosts/NixOS-Server{Public,Gaming}/backup.nix` | Host evaluiert ohne `storageBox` |
| [ ] | Speicherlimit 5 GB pro Nutzer in Nextcloud und CryptPad | `nextcloud.nix`, `cryptpad.nix` | Nextcloud: Benutzerverwaltung, CryptPad: Einstellungen des Kontos |
