# network

## Purpose

Network services: reverse proxy, DNS, VPN and brute force protection.

## How it works

- nginx with recommended TLS settings, a catch-all vhost that rejects unknown hostnames and global security headers (`securityHeaders`, repeat them in locations with own `add_header`).
- ACME via Cloudflare dns-01 (`challenge`), the mail domain uses http-01; `selfsigned` replaces ACME with one self-signed wildcard certificate (offline, portable host).
- Pi-hole (blocklists, local DNS records from `nixos.system.networking.lan.hosts`) in front of Unbound (DNSSEC validating resolver, recursive without Mullvad; with Mullvad it forwards over DNS-over-TLS to dns.mullvad.net, because Mullvad rejects plain DNS to other servers).
- Mullvad on the server (lockdown mode), fail2ban for the web services.

## Contents

| Path | Description |
|---|---|
| `default.nix` | Imports the modules of this folder and defines the bundle option `nixos.server.network.enable`. |
| `fail2ban.nix` | Enable fail2ban for the web services (ssh is protected by sshguard). |
| `mullvad-server.nix` | Enable mullvad vpn for server (logs in only if no device exists, `/etc/mullvad-vpn` is persisted). |
| `nginx.nix` | Enable Nginx. |
| `pihole.nix` | Enable PiHole. |
| `unbound.nix` | Enable unbound. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nixos.server.network.enable` | boolean | `false` | Enable network modules bundle. |
| `nixos.server.network.fail2ban.enable` | boolean | `false` | Enable fail2ban for the web services (ssh is protected by sshguard). |
| `nixos.server.network.mullvad-server.enable` | boolean | `false` | Enable mullvad vpn for server. |
| `nixos.server.network.nginx.acmeEmail` | string | `config.nixos.site.acmeEmail` | Contact email for ACME (Let's Encrypt). |
| `nixos.server.network.nginx.challenge` | one of "dns-01", "http-01", "selfsigned" | `"dns-01"` | Set the default ACME challenge, selfsigned uses a self-signed wildcard certificate without ACME. |
| `nixos.server.network.nginx.domain` | string | `config.nixos.site.domain` | Domain for nginx. |
| `nixos.server.network.nginx.enable` | boolean | `false` | Enable Nginx. |
| `nixos.server.network.nginx.securityHeaders` | strings concatenated with "\n" | `''   add_header Strict-Transport-Security "max-age=630720...` | Security headers of all vhosts, repeat them in locations with own add_header (nginx drops inherited headers there). |
| `nixos.server.network.pihole.enable` | boolean | `false` | Enable PiHole. |
| `nixos.server.network.unbound.enable` | boolean | `false` | Enable unbound. |
