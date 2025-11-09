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
      openFirewall = true;
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
          whitelist = {
            Ecki_0709 = "a36b2d29-b75c-4958-a7e7-05f65d2dd130";
            FaL4Fl = "8d385243-ee7c-4a95-88f0-f1243d528b7d";
            whoT0Tcares = "c36e9033-27b1-4847-959f-8fe006f22ef3";
            #Swagmaster420187 = "bab983f8-fe7f-475e-a258-ff12a39b0743";
            TheLegitTomy = "a152dcd4-a434-43e3-9935-d73dc3a32b91";
            LordofLegends = "70abdab0-df56-4751-beca-4b0ba9af5c5b";
            HungrigerBlu = "6590ccfe-13a6-4f35-9cc1-85e42089000d";
            Moritz3106 = "8eed86ad-81ca-46de-9db6-da5ad931e467";
            beholdTheSpoon = "e56f549c-3ba5-4da3-8e29-baad627f9ed0";
            xdSLostMyAim = "9e727edf-cfdc-4d93-8d05-48afa1b494ae";
            MadMartin1505 = "3c1082f6-ccdd-4952-b9fb-180e25d1b82b";
            #Lelakis = "b8d65aff-9b0a-4527-8cb6-a039cf541202";
            #Herobrine = "f84c6a79-0a4e-45e0-879b-cd49ebd4c4e2";
            Saucephobia = "1c70f40e-acab-4770-91e6-89573f9ac658";
            #TWEAKOUT = "e9d153b7-29d2-4c45-9eee-3dad760220fd";
            TruLixX = "646a3609-3d97-4961-be52-b95d2bced753";
            Romqn = "15609cc2-0a75-47b0-ac62-464dcdc330e9";
            Sir_Morton = "23691673-affb-4770-8e8d-c08346711c95";
            L0stMyN4me = "95579c4d-3e4e-425b-8250-90aa0dfd3d86";
            Sir_Morton_Cam = "f69a30fc-c981-4d37-a950-6d55a85781ad";
            #PflaumenTV = "78186090-fa9f-4434-b258-aa85d03f3881";
            #Chanero = "b50360f3-7308-4d69-9027-1682c62e24ca";
            Carry2006 = "3e7e0c94-1ee9-403d-8ccc-e104ef705072";
            CreepyLegion = "ec07f39a-e098-4e1a-87ef-1a1004295f67";
            Its_Buck = "54349426-e1a9-4ca1-bc79-ea366510aaf6";
            runoversquirrel = "f15cacc8-0441-4a23-860a-d4323770bc2c";
          };
          operators = {
            Sir_Morton = "23691673-affb-4770-8e8d-c08346711c95";
          };
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
            server-ip = "0.0.0.0";
            server-port = 25565;
            simulation-distance = 8;
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
        #"flolserver.${config.nixos.server.network.nginx.domain}" = {
        #  forceSSL = true;
        #  enableACME = true;
        #  acmeRoot = null;
        #  kTLS = true;
        #  http2 = false;
        #  locations."/" = { 
        #    proxyPass = "http://localhost:25565";
        #  };
        #};
        #"creativeserver.${config.nixos.server.network.nginx.domain}" = {
        #  forceSSL = true;
        #  enableACME = true;
        #  acmeRoot = null;
        #  kTLS = true;
        #  http2 = false;
        #  locations."/" = { 
        #    proxyPass = "http://localhost:25566";
        #  };
        #};
        #"pvpserver.${config.nixos.server.network.nginx.domain}" = {
        #  forceSSL = true;
        #  enableACME = true;
        #  acmeRoot = null;
        #  kTLS = true;
        #  http2 = false;
        #  locations."/" = { 
        #    proxyPass = "http://localhost:25567";
        #  };
        #};
        #"testserver.${config.nixos.server.network.nginx.domain}" = {
        #  forceSSL = true;
        #  enableACME = true;
        #  acmeRoot = null;
        #  kTLS = true;
        #  http2 = false;
        #  locations."/" = { 
        #    proxyPass = "http://localhost:25568";
        #  };
        #};
        #"silverageserver.${config.nixos.server.network.nginx.domain}" = {
        #  forceSSL = true;
        #  enableACME = true;
        #  acmeRoot = null;
        #  kTLS = true;
        #  http2 = false;
        #  locations."/" = { 
        #    proxyPass = "http://localhost:25569";
        #  };
        #};
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
