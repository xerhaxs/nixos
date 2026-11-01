{
  jq,
  skopeo,
  writeShellApplication,
}:

# flake.lock cannot pin registry images, pkgs/images.json is the single place for their digests.
# update-images rewrites it, update-images --check only prints "name current latest" per image.
writeShellApplication {
  name = "update-images";

  runtimeInputs = [
    jq
    skopeo
  ];

  text = ''
    check=false
    if [ "''${1:-}" = "--check" ]; then
      check=true
      shift
    fi
    file="''${1:-pkgs/images.json}"

    latest() {
      local base repo tag
      base="''${1%@*}"
      repo="''${base%:*}"
      tag="''${base##*:}"
      # Dated tags (xpu-20261012) move to the newest date with the same prefix, others keep their tag.
      if [[ "$tag" =~ ^(.*-)[0-9]{8}$ ]]; then
        tag="$(skopeo list-tags "docker://$repo" \
          | jq -r --arg prefix "''${BASH_REMATCH[1]}" '.Tags[] | select(test("^" + $prefix + "[0-9]{8}$"))' \
          | sort | tail -n 1)"
      fi
      echo "$repo:$tag@$(skopeo inspect --no-tags --format '{{.Digest}}' "docker://$repo:$tag")"
    }

    while read -r name; do
      current="$(jq -r --arg name "$name" '.[$name]' "$file")"
      new="$(latest "$current")"
      if [ "$check" = true ]; then
        printf '%s %s %s\n' "$name" "$current" "$new"
      elif [ "$current" != "$new" ]; then
        tmp="$(mktemp)"
        jq --arg name "$name" --arg new "$new" '.[$name] = $new' "$file" > "$tmp"
        mv "$tmp" "$file"
        echo "$name: $new"
      fi
    done < <(jq -r 'keys[]' "$file")
  '';
}
