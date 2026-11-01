{
  config,
  lib,
  pkgs,
  nix-minecraft,
  userName,
  ...
}:

{
  imports = [
    nix-minecraft.nixosModules.minecraft-servers
  ];

  options.nixos = {
    server.game.minecraft = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Minecraft Server.";
      };

      serverProperties = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        description = "Common server.properties for all instances, merged with the instance specific values in the host.";
        default = {
          accepts-transfers = false;
          allow-flight = true;
          allow-nether = true;
          broadcast-console-to-ops = true;
          broadcast-rcon-to-ops = true;
          difficulty = "hard";
          enable-command-block = true;
          enable-jmx-monitoring = false;
          enable-query = false;
          enable-rcon = false;
          enable-status = true;
          enforce-secure-profile = false;
          enforce-whitelist = true;
          entity-broadcast-range-percentage = 100;
          force-gamemode = true;
          function-permission-level = 2;
          gamemode = "survival";
          generate-structures = true;
          hardcore = false;
          hide-online-players = false;
          initial-enabled-packs = "vanilla,fabric,fabric-convention-tags-v2,server_translations_api,universal-graves";
          level-name = "world";
          level-type = "minecraft\:normal";
          log-ips = false;
          max-chained-neighbor-updates = 1000000;
          max-players = 1917;
          max-tick-time = 60000;
          max-world-size = 29999984;
          network-compression-threshold = 256;
          online-mode = true;
          op-permission-level = 4;
          player-idle-timeout = 0;
          prevent-proxy-connections = false;
          pvp = true;
          rate-limit = 0;
          rcon-port = 25575;
          region-file-compression = "deflate";
          require-resource-pack = false;
          server-ip = "0.0.0.0";
          simulation-distance = 10;
          snooper-enabled = false;
          spawn-animals = true;
          spawn-monsters = true;
          spawn-npcs = true;
          spawn-protection = 3;
          sync-chunk-writes = true;
          use-native-transport = true;
          view-distance = 32;
          white-list = true;
        };
      };
    };
  };

  config = lib.mkIf config.nixos.server.game.minecraft.enable {
    nixpkgs.overlays = [
      nix-minecraft.overlay
    ];

    services.minecraft-servers = {
      enable = true;
      eula = true;
      dataDir = "/srv/minecraft";
    };

    users.users."${userName}" = {
      extraGroups = [
        "minecraft"
      ];
    };

    environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        {
          directory = "/srv/minecraft";
          user = "minecraft";
          group = "minecraft";
          mode = "0770";
        }
      ];
    };
  };
}
