{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.nixos.server.management.update-check;
  textfileDir = "/var/lib/prometheus-node-exporter";

  # Prints: <input> <type> <url> <locked rev> <wanted ref> <pinned rev>
  listInputs = pkgs.writeText "list-inputs.jq" ''
    .nodes as $nodes
    | .nodes.root.inputs
    | to_entries[]
    | .key as $name
    | $nodes[.value] as $node
    | select(($node.locked.url // "") | startswith("file:///") | not)
    | [
        $name,
        $node.locked.type,
        (if $node.locked.type == "github" then "https://github.com/\($node.locked.owner)/\($node.locked.repo)" else $node.locked.url end),
        ($node.locked.rev // "-"),
        ($node.original.ref // "-"),
        ($node.original.rev // "-")
      ]
    | @tsv
  '';

  script = pkgs.writeShellApplication {
    name = "update-check";
    runtimeInputs = with pkgs; [
      coreutils
      curl
      gawk
      git
      gnugrep
      gnused
      jq
      update-images
    ];
    # A source that cannot be reached is skipped, its update shows up with the next run.
    text = ''
      out="$(mktemp)"
      trap 'rm -f "$out"' EXIT

      emit() {
        printf 'nixos_update_available{kind="%s",name="%s",current="%s",latest="%s"} 1\n' "$1" "$2" "$3" "$4" >> "$out"
      }

      while IFS=$'\t' read -r name type url rev ref pinned; do
        case "$type" in
          github | git)
            if [[ "$ref" =~ ^(refs/tags/)?[a-z-]*v?[0-9]+\. ]]; then
              current="''${ref#refs/tags/}"
              prefix="$(sed -E 's/[0-9].*$//' <<< "$current")"
              latest="$(git ls-remote --tags --refs "$url" "$prefix*" 2>/dev/null \
                | sed 's|.*refs/tags/||' | grep -E "^$prefix[0-9.]+$" | sort -V | tail -n 1 || true)"
              if [ -n "$latest" ] && [ "$latest" != "$current" ]; then
                emit release "$name" "$current" "$latest"
              fi
            else
              branch=HEAD
              if [ "$pinned" = "-" ] && [ "$ref" != "-" ]; then
                branch="$ref"
              fi
              latest="$(git ls-remote "$url" "$branch" 2>/dev/null | head -n 1 | cut -c1-40 || true)"
              if [ -n "$latest" ] && [ "$latest" != "$rev" ]; then
                kind=flake-input
                if [ "$pinned" != "-" ]; then
                  kind=commit
                fi
                emit "$kind" "$name" "''${rev:0:7}" "''${latest:0:7}"
              fi
            fi
            ;;
          file)
            if [[ "$url" =~ cdn\.modrinth\.com/data/([A-Za-z0-9]+)/ ]]; then
              latest="$(curl -fsS --max-time 30 -G "https://api.modrinth.com/v2/project/''${BASH_REMATCH[1]}/version" \
                --data-urlencode 'loaders=["fabric"]' \
                --data-urlencode 'game_versions=[${builtins.toJSON cfg.minecraftVersion}]' \
                | jq -r '.[0].files[0].url // empty' || true)"
              if [ -n "$latest" ] && [ "$latest" != "$url" ]; then
                emit release "$name" "$(basename "$url")" "$(basename "$latest")"
              fi
            fi
            ;;
        esac
      done < <(jq -r -f ${listInputs} ${../../../flake.lock})

      while read -r name current latest; do
        if [ "$current" != "$latest" ]; then
          digest="''${current##*:}"
          new="''${latest##*:}"
          emit image "$name" "''${digest:0:12}" "''${new:0:12}"
        fi
      done < <(cd ${../../../pkgs} && update-images --check images.json 2>/dev/null || true)

      install -m 0644 "$out" ${textfileDir}/updates.prom
    '';
  };
in

{
  options.nixos = {
    server.management.update-check = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Compare the pinned sources and container images with upstream once a day and show pending updates in Grafana.";
      };

      minecraftVersion = lib.mkOption {
        type = lib.types.str;
        default = "1.21.11";
        description = "Minecraft version the pinned Fabric mods have to support.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.update-check = {
      description = "Look for updates of the pinned sources and images";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      environment = {
        HOME = "/run/update-check";
        XDG_RUNTIME_DIR = "/run/update-check";
      };
      serviceConfig = config.nixos.system.hardening.unitHardening // {
        Type = "oneshot";
        ExecStart = lib.getExe script;
        RuntimeDirectory = "update-check";
        ProtectSystem = "strict";
        ReadWritePaths = [ textfileDir ];
      };
    };

    systemd.timers.update-check = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        RandomizedDelaySec = "2h";
        Persistent = true;
      };
    };
  };
}
