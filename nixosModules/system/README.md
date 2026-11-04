# system

## Purpose

Base system: boot, users, networking, security, secrets, backups, monitoring and notifications.

## How it works

- `site.nix` reads the private site data (domains, addresses) from the flake input `private`.
- `hardening.nix`: sysctls, kernel parameters (incl. pti, audit), module blacklist, hidepid, auditd (servers: every execve, rotated 5 x 50 MB), sudo logging, coredump limits, removed setuid wrappers (su, sg, newgrp, sudoedit), empty default packages, chrony with NTS, lynis and kernel-hardening-checker, server mode (ASLR, panic on oops, no geoclue/ModemManager/avahi) and optional hardened malloc; `unitHardening` for own systemd units.
- `user.nix`: the initial password hash per host comes from the private `site.nix` (`initialHashedPasswords`, sha512crypt) until `passwordFromSops` is enabled.
- `ssh.nix`: key only, post-quantum key exchange (mlkem768x25519), AEAD ciphers, ETM MACs, 3 authentication attempts, verbose log.
- `persistent.nix`: impermanence base directories and `/etc/machine-id` (a new id per boot would split the journal).
- `networking.nix`: home LAN (gateway, nameservers, local DNS records), sops wifi profiles, DNS privacy, MAC randomization, blocklists.
- `wireguard.nix`: network 10.100.0.0/24 with NixOS-ServerPublic as hub, Pi-hole as DNS through the tunnel, Mullvad bypass.
- `restic.nix`: encrypted backups with btrfs or ZFS snapshots and PostgreSQL dumps.
- `notify.nix`: alerts by mail (msmtp) and ntfy for failed units, SMART and ZFS; `killswitch.nix`: power off on an ntfy message.
- `sops.nix`: sops-nix with one secrets file per host from the private repository (`perHostFile`).

## Contents

