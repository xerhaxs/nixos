{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:

let
  # Defaults are only written when the key is missing, changes made in the app are kept.
  defaults = {
    theme = "system";
    fetchInterval = 30;
    searchEngine = 3;
    serviceConfigs = {
      type = 5;
      endpoint = "https://rss.${osConfig.nixos.site.domain}";
      apiKeyAuth = true;
      authKey = "";
      fetchLimit = 250;
      importGroups = true;
    };
  };
in

{
  options.homeManager = {
    applications.media.fluentreader = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Fluent Reader (RSS reader, synced with Miniflux).";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.media.fluentreader.enable {
    home.packages = with pkgs; [
      fluent-reader
    ];

    home.activation.fluentReaderConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      CONFIG="$HOME/.config/Fluent Reader/config.json"
      mkdir -p "$(dirname "$CONFIG")"
      [ -s "$CONFIG" ] || echo '{}' > "$CONFIG"
      ${pkgs.jq}/bin/jq --argjson defaults ${lib.escapeShellArg (builtins.toJSON defaults)} \
        '$defaults + .' "$CONFIG" > "$CONFIG.tmp" && mv "$CONFIG.tmp" "$CONFIG"
    '';

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/Fluent Reader"
      ];
    };
  };
}
