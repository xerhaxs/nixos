# SMS gateway (Gammu)

A SIM card server is a USB modem (or an old phone) with a SIM card on a server; `gammu-smsd` (NixOS: `services.gammu-smsd`) sends and receives SMS through it. Home Assistant can use the same modem directly with its `sms` integration (based on Gammu).

## What it is good for

- Alerts that do not need the internet: when the internet connection, the router or NixOS-ServerPublic is down, ntfy and mail alerts do not arrive; an SMS from NixOS-Server1 still does (power outage with UPS, water sensor, smoke detector, failed backup).
- Receiving SMS centrally: 2FA codes or messages to a second number end up in Home Assistant, Matrix or ntfy instead of an extra phone.
- Control by SMS: e.g. trigger the killswitch or a Home Assistant script with a message from your number (only with a shared secret in the text, sender numbers can be spoofed).
- Fallback notifications from Home Assistant to people without the ntfy app.

## Costs and risks

- Hardware: a USB LTE stick in modem mode (e.g. Huawei E3372 with "stick" firmware, Quectel EC25/EG25 on a USB adapter), about 20-60 EUR, plus a prepaid SIM (in Germany with identity check).
- SMS is unencrypted and the sender can be spoofed; never use SMS as the only factor for anything important.
- The SIM ties the server to your identity and reveals its location to the mobile network.
- The modem needs mobile reception in the server room; USB modems sometimes hang and need a power cycle (USB hub with power switch).

## Recommendation

Only worth it as an out-of-band alert channel if you want to be notified about failures that also take down the internet (power, router, flooding). For everything else ntfy and mail are better (encrypted, free, already set up). If you want it: the Home Assistant `sms` integration on NixOS-Server1 (modem passed through as `/dev/serial/by-id/...`) is simpler than a separate `gammu-smsd`, because the alert automations live in Home Assistant anyway. Listed in `TODO.md` as optional.