| Path | Description |
|---|---|
| `boot.nix` | Set boot options. |
| `bootloader.nix` | Enable Bootloader. |
| `clamav.nix` | Enable ClamAV virus scanner (daily scan, findings as Prometheus metrics, see `docs/updates-and-vulnerabilities.md`). |
| `cron.nix` | Enable cron service and the hourly Back In Time job of `dailyProfile`. |
| `dbus.nix` | Enable dbus. |
| `default.nix` | Imports the modules of this folder and defines the bundle option `nixos.system.enable`. |
| `firewall.nix` | Enable network firewall. |
| `hardening.nix` | Enable basic system hardening. |
| `initrdssh.nix` | Enable ssh in initrd to unlock encrypted disks remotely. |
| `killswitch.nix` | Power off immediately when the message poweroff is published to the killswitch ntfy topic. |
| `locals.nix` | Enable system locals. |
| `monitoring-agent.nix` | Export metrics (prometheus exporters) and ship the journal to Loki. |
| `networking.nix` | Enable networking and network config. |
| `nh.nix` | Enable nh. |
| `nixos.nix` | Enable the default NixOS settings. |
| `nixosvm.nix` | Enable nixosvm. |
| `notify.nix` | Send system alerts by mail (msmtp as sendmail, secret notify/mail-password). |
| `persistent.nix` | Enable persistent. |
| `powermanagement.nix` | Enable powermanagement options. |
| `restic.nix` | Enable restic backups. |
| `secureboot.nix` | Enable secureboot. |
| `site.nix` | Private site data (domains, addresses) from the flake input private as `nixos.site.*`. |
| `smartd.nix` | Enable smartd. |
| `sops.nix` | Enable Sops. |
| `ssh.nix` | Enable ssh with sshguard. |
| `user.nix` | Setup the system user. |
| `vulnscan.nix` | Scan the closure of the running system for known vulnerabilities. |
| `wireguard.nix` | Enable the WireGuard network. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nixos.site.acmeEmail` | string | `private site.nix (acmeEmail)` | Contact address for ACME (Let's Encrypt). |
| `nixos.site.alertEmail` | string | `private site.nix (alertEmail)` | Recipient of system alerts. |
| `nixos.site.domain` | string | `private site.nix (domain)` | Main public domain (public services). |
| `nixos.site.homeDomain` | string | `private site.nix (homeDomain)` | Domain of the services in the home network. |
| `nixos.site.initialHashedPasswords` | attribute set of string | `private site.nix (initialHashedPasswords)` | Initial password hash of the user per host (lowercase hostname), used until user.passwordFromSops is enabled. |
| `nixos.site.mailAddress` | null or string | `private site.nix (mailAddress)` | Own mail address on the mail server (Thunderbird account). |
| `nixos.site.mailAccounts` | attribute set of attribute set of string | `private site.nix (mailAccounts)` | Addresses of the other mail accounts in Thunderbird: proton, dlrg, oneandone (address, optional realName). |
| `nixos.site.mailDomain` | string | `private site.nix (mailDomain)` | Domain of the mail addresses and the mail server. |
| `nixos.site.mailRealName` | string | `private site.nix (mailRealName)` | Display name of the own mail address. |
| `nixos.site.pgpFingerprint` | null or string | `private site.nix (pgpFingerprint)` | Fingerprint of the own OpenPGP key (Thunderbird identity, GnuPG default key). |
| `nixos.site.pgpPublicKey` | null or absolute path | `private pgp/public.asc if it exists` | Own OpenPGP public key (ASCII armored), published by WKD on the mail server and imported into GnuPG. |
| `nixos.site.serverGaming` | attribute set of anything | `private site.nix (serverGaming)` | Network data of NixOS-ServerGaming. |
| `nixos.site.serverPublic` | attribute set of anything | `private site.nix (serverPublic)` | Network data of NixOS-ServerPublic. |
| `nixos.system.boot.enable` | boolean | `false` | Set boot options. |
| `nixos.system.bootloader.biosDevice` | null or string | `null` | Additionally install limine for legacy BIOS boot on this device (e.g. VPS without UEFI). |
| `nixos.system.bootloader.biosPartitionIndex` | null or signed integer | `null` | Index (1-based) of the BIOS boot partition (EF02) limine embeds its stage 2 into. |
| `nixos.system.bootloader.enable` | boolean | `false` | Enable Bootloader. |
| `nixos.system.bootloader.removable` | boolean | `false` | Install as removable medium (EFI/BOOT/BOOTX64.EFI, no NVRAM entry), boots on any UEFI machine. |
| `nixos.system.clamav.enable` | boolean | `false` | Enable ClamAV virus scanner. |
| `nixos.system.clamav.excludePaths` | list of string | `[ ]` | Regular expressions of paths that are not scanned (ExcludePath). |
| `nixos.system.clamav.extraScanDirectories` | list of string | `[ ]` | Additional directories of the daily scan (user data, shares, uploads). |
| `nixos.system.cron.enable` | boolean | `false` | Enable cron service. |
| `nixos.system.dbus.enable` | boolean | `false` | Enable dbus. |
| `nixos.system.enable` | boolean | `false` | Enable system modules bundle. |
| `nixos.system.firewall.enable` | boolean | `false` | Enable network firewall. |
| `nixos.system.hardening.audit` | boolean | `true` | Enable auditd with rules for identity, sudo, ssh, kernel modules and root commands of users. |
| `nixos.system.hardening.auditExec` | boolean | `!config.nixos.desktop.enable` | Log every program execution (execve) with auditd and forward audit records to the journal (Loki alert for user commands outside /nix/store). Logs are rotated (5 x 50 MB). |
| `nixos.system.hardening.blacklistModules` | boolean | `true` | Prevent loading of rarely used network protocols and filesystems (udf stays allowed on desktops). |
| `nixos.system.hardening.enable` | boolean | `false` | Enable basic system hardening. |
| `nixos.system.hardening.hardenedMalloc` | boolean | `false` | Use graphene-hardened-light as memory allocator for all programs (preloaded globally, test services first). |
| `nixos.system.hardening.hidepid` | boolean | `true` | Mount /proc with hidepid=2, users only see their own processes. |
| `nixos.system.hardening.kernelParams` | boolean | `true` | Memory hardening kernel parameters (init_on_free, slab_nomerge, ...). |
| `nixos.system.hardening.ntsTime` | boolean | `true` | Use chrony with authenticated time (NTS) instead of systemd-timesyncd. Unauthenticated pool servers are only used when they agree with the NTS servers. |
| `nixos.system.hardening.ptraceScope` | integer between 0 and 3 (both inclusive) | `1` | kernel.yama.ptrace_scope (1 = only parent processes or root may attach). |
| `nixos.system.hardening.server` | boolean | `!config.nixos.desktop.enable` | Server hardening: more ASLR entropy, panic and reboot on kernel oops, disable geoclue, ModemManager and avahi (unless a module enables it). |
| `nixos.system.hardening.unitHardening` | attribute set of anything | `{   LockPersonality = true;   NoNewPrivileges = true;   P...` | Common systemd hardening for the own units (serviceConfig = unitHardening // { ... }). |
| `nixos.system.initrdssh.authorizedKeys` | list of string | `[   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBhC1nqSGZvIStHk...` | Public keys allowed to unlock the disk. |
| `nixos.system.initrdssh.enable` | boolean | `false` | Enable ssh in initrd to unlock encrypted disks remotely. |
| `nixos.system.initrdssh.hostKey` | string | `"/etc/ssh/initrd_host_key"` | Path of the initrd ssh host key. |
| `nixos.system.initrdssh.ip` | null or string | `null` | Static network configuration for initrd as kernel parameter ip=. DHCP is used if null. |
| `nixos.system.initrdssh.kernelModules` | list of string | `[ ]` | Network driver modules needed in initrd. |
| `nixos.system.initrdssh.port` | 16 bit unsigned integer; between 0 and 65535 (both inclusive) | `22` | Port of the initrd ssh server. |
| `nixos.system.killswitch.delay` | unsigned integer, meaning >=0 | `0` | Seconds to wait before powering off (e.g. on the host that sends the signal). |
| `nixos.system.killswitch.enable` | boolean | `false` | Power off immediately when the message poweroff is published to the killswitch ntfy topic. |
| `nixos.system.killswitch.url` | string | `"https://push.${config.nixos.site.domain}"` | URL of the ntfy server. |
| `nixos.system.locals.consolekbd` | string | `"de"` |  |
| `nixos.system.locals.enable` | boolean | `false` | Enable system locals. |
| `nixos.system.locals.lang` | string | `"en_US.UTF-8"` |  |
| `nixos.system.locals.local` | string | `"de_DE.UTF-8"` |  |
| `nixos.system.locals.timezone` | anything | `"Europe/Berlin"` |  |
| `nixos.system.monitoring-agent.enable` | boolean | `false` | Export metrics (prometheus exporters) and ship the journal to Loki. |
| `nixos.system.monitoring-agent.lokiUrl` | string | `"http://10.75.0.21:3100/loki/api/v1/push"` | Loki push endpoint. |
| `nixos.system.monitoring-agent.scrapers` | list of string | `[   "10.75.0.21"   "10.100.0.2" ]` | Addresses of the monitoring server (LAN and WireGuard) allowed to scrape the exporters. |
| `nixos.system.monitoring-agent.smart` | boolean | `smartd enabled and no VM` | Export SMART values of the disks. |
| `nixos.system.networking.blocklists.enable` | boolean | `true` | Enable DNS blocklists. |
| `nixos.system.networking.blocklists.urls` | list of string | `[   "adobe"   "amazonFireTV"   "malware"   "phishing"   "...` | Names of the blocklists to use. |
| `nixos.system.networking.dnssec` | boolean | `config.nixos.desktop.enable` | Validate DNSSEC in systemd-resolved (allow-downgrade). |
| `nixos.system.networking.enable` | boolean | `false` | Enable networking and network config. |
| `nixos.system.networking.lan.enable` | boolean | `true` | Host is part of the home LAN (gateway, nameservers and local host entries). |
| `nixos.system.networking.lan.gateway` | string | `"10.75.0.1"` | IPv4 gateway of the home LAN. |
| `nixos.system.networking.lan.gateway6` | string | `"fe80::1"` | IPv6 gateway of the home LAN. |
| `nixos.system.networking.lan.hosts` | attribute set of list of string | `gateway, services of NixOS-Server1 on nixos.site.homeDoma...` | Local DNS records (IP -> hostnames), used for /etc/hosts and pihole. |
| `nixos.system.networking.lan.nameservers` | list of string | `[   "10.75.0.21"   "10.75.0.1"   "9.9.9.9"   "149.112.112...` | Nameservers used in the home LAN. |
| `nixos.system.networking.lan.staticRouting` | boolean | `true` | Set gateway and nameservers of the home LAN statically (disable on laptops, they get both by DHCP). |
| `nixos.system.networking.lan.subnet` | string | `"10.75.0.0/24"` | Subnet of the home LAN. |
| `nixos.system.networking.localIP` | null or string | `null` | Local IP address of this host. Host entries matching this IP will use 127.0.0.1 instead. |
| `nixos.system.networking.macRandomization.ethernet` | boolean | `false` | Random MAC address for every wired connection. |
| `nixos.system.networking.macRandomization.wifi` | boolean | `false` | Random MAC address for every wifi connection (home networks keep the permanent one). |
| `nixos.system.networking.networkmanager.enable` | boolean | `true` | Use NetworkManager to manage network connections. |
| `nixos.system.networking.privateDns` | boolean | `false` | Ignore the DNS servers of the networks (DHCP) and use Quad9 with DNS over TLS (strict). Pi-hole is used through WireGuard when it is up. Captive portals need a manual workaround. |
| `nixos.system.networking.wifi.enable` | boolean | `false` | Provide the wifi networks from sops (secret wifi) as read-only NetworkManager profiles. |
| `nixos.system.networking.wifi.homeNetworks` | list of string | `[   "HOME" ]` | Networks of the sops wifi profiles which use the permanent MAC address. |
| `nixos.system.networking.wifi.networks` | attribute set of signed integer | `{   HOME = 10;   HOTSPOT = 5; }` | Network name -> autoconnect priority. The sops secret wifi contains ENV_<NAME>_SSID and ENV_<NAME>_PSK for each network. |
| `nixos.system.nh.enable` | boolean | `false` | Enable nh. |
| `nixos.system.nixos.enable` | boolean | `false` | Enable the default NixOS settings. |
| `nixos.system.nixosvm.enable` | boolean | `false` | Enable nixosvm. |
| `nixos.system.notify.mail.enable` | boolean | `false` | Send system alerts by mail (msmtp as sendmail, secret notify/mail-password). |
| `nixos.system.notify.mail.from` | string | `"alerts@${config.nixos.site.mailDomain}"` | Sender address and SMTP login. |
| `nixos.system.notify.mail.host` | string | `"mail.${config.nixos.site.mailDomain}"` | SMTP server (submission with implicit TLS). |
| `nixos.system.notify.mail.port` | 16 bit unsigned integer; between 0 and 65535 (both inclusive) | `465` | SMTP port. |
| `nixos.system.notify.mail.to` | string | `config.nixos.site.alertEmail` | Recipient of the alerts. |
| `nixos.system.notify.ntfy.enable` | boolean | `false` | Send system alerts to ntfy (secret notify/ntfy-env with NTFY_TOKEN and ALERT_TOPIC). |
| `nixos.system.notify.ntfy.url` | string | `"https://push.${config.nixos.site.domain}"` | URL of the ntfy server. |
| `nixos.system.notify.onFailure` | boolean | `mail.enable \|\| ntfy.enable` | Notify when any systemd service fails. |
| `nixos.system.persistent.enable` | boolean | `false` | Enable persistent. |
| `nixos.system.powermanagement.battery` | boolean | `true` | Enable battery and power profile management (upower, power-profiles-daemon). |
| `nixos.system.powermanagement.enable` | boolean | `false` | Enable powermanagement options. |
| `nixos.system.restic.enable` | boolean | `false` | Enable restic backups. |
| `nixos.system.restic.exclude` | list of string | `[   ".snapshots"   "**/.cache"   "var/cache"   "var/log" ...` | Exclude patterns. |
| `nixos.system.restic.paths` | list of string | `[   "/etc"   "/home"   "/srv"   "/var/lib"   "/var/backup" ]` | Paths to back up on hosts without impermanence. |
| `nixos.system.restic.repositories` | attribute set of (submodule) | `{ }` | Repositories every backup is written to. |
| `nixos.system.restic.repositories.<name>.environmentFile` | null or string | `null` | Environment file (e.g. RESTIC_REST_USERNAME/RESTIC_REST_PASSWORD). |
| `nixos.system.restic.repositories.<name>.extraOptions` | list of string | `[ ]` | Extra restic options (-o). |
| `nixos.system.restic.repositories.<name>.passwordFile` | string |  | File with the repository password. |
| `nixos.system.restic.repositories.<name>.rcloneConfigSecret` | null or string | `null` | rclone config (secret) for rclone: repositories, copied once to a writable location. |
| `nixos.system.restic.repositories.<name>.repository` | string |  | restic repository URL. |
| `nixos.system.restic.subvolumes` | list of string | `[   "/persistent"   "/persistent/home" ]` | btrfs subvolumes which are snapshotted and backed up (impermanence hosts). |
| `nixos.system.restic.time` | string | `"03:00"` | systemd OnCalendar expression for the backups. |
| `nixos.system.restic.zfsDatasets` | list of string | `[ ]` | ZFS datasets which are snapshotted and backed up (instead of the btrfs subvolumes or paths). |
| `nixos.system.secureboot.enable` | boolean | `false` | Enable secureboot. |
| `nixos.system.smartd.enable` | boolean | `false` | Enable smartd. |
| `nixos.system.sops.enable` | boolean | `false` | Enable Sops. |
| `nixos.system.sops.perHostFile` | boolean | `false` | Use the own secrets file of the host from the private repository (secrets/<hostname>.yaml). |
| `nixos.system.ssh.authorizedKeys` | list of string | `[   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBhC1nqSGZvIStHk...` | Public keys allowed to login as the system user. |
| `nixos.system.ssh.enable` | boolean | `false` | Enable ssh with sshguard. |
| `nixos.system.ssh.listenAddresses` | list of string | `[ ]` | Only listen on these addresses (e.g. the WireGuard IP), the port is not opened publicly then. All addresses if empty. |
| `nixos.system.ssh.whitelist` | list of string | `[   "10.75.0.40"   "10.75.0.80" ]` | Addresses or networks never blocked by sshguard. |
| `nixos.system.user.enable` | boolean | `false` | Setup the system user. |
| `nixos.system.user.passwordFromSops` | boolean | `false` | Read the password hash of the system user from sops (user/<hostname>/<username>). |
| `nixos.system.vulnscan.enable` | boolean | `false` | Scan the closure of the running system for known vulnerabilities (sbomnix + grype) and export the result to Prometheus. |
| `nixos.system.vulnscan.ignore` | list of string | `[ ]` | Checked false positives. |
| `nixos.system.vulnscan.interval` | string | `"weekly"` on desktops, `"daily"` on servers | systemd OnCalendar expression of the scan. |
| `nixos.system.wireguard.dns` | null or string | `Pi-hole on NixOS-Server1 for desktops` | DNS server used for all domains while the tunnel is up (Pi-hole on NixOS-Server1). |
| `nixos.system.wireguard.enable` | boolean | `false` | Enable the WireGuard network. |
| `nixos.system.wireguard.enrolled` | boolean | `false` | Whether this host has a public key in the peer list, so the hub accepts it. |
| `nixos.system.wireguard.hasPeers` | boolean | `true` | Whether peers with public keys exist for this host. |
| `nixos.system.wireguard.hubAddress` | string | `config.nixos.site.serverPublic.ipv4` | Public IP of the hub (an IP, so the tunnel works without DNS and can bypass Mullvad). |
| `nixos.system.wireguard.interface` | string | `"wg0"` | Name of the WireGuard interface. |
| `nixos.system.wireguard.mullvadBypass` | boolean | `true` | Let traffic to the hub bypass Mullvad (needed with Mullvad lockdown mode). |
| `nixos.system.wireguard.port` | 16 bit unsigned integer; between 0 and 65535 (both inclusive) | `51820` | Listen port of the hub. |
| `nixos.system.wireguard.subnet` | string | `"10.100.0.0/24"` | WireGuard subnet, routed through the tunnel on the peers (split tunnel). |

## Notes

- Features that need secrets which do not exist yet are disabled by default, see `TODO.md`.
