# Wiki-TODO

Inhalte für das Forgejo-Wiki auf NixOS-Server1 (Repository `jf/wiki`, `https://forgejo.<homeDomain>/jf/wiki/wiki`).

Grundregeln:

- Das Wiki ist Markdown in Git: Im Browser oder lokal mit `git clone https://forgejo.<homeDomain>/jf/wiki.wiki.git` in VS Code bearbeiten.
- Das Wiki erklärt Abläufe und Zusammenhänge. Was im Code steht, wird verlinkt, nicht abgeschrieben.
- Keine Passwörter, Schlüssel oder privaten Domains. Geheimes steht in KeePassXC, im Wiki nur der Name des Eintrags.
- Fällt NixOS-Server1 aus, ist das Wiki nicht erreichbar. Die Notfall-Anleitung bleibt deshalb in `docs/disaster-recovery.md` im Repository und auf Papier.

## Einrichtung

- [ ] Repository `wiki` in Forgejo anlegen, Wiki aktivieren, Startseite `Home` mit Inhaltsverzeichnis schreiben
- [ ] Wiki-Repository lokal klonen und einmal testen, ob Forgejo-Dumps und Backups es enthalten
- [ ] Vorlage für Dienst-Seiten anlegen: Zweck, Host, URL, Daten, Backup, Update, Fehlerbilder

## Überblick

- [ ] Architektur: Hosts, Rollen, was läuft wo, warum zwei öffentliche VPS
- [ ] Repository-Aufbau: `flake.nix`, `nixosModules`, `homeModules`, `hosts`, `pkgs`, privates Repository
- [ ] Muster der Module: Options, Bundles, `enable`, Profil und Maschine
- [ ] Glossar: Impermanence, sops, Bundle, Flake-Input, Specialisation

## Netzwerkplan

- [ ] Heimnetz: Subnetz, Router, feste IPs, DHCP, DNS-Kette (Client, Pi-hole, Unbound)
- [ ] WireGuard: Adressen pro Host, Hub, Split-Tunnel, Mullvad-Bypass
- [ ] Öffentliche Dienste: Domains, Subdomains, DNS-Einträge, Ports pro VPS
- [ ] Firewall: offene Ports pro Host und warum
- [ ] Diagramm des Gesamtnetzes

## Dokumentation des Codes

- [ ] `nixos.system.*`: Boot, Secure Boot, TPM2, Impermanence, Hardening
- [ ] sops: Dateien, Schlüssel, wer was entschlüsseln kann, neues Secret anlegen
- [ ] `nixos.server.*`: je Kategorie eine Seite (Medien, Fileshare, Management, Netzwerk, Public, Sync, Tools, Game)
- [ ] Monitoring: Prometheus, Loki, Grafana, Alertmanager, Alarmwege
- [ ] CVE-Scan und Update-Prüfung lesen und bewerten (`docs/updates-and-vulnerabilities.md`)
- [ ] Desktop: Plasma, Hyprland, Tastenkürzel
- [ ] Eigene Pakete in `pkgs/` und wann sie entfallen können

## Update-Plan

- [ ] Rhythmus festlegen: `flake.lock`, gepinnte Releases, Container-Images, Firmware
- [ ] Reihenfolge: VM, Desktop, Laptops, Server1, ServerPublic, ServerGaming
- [ ] Prüfschritte vor und nach einem Update (`nvd diff`, `systemctl --failed`, Dashboards)
- [ ] Rollback: alte Generation booten, Flake-Lock zurücksetzen
- [ ] NixOS-Release-Wechsel und `stateVersion`
- [ ] Minecraft-Updates: Version, Fabric, BlueMap, Backup vorher

## Wartung

- [ ] Wöchentlich: Alarme, offene Updates, Backups prüfen
- [ ] Monatlich: CVE-Kandidaten sichten, False Positives eintragen
- [ ] Vierteljährlich: Restore-Test (`docs/disaster-recovery.md`)
- [ ] Jährlich: Schlüssel-Papierkopie prüfen, Passwörter und Tokens rotieren, Domains und Verträge prüfen
- [ ] ZFS: Scrub, Snapshots, Platte tauschen
- [ ] Zertifikate, DNS-API-Token, Storage Box

## Fehlersuche

- [ ] Allgemeines Vorgehen: Journal, `systemctl --failed`, Grafana, Loki-Abfragen
- [ ] Host startet nicht: LUKS, initrd-ssh, Secure Boot, TPM2, alte Generation
- [ ] Rebuild schlägt fehl: fehlende Secrets, „would be clobbered“, nicht committete Dateien
- [ ] Impermanence: Daten nach Neustart weg
- [ ] Dienst startet nicht auf Server1: ZFS nicht gemountet, Secrets fehlen
- [ ] DNS und Netzwerk: Pi-hole, Unbound, Mullvad-Lockdown, WireGuard
- [ ] Zertifikate: ACME, Cloudflare/DNS-Anbieter
- [ ] Mail: Zustellung, SPF, DKIM, DMARC, Blocklisten
- [ ] Backup: restic, Locks, Append-only, Restore

## Betriebshandbuch

- [ ] Neuen Host aufnehmen (Installer, sops, WireGuard, Monitoring)
- [ ] Neuen Dienst hinzufügen (Modul, vHost, DNS, Backup, Monitoring, Glance)
- [ ] Killswitch: Auslösen und Wiederanlauf
- [ ] Portable SSD aktualisieren und benutzen
- [ ] Geräteliste: Hardware, Seriennummern, Garantie, Kaufdatum
- [ ] Verträge und Konten: VPS, Domains, Storage Box, Mullvad, Proton (nur Namen, Zugang in KeePassXC)
