{ config, lib, pkgs, inputs, ... }:

{
  imports = [ 
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];
  
  nixpkgs.overlays = [ 
    inputs.nix-minecraft.overlay 
  ];
  
  services.minecraft-server = {
    enable = true;
    eula = true;

    servers = {
      flolserver = {
        enable = true;
        autoStart = true;
        openFirewall = true;
        jvmOpts = "-Xmx8192M -Djava.net.preferIPV4stack=false -Djava.net.preferIPv6Addresses=true -Dlog4j2.formatMsgNoLookups=true";
        #package = pkgs.fabricServers.fabric-1_20_6;
        serverProperties = {
          #"&4&lFür=eine sozialistische Weltrevolution\!";
          accepts-transfers = false;
          allow-flight = false;
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
          generator-settings = {};
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
          motd = "§4§lWillkommen auf KSLEPMHH-MC§r\n§a§k****§6 Für eine sozialistische Weltrevolution\! §a§k****";
          network-compression-threshold = 256;
          online-mode = true;
          op-permission-level = 4;
          player-idle-timeout = 0;
          prevent-proxy-connections = false;
          pvp = true;
          query.port = 25565;
          rate-limit = 0;
          #rcon.password=
          rcon.port = 25575;
          region-file-compression = "deflate";
          require-resource-pack = false;
          #resource-pack=
          #resource-pack-id=
          #resource-pack-prompt=
          #resource-pack-sha1=
          server-ip = "0.0.0.0";
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
          white-list = false;
        };
      };

      creativserver = {
        enable = true;
        autoStart = true;
        openFirewall = true;
        jvmOpts = "-Xmx8192M -Djava.net.preferIPV4stack=false -Djava.net.preferIPv6Addresses=true -Dlog4j2.formatMsgNoLookups=true";
        #package = pkgs.fabricServers.fabric-1_20_6;
      };

      pvpserver = {
        enable = true;
        autoStart = true;
        openFirewall = true;
        jvmOpts = "-Xmx8192M -Djava.net.preferIPV4stack=false -Djava.net.preferIPv6Addresses=true -Dlog4j2.formatMsgNoLookups=true";
        #package = pkgs.vanillaServers.vanilla-1_8_9;
      };

      testserver = {
        enable = true;
        autoStart = true;
        openFirewall = true;
        jvmOpts = "-Xmx8192M -Djava.net.preferIPV4stack=false -Djava.net.preferIPv6Addresses=true -Dlog4j2.formatMsgNoLookups=true";
        #package = pkgs.fabricServers.fabric-1_20_6;
      };

      #goldenageserver = {
      #  enable = true;
      #  package = pkgs.vanillaServers.vanilla-;
      #  jvmOpts = "-Xmx8192M -Djava.net.preferIPV4stack=false -Djava.net.preferIPv6Addresses=true -Dlog4j2.formatMsgNoLookups=true";
      #};

      silverageserver = {
        enable = true;
        autoStart = true;
        openFirewall = true;
        jvmOpts = "-Xmx8192M -Djava.net.preferIPV4stack=false -Djava.net.preferIPv6Addresses=true -Dlog4j2.formatMsgNoLookups=true";
        #package = pkgs.vanillaServers.vanilla-1_7_10;
      };
    };
  };

  #services.bluemap = {
  #  enable = true;
  #  eula = true;
  #}

  services.nginx = {
    virtualHosts = {

    };
  };
}
