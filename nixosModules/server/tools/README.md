# tools

## Purpose

Web tools, private frontends and local AI.

## How it works

- Invidious, Redlib, SearXNG, Kiwix, LanguageTool, LibreTranslate, Networking Toolbox, Ollama with web UI (Vulkan, `gpu` selects the vendor), ComfyUI (Stable Diffusion in a podman container with Intel XPU), code-server (VS Code with LaTeX, only through WireGuard) and a pruned Monero node with P2Pool.

## Contents

| Path | Description |
|---|---|
| [`config/`](config/README.md) | Configuration files used by the tool modules. |
| `codeserver.nix` | Enable code-server (VS Code in the browser) with LaTeX. |
| `comfyui.nix` | Enable ComfyUI (Stable Diffusion) in a podman container with Intel GPU (XPU) acceleration. |
| `default.nix` | Imports the modules of this folder and defines the bundle option `nixos.server.tools.enable`. |
| `invidious.nix` | Enable Invidious. |
| `kiwix.nix` | Enable kiwix server. |
| `languagetool.nix` | Enable languagetool. |
| `libreddit.nix` | Enable Libreddit. |
| `libretranslate.nix` | Enable libretranslate server. |
| `moneronode.nix` | Enable a pruned Monero node. |
| `networkingtoolbox.nix` | Enable networking-toolbox. |
| `ollama.nix` | Enable Ollama. |
| `searxng.nix` | Enable Searxng. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nixos.server.tools.codeserver.enable` | boolean | `false` | Enable code-server (VS Code in the browser) with LaTeX. |
| `nixos.server.tools.codeserver.listenAddress` | string | `"10.100.0.1"` | Address nginx serves code-server on (WireGuard IP of the host). |
| `nixos.server.tools.codeserver.texlive` | package | `pkgs.texliveFull` | TeX Live distribution available in code-server. |
| `nixos.server.tools.codeserver.user` | string | `"jf"` | Unprivileged user code-server runs as (no wheel). |
| `nixos.server.tools.comfyui.enable` | boolean | `false` | Enable ComfyUI (Stable Diffusion) in a podman container with Intel GPU (XPU) acceleration. |
| `nixos.server.tools.comfyui.extraArgs` | string | `"--enable-manager"` | Additional ComfyUI command line arguments (CLI_ARGS). |
| `nixos.server.tools.comfyui.image` | string | `"docker.io/yanwk/comfyui-boot:xpu-20261012@sha256:310bc8d...` | Container image, pinned to a digest. Variants: xpu (Intel), rocm (AMD), cpu. |
| `nixos.server.tools.enable` | boolean | `false` | Enable tools modules bundle. |
| `nixos.server.tools.invidious.enable` | boolean | `false` | Enable Invidious. |
| `nixos.server.tools.kiwix.enable` | boolean | `false` | Enable kiwix server. |
| `nixos.server.tools.languagetool.enable` | boolean | `false` | Enable languagetool. |
| `nixos.server.tools.libreddit.enable` | boolean | `false` | Enable Libreddit. |
| `nixos.server.tools.libretranslate.enable` | boolean | `false` | Enable libretranslate server. |
| `nixos.server.tools.moneronode.enable` | boolean | `false` | Enable a pruned Monero node. |
| `nixos.server.tools.moneronode.p2pool.enable` | boolean | `false` | Enable P2Pool (mini sidechain) for miners in the LAN (secret monero/p2pool-env with WALLET_ADDRESS). |
| `nixos.server.tools.moneronode.p2pool.stratumPort` | 16 bit unsigned integer; between 0 and 65535 (both inclusive) | `3333` | Stratum port miners (xmrig) connect to. |
| `nixos.server.tools.moneronode.restrictedRpcPort` | 16 bit unsigned integer; between 0 and 65535 (both inclusive) | `18089` | Port of the restricted RPC for wallets in the LAN and the WireGuard network. |
| `nixos.server.tools.networkingtoolbox.enable` | boolean | `false` | Enable networking-toolbox. |
| `nixos.server.tools.ollama.enable` | boolean | `false` | Enable Ollama. |
| `nixos.server.tools.ollama.gpu` | one of "any", "amd", "intel" | `"any"` | Restrict the Vulkan backend to the GPUs of one vendor (selects the Vulkan driver file). |
| `nixos.server.tools.ollama.models` | list of string | `[   "deepseek-r1:1.5b"   "deepseek-r1:7b"   "deepseek-r1:...` | Models pulled at startup. |
| `nixos.server.tools.searxng.enable` | boolean | `false` | Enable Searxng. |
