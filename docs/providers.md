# Domain registrars, DNS, DDoS protection and VPS hosting

Today Cloudflare is the DNS provider (and the ACME dns-01 API). Requirements for a replacement: DNSSEC, an API supported by lego (the ACME client of NixOS, needed for dns-01 wildcard certificates), privacy, optional Monero payment. Verify prices, payment options and KYC rules before ordering, they change often.

## Registrars

| Registrar | Country | Monero | Privacy | API / lego provider | Notes |
|---|---|---|---|---|---|
| Njalla | Nevis / Sweden | yes | registers the domain in its own name (you are the "user", not the owner) | yes, `njalla` | strongest privacy, legal ownership risk if Njalla disappears |
| OrangeWebsite | Iceland | yes (also BTC) | WHOIS privacy, little KYC | no lego provider, use external DNS | also offers VPS with crypto payment |
| Incognet | US | yes | WHOIS privacy | no lego provider | reported to accept Monero, more expensive |
| INWX | Germany | no | GDPR WHOIS redaction | yes, `inwx` | solid German registrar, DNSSEC, 2FA |
| Porkbun | US | no | free WHOIS privacy | yes, `porkbun` | cheap, good API |
| Netcup / Hetzner | Germany | no | GDPR | yes, `netcup` / `hetzner` | combine domain and VPS at one provider |

Payment in Monero is also possible at registrars without direct support through payment gateways (they convert to fiat), with less privacy.

## DNS hosting (separate from the registrar)

| Provider | Notes |
|---|---|
| deSEC (desec.io) | Free, non-profit (Berlin), DNSSEC by default, API, lego provider `desec`. Recommended replacement for Cloudflare DNS. |
| Hetzner DNS | Free with a Hetzner account, API, lego `hetzner`. |
| Own authoritative DNS (Knot/NSD on NixOS-ServerPublic + a secondary) | Full control, more work, needs a second server for redundancy. |

Changing the ACME provider in this repository: `security.acme.defaults.dnsProvider` in `nixosModules/server/network/nginx.nix` and the secret `nginx/acme/api_key` (e.g. `DESEC_TOKEN=...` for deSEC).

## DDoS protection

| Option | Notes |
|---|---|
| Network-level protection of the VPS provider | Hetzner, OVH (VAC), netcup and others filter volumetric attacks for free. Enough for a personal server. |
| Bunny.net (Shield / CDN) | EU company, cheap reverse proxy with WAF and DDoS filtering for HTTP; TLS terminates at Bunny (they can read the traffic). |
| Myra Security | German, BSI certified, enterprise pricing. |
| Gcore | Reverse proxy and DDoS protection, also for non-HTTP. |
| Path.net / TCPShield | Protection for game servers (Minecraft). |
| Deflect | Free protection for civil society organisations. |

Every reverse proxy in front of the server (like Cloudflare today) terminates TLS and sees the traffic in clear text. For mail, Matrix federation, Mumble and WireGuard a proxy does not work anyway; only the provider-level protection applies. Recommendation: no HTTP proxy, rely on the provider protection, rate limits in nginx and fail2ban.

## VPS hosting

| Provider | Monero | Notes |
|---|---|---|
| Contabo | no | used for NixOS-ServerPublic and NixOS-ServerGaming, S3 compatible object storage, gateway and netmask are shown in the customer panel (static network) |
| Hetzner Cloud / dedicated | no | good price, DDoS protection, Storage Box for backups (already used), data centers in Germany/Finland |
| netcup | no | cheap root servers with dedicated cores, Germany |
| OVH | no | DDoS protection (VAC), bare metal with AMD SEV-SNP options |
| Njalla VPS | yes | privacy focused, small VMs, more expensive |
| OrangeWebsite VPS | yes | Iceland, free speech focus |
| 1984 Hosting | check | Iceland, privacy focus |

Confidential computing (AMD SEV-SNP / Intel TDX, protects RAM against the provider) is rarely available for small VPS; check the offer if this matters (see `e2ee-and-runtime-protection.md`).
