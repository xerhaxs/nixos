# Workarounds

Own patches, overrides and settings that only exist because something upstream (nixpkgs, a package, a provider) is missing or broken. Each one should be removed once the cause is gone. Check this list after every `nix flake update` (see [`updates-and-vulnerabilities.md`](updates-and-vulnerabilities.md)) and remove the entry together with the code.

Deliberate design choices (hardening defaults, `UMask = "0007"` for the media services, the Dolphin places, declarative configs) are not listed here.

## Package patches and own packages

| What | Where | Why | Obsolete when / how to check |
|---|---|---|---|
| monero-gui: p2pool path | `pkgs/default.nix` | The GUI looks for p2pool next to its own binary and downloads it there, which fails in the store. Patched to use p2pool from nixpkgs and a writable working directory. | monero-gui finds p2pool on `PATH` or makes the path configurable. Check `src/p2pool/P2PoolManager.cpp` upstream; the build fails with `--replace-fail` once the lines change. |
| rclone: Proton upload deadlock | `pkgs/default.nix`, `pkgs/rclone/proton-upload-deadlock.patch` | Proton-API-Bridge (vendored in rclone) sends upload results into an unbuffered channel; after a failed block upload (e.g. a 502 from Proton) nobody reads it anymore, the remaining uploads block forever and keep their semaphore slot. After a few failures every upload hangs, the first restic backup to Proton Drive stalled on 16.11.2026 with 0 connections open. The patch buffers the channel. | `uploadAndCollectBlockData` in `github.com/rclone/Proton-API-Bridge/file_upload.go` uses a buffered `errChan` (check the version rclone vendors in `go.mod`); the build fails once the patch no longer applies. |
| `simplesqlite`, `sqliteschema`: `pythonRelaxDeps = [ "typepy" ]` | `pkgs/default.nix` | Both pin `typepy < 2`, nixpkgs ships 2.0 (needed by `sbomnix` for the CVE scan). | nixpkgs relaxes the pins itself. Remove the block and build `.#nixosConfigurations.NixOS-Server1.config.system.build.toplevel`. TODO 13.21. |
| hyprgrass | `pkgs/hyprgrass/`, inputs `hyprgrass-src`, `wf-touch-src` | The hyprgrass of nixpkgs does not build against the Hyprland version in use. | `nix build nixpkgs#hyprlandPlugins.hyprgrass` (with the flake's nixpkgs) builds against the current Hyprland. Then drop the package and the two inputs. |
| dangerzone | `pkgs/dangerzone/`, input `dangerzone` | Not in nixpkgs. Resource and tessdata paths are patched to the store. | A `dangerzone` package appears in nixpkgs. |
| vendor-reset: `modules_install` | `nixosModules/virtualisation/kvm.nix` | nixpkgs copies only the `.ko`, kernel 7.3 expects a `.ko.cer` per external module. | The nixpkgs package installs through `modules_install`. TODO 13.22. |
| waybar: workspace dispatch | `homeModules/desktop/windowManager/hyprland/waybar.nix` | Waybar sends the old `dispatch workspace`, Hyprland with a Lua config expects a Lua expression. | Waybar supports the Lua dispatcher of Hyprland. The build fails with `--replace-fail` once the lines change. |
| KMyMoney with Qt6 online banking | `homeModules/applications/office/kmymoney.nix` | gwenhywfar is built with the Qt5 GUI only; rebuilt with Qt6, aqbanking and KMyMoney on top, plus `LD_PRELOAD` of `libgmp`. | nixpkgs builds gwenhywfar with Qt6 and KMyMoney's online banking works without the override. |
| karere: X11 and GStreamer plugins | `homeModules/applications/communication/social.nix` | Runs with `WAYLAND_DISPLAY` unset and gets the GStreamer plugins on its path, otherwise it does not work on Wayland. | The nixpkgs package runs on Wayland with working calls and media. Test without the override. |
| Spectacle: OCR languages | `nixosModules/desktop/desktopEnvironment/plasma6.nix` | Spectacle's text recognition needs tesseract with `eng`, `deu`, `osd` on its path. | nixpkgs wraps Spectacle with tesseract and language data itself. |
| Back In Time: `crontab` wrapper | `homeModules/applications/tools/backintime.nix` | The package calls the `crontab` of the store, which has no setuid bit and cannot read `/var/cron`. | nixpkgs points Back In Time to `/run/wrappers/bin/crontab`. |
| weishaupt_modbus: import paths | `nixosModules/server/management/homeassistant.nix` | The component imports `config.custom_components.weishaupt_modbus.…`, which only works inside a Home Assistant config folder. | Upstream uses relative imports. |
| Matrix bridges without libolm | `nixosModules/server/public/matrix.nix` | libolm is marked insecure. Discord is built with `-tags=nocrypto`, Signal and WhatsApp with goolm, Telegram without end-to-bridge encryption. | The bridges drop libolm upstream or nixpkgs builds them with goolm by default. |
| Ventoy as insecure package | `nixosModules/system/nixos.nix` | `permittedInsecurePackages` names the exact version. | Adjust the version after every update, remove once nixpkgs no longer marks it insecure. TODO 13.5. |
| Lutris off on NixOS-Portable | `hosts/NixOS-Portable/home/home.nix` | The FHS environment needs GTK2, which nixpkgs marks as broken. | GTK2 builds again. TODO 13.20. |

## Service and module overrides

| What | Where | Why | Obsolete when / how to check |
|---|---|---|---|
| `PrivateUsers = false` for Radarr, Sonarr, Jellyfin | `nixosModules/server/entertainment/{radarr,sonarr,jellyfin}.nix` | nixpkgs sets `PrivateUsers = true`. In the private user namespace the supplementary group `share` is lost, imports from SABnzbd failed with "path does not exist or is not accessible" and Jellyfin cannot read files of other users. | nixpkgs keeps supplementary groups or drops `PrivateUsers`. Check the `serviceConfig` of the three modules in nixpkgs. Other services with `PrivateUsers` that join `share` need the same override. |
| Discord bridge: env file for the registration unit | `nixosModules/server/public/matrix.nix` | The nixpkgs module writes the Discord config in `mautrix-discord-registration`, the double puppet token has to be there too, otherwise the YAML breaks and Synapse does not start. | Only if the nixpkgs module changes how it generates the config. |
| Jellyfin: hardware transcoding set by hand | `nixosModules/server/entertainment/jellyfin.nix` (`forceEncodingConfig = false`) | NixOS writes `encoding.xml` only if it does not exist, `forceEncodingConfig = true` did not work in the test. QSV is set once in the dashboard (`Notes/Post-Installation.md`). | `forceEncodingConfig = true` works with the nixpkgs module. |
| hypridle off, hyprlock unit | `nixosModules/desktop/windowManager/hyprland.nix` | The NixOS module of hyprlock enables a user unit that `graphical-session.target` also starts in Plasma; Home Manager binds hypridle to `hyprland-session.target`. | The NixOS module binds it to the Hyprland session itself. |
| swaync only in Hyprland | `homeModules/desktop/windowManager/hyprland/swaync.nix` | swaync is the D-Bus activator of `org.freedesktop.Notifications`, the first notification in Plasma would start it and push out plasmashell. | Home Manager adds a desktop condition itself. |
| clamd: `RuntimeDirectoryPreserve` | `nixosModules/system/clamav.nix` | On the servers the nightly scan starts and stops clamd. Stopping removed `/run/clamav` with the socket file of `clamav-daemon.socket`, the next scan failed with "Could not connect to clamd". | The nixpkgs module keeps the socket outside the runtime directory or preserves it. |
| Glance: HTTP status in widgets | `nixosModules/server/management/glance-server-page.nix` (`httpError`) | Glance only fails on a non-2xx status when the body is not JSON. A 401 with JSON or an empty body renders an empty widget. | Glance reports every non-2xx response. Keep it otherwise, it costs nothing. |

## Network and providers

| What | Where | Why | Obsolete when / how to check |
|---|---|---|---|
| IPv6 keepalive on the VPS | `hosts/vps-uplink.nix` (`ipv6-keepalive`) | Contabo's router loses the IPv6 neighbor entry of an idle VPS and does not resolve it again, the host is unreachable over IPv6 ("No route to host"). A ping every 30 s keeps the entry. | Contabo fixes the router behaviour or the VPS moves. Test: stop the timer on NixOS-ServerGaming, wait a few hours, `ping -6 NixOS-ServerGaming`. |
| Blocklists normalized | `nixosModules/system/networking.nix` (`fetchBlocklist`) | Some lists hold bare domains or names with `_`, systemd-resolved logs every invalid line of `/etc/hosts`. | Only if the lists change format. |

## Waiting for upstream

Nothing to remove, but something to add once it exists.

| What | Where | Waiting for | TODO |
|---|---|---|---|
| Cameras on NixOS-Convertible (Dell Latitude 7320 Detachable) | `nixosModules/hardware/ipu6camera.nix`, enabled in `hosts/NixOS-Convertible/configuration.nix` | TPS68470 board data and the OV5678 driver in the kernel (patches on the lists since August 2026). Everything else is in place: libcamera, `qcam`, WirePlumber hides the raw IPU6 nodes, LibreWolf and Brave use PipeWire cameras. After the kernel update `cam -l` must list the cameras. | 24.4 |
| Invidious companion | `nixosModules/server/tools/invidious.nix` | A package or module option in nixpkgs, without it Invidious shows no videos. | 24.1 |
| KeePassXC auto-type with the Plasma virtual keyboard | none | KDE bug 520990 (Shift stays pressed after auto-type). | 24.2 |
| CryptPad update | none | nixpkgs PR 511890. | 24.3 |
| cockpit-zfs: `lsdev` | none | `lsdev` (procinfo) is not in nixpkgs, cockpit-zfs logs an error and continues. | – |
