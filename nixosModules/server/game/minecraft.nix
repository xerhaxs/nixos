{ config, lib, pkgs, nix-minecraft, ... }:

# minecraft server shell with 'tmux -S /run/minecraft/servername.sock attach'

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
    };
  };

  config = lib.mkIf config.nixos.server.game.minecraft.enable {
    nixpkgs.overlays = [ 
      nix-minecraft.overlay
    ];

    services.minecraft-server = {
      enable = false;
      eula = true;
      jvmOpts = "-Xmx8192M -Djava.net.preferIPV4stack=false -Djava.net.preferIPv6Addresses=true -Dlog4j2.formatMsgNoLookups=true";
      package = pkgs.minecraftServers.vanilla-1_20_6;
    };

    services.minecraft-servers = {
      enable = true;
      eula = true;

      servers = {
        flolserver = {
          enable = true;
          autoStart = true;
          openFirewall = true;
          jvmOpts = "-Xmx8192M -Djava.net.preferIPV4stack=false -Djava.net.preferIPv6Addresses=true -Dlog4j2.formatMsgNoLookups=true";
          package = pkgs.fabricServers.fabric-1_20_6;
          serverProperties = {
            #"&4&lFür=eine sozialistische Weltrevolution\!";
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
            enforce-whitelist = false;
            entity-broadcast-range-percentage = 100;
            force-gamemode = true;
            function-permission-level = 2;
            gamemode = "survival";
            generate-structures = true;
            ##generator-settings = {};
            hardcore = false;
            hide-online-players = false;
            #initial-disabled-packs=
            initial-enabled-packs = "vanilla,fabric,fabric-convention-tags-v2,server_translations_api,universal-graves";
            level-name = "world";
            #level-seed=
            level-type = "minecraft\:normal";
            log-ips = true;
            max-chained-neighbor-updates = 1000000;
            max-players = 1917;
            max-tick-time = 60000;
            max-world-size = 29999984;
            motd = "§4§lWillkommen auf KSLEPMHH-Flolserver§r\n§a§k****§6 Für eine sozialistische Weltrevolution\! §a§k****";
            network-compression-threshold = 256;
            online-mode = true;
            op-permission-level = 4;
            player-idle-timeout = 0;
            prevent-proxy-connections = false;
            pvp = true;
            query-port = 25565;
            rate-limit = 0;
            #rcon.password=
            rcon-port = 25575;
            region-file-compression = "deflate";
            require-resource-pack = false;
            #resource-pack=
            #resource-pack-id=
            #resource-pack-prompt=
            #resource-pack-sha1=
            #server-ip = "0.0.0.0";
            server-port = 25565;
            simulation-distance = 10;
            snooper-enabled = false;
            spawn-animals = true;
            spawn-monsters = true;
            spawn-npcs = true;
            spawn-protection = 3;
            sync-chunk-writes = true;
            #text-filtering-config=
            use-native-transport = true;
            view-distance = 32;
            white-list = true;
          };
        };

        creativeserver = {
          enable = false;
          autoStart = true;
          openFirewall = true;
          jvmOpts = "-Xmx8192M -Djava.net.preferIPV4stack=false -Djava.net.preferIPv6Addresses=true -Dlog4j2.formatMsgNoLookups=true";
          package = pkgs.fabricServers.fabric-1_20_6;
          serverProperties = {
            #"&4&lFür=eine sozialistische Weltrevolution in Kreativ\!";
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
            enforce-whitelist = false;
            entity-broadcast-range-percentage = 100;
            force-gamemode = true;
            function-permission-level = 2;
            gamemode = "creative";
            generate-structures = true;
            #generator-settings = {};
            hardcore = false;
            hide-online-players = false;
            #initial-disabled-packs=
            initial-enabled-packs = "vanilla,fabric,fabric-convention-tags-v2,server_translations_api,universal-graves";
            level-name = "world";
            #level-seed=
            level-type = "minecraft\:normal";
            log-ips = false;
            max-chained-neighbor-updates = 1000000;
            max-players = 1917;
            max-tick-time = 60000;
            max-world-size = 29999984;
            motd = "§4§lWillkommen auf KSLEPMHH-Creative§r\n§a§k****§6 Für eine sozialistische Weltrevolution in Kreativ\! §a§k****";
            network-compression-threshold = 256;
            online-mode = true;
            op-permission-level = 4;
            player-idle-timeout = 0;
            prevent-proxy-connections = false;
            pvp = true;
            query-port = 25566;
            rate-limit = 0;
            #rcon.password=
            rcon-port = 25575;
            region-file-compression = "deflate";
            require-resource-pack = false;
            #resource-pack=
            #resource-pack-id=
            #resource-pack-prompt=
            #resource-pack-sha1=
            server-ip = "0.0.0.0";
            server-port = 25566;
            simulation-distance = 10;
            snooper-enabled = false;
            spawn-animals = true;
            spawn-monsters = true;
            spawn-npcs = true;
            spawn-protection = 3;
            sync-chunk-writes = true;
            #text-filtering-config=
            use-native-transport = true;
            view-distance = 32;
            white-list = true;
          };
        };

        pvpserver = {
          enable = false;
          autoStart = true;
          openFirewall = true;
          jvmOpts = "-Xmx8192M -Djava.net.preferIPV4stack=false -Djava.net.preferIPv6Addresses=true -Dlog4j2.formatMsgNoLookups=true";
          package = pkgs.vanillaServers.vanilla-1_8_9;
          serverProperties = {
            #"&4&lFür=eine gewaltvolle sozialistische Weltrevolution\!";
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
            enforce-whitelist = false;
            entity-broadcast-range-percentage = 100;
            force-gamemode = true;
            function-permission-level = 2;
            gamemode = "survival";
            generate-structures = true;
            #generator-settings = {};
            hardcore = false;
            hide-online-players = false;
            #initial-disabled-packs=
            initial-enabled-packs = "vanilla,fabric,fabric-convention-tags-v2,server_translations_api,universal-graves";
            level-name = "world";
            #level-seed=
            level-type = "minecraft\:normal";
            log-ips = false;
            max-chained-neighbor-updates = 1000000;
            max-players = 1917;
            max-tick-time = 60000;
            max-world-size = 29999984;
            motd = "§4§lWillkommen auf KSLEPMHH-PVP§r\n§a§k****§6 Für eine gewaltvolle sozialistische Weltrevolution\! §a§k****";
            network-compression-threshold = 256;
            online-mode = true;
            op-permission-level = 4;
            player-idle-timeout = 0;
            prevent-proxy-connections = false;
            pvp = true;
            query-port = 25567;
            rate-limit = 0;
            #rcon.password=
            rcon-port = 25575;
            region-file-compression = "deflate";
            require-resource-pack = false;
            #resource-pack=
            #resource-pack-id=
            #resource-pack-prompt=
            #resource-pack-sha1=
            server-ip = "0.0.0.0";
            server-port = 25567;
            simulation-distance = 10;
            snooper-enabled = false;
            spawn-animals = true;
            spawn-monsters = true;
            spawn-npcs = true;
            spawn-protection = 3;
            sync-chunk-writes = true;
            #text-filtering-config=
            use-native-transport = true;
            view-distance = 32;
            white-list = true;
          };
        };

        testserver = {
          enable = false;
          autoStart = true;
          openFirewall = true;
          jvmOpts = "-Xmx8192M -Djava.net.preferIPV4stack=false -Djava.net.preferIPv6Addresses=true -Dlog4j2.formatMsgNoLookups=true";
          package = pkgs.fabricServers.fabric-1_20_6;
          serverProperties = {
            #"&4&lFür=eine getestete sozialistische Weltrevolution\!";
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
            enforce-whitelist = false;
            entity-broadcast-range-percentage = 100;
            force-gamemode = true;
            function-permission-level = 2;
            gamemode = "creative";
            generate-structures = true;
            #generator-settings = {};
            hardcore = false;
            hide-online-players = false;
            #initial-disabled-packs=
            initial-enabled-packs = "vanilla,fabric,fabric-convention-tags-v2,server_translations_api,universal-graves";
            level-name = "world";
            #level-seed=
            level-type = "minecraft\:normal";
            log-ips = false;
            max-chained-neighbor-updates = 1000000;
            max-players = 1917;
            max-tick-time = 60000;
            max-world-size = 29999984;
            motd = "§4§lWillkommen auf KSLEPMHH-Test§r\n§a§k****§6 Für eine getestete sozialistische Weltrevolution\! §a§k****";
            network-compression-threshold = 256;
            online-mode = true;
            op-permission-level = 4;
            player-idle-timeout = 0;
            prevent-proxy-connections = false;
            pvp = true;
            query-port = 25568;
            rate-limit = 0;
            #rcon.password=
            rcon-port = 25575;
            region-file-compression = "deflate";
            require-resource-pack = false;
            #resource-pack=
            #resource-pack-id=
            #resource-pack-prompt=
            #resource-pack-sha1=
            server-ip = "0.0.0.0";
            server-port = 25568;
            simulation-distance = 10;
            snooper-enabled = false;
            spawn-animals = true;
            spawn-monsters = true;
            spawn-npcs = true;
            spawn-protection = 3;
            sync-chunk-writes = true;
            #text-filtering-config=
            use-native-transport = true;
            view-distance = 32;
            white-list = true;
          };
        };

        #goldenageserver = {
        #  enable = true;
        #  package = pkgs.vanillaServers.vanilla-;
        #  jvmOpts = "-Xmx8192M -Djava.net.preferIPV4stack=false -Djava.net.preferIPv6Addresses=true -Dlog4j2.formatMsgNoLookups=true";
        #};sha256-25/5edFiAh/9bgtXyCMogjZ4yDirhmiFOfwJPjCPXCY=

        silverageserver = {
          enable = false;
          autoStart = true;
          openFirewall = true;
          jvmOpts = "-Xmx8192M -Djava.net.preferIPV4stack=false -Djava.net.preferIPv6Addresses=true -Dlog4j2.formatMsgNoLookups=true";
          package = pkgs.vanillaServers.vanilla-1_7_10;
          serverProperties = {
            #"&4&lFür=eine klassische sozialistische Weltrevolution\!";
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
            enforce-whitelist = false;
            entity-broadcast-range-percentage = 100;
            force-gamemode = true;
            function-permission-level = 2;
            gamemode = "survival";
            generate-structures = true;
            #generator-settings = {};
            hardcore = false;
            hide-online-players = false;
            #initial-disabled-packs=
            initial-enabled-packs = "vanilla,fabric,fabric-convention-tags-v2,server_translations_api,universal-graves";
            level-name = "world";
            #level-seed=
            level-type = "minecraft\:normal";
            log-ips = false;
            max-chained-neighbor-updates = 1000000;
            max-players = 1917;
            max-tick-time = 60000;
            max-world-size = 29999984;
            motd = "§4§lWillkommen auf KSLEPMHH-SilverAge§r\n§a§k****§6 Für eine klassische sozialistische Weltrevolution\! §a§k****";
            network-compression-threshold = 256;
            online-mode = true;
            op-permission-level = 4;
            player-idle-timeout = 0;
            prevent-proxy-connections = false;
            pvp = true;
            query-port = 25569;
            rate-limit = 0;
            #rcon.password=
            rcon-port = 25575;
            region-file-compression = "deflate";
            require-resource-pack = false;
            #resource-pack=
            #resource-pack-id=
            #resource-pack-prompt=
            #resource-pack-sha1=
            server-ip = "0.0.0.0";
            server-port = 25569;
            simulation-distance = 10;
            snooper-enabled = false;
            spawn-animals = true;
            spawn-monsters = true;
            spawn-npcs = true;
            spawn-protection = 3;
            sync-chunk-writes = true;
            #text-filtering-config=
            use-native-transport = true;
            view-distance = 32;
            white-list = true;
          };
        };
      };
    };

    services.nginx = {
      virtualHosts = {
        "flolserver.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = { 
            proxyPass = "http://localhost:25565";
          };
        };
        "creativeserver.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = { 
            proxyPass = "http://localhost:25566";
          };
        };
        "pvpserver.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = { 
            proxyPass = "http://localhost:25567";
          };
        };
        "testserver.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = { 
            proxyPass = "http://localhost:25568";
          };
        };
        "silverageserver.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = { 
            proxyPass = "http://localhost:25569";
          };
        };
        "bluemap.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = { 
            proxyPass = "http://localhost:8100";
          };
        };
        "map.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = { 
            proxyPass = "http://localhost:8100";
          };
        };
      };
    };

    services.ddclient.domains = [
      "flolserver.${config.nixos.server.network.nginx.domain}"
      "bluemap.${config.nixos.server.network.nginx.domain}"
      "map.${config.nixos.server.network.nginx.domain}"
    ];
  };
}
