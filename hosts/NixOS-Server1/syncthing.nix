{
  config,
  lib,
  pkgs,
  ...
}:

{
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

  services.syncthing = {
    enable = true;
    systemService = true;
    user = "syncthing";
    group = "syncthing";
    cert = config.sops.secrets."syncthing/${lib.toLower config.networking.hostName}/cert".path;
    key = config.sops.secrets."syncthing/${lib.toLower config.networking.hostName}/key".path;
    #guiPasswordFile =
    #  config.sops.secrets."syncthing/${lib.toLower config.networking.hostName}/login".path;
    #dataDir = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.home.homeDirectory}";
    #configDir = config.services.syncthing.dataDir + "/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    openDefaultPorts = true;

    settings = {
      options = {
        urAccepted = -1;
        globalAnnounceEnabled = false;
        localAnnounceEnabled = true;
        relaysEnabled = false;
        startBrowser = false;
        crashReportingEnabled = false;
      };

      gui = {
        user = "${config.nixos.system.user.defaultuser.name}";
        theme = lib.strings.toLower "black";
        tls = false;
        address = "0.0.0.0:8384";
        insecureAllowFrameLoading = true;
        #insecureSkipHostcheck = true;
        allowedOrigins = [ "syncthing.${config.nixos.server.network.nginx.domain}" ];
      };

      devices = {
        NixOS-Convertible = {
          name = "NixOS-Convertible";
          id = "MUOQSA5-7L5PSY4-DV3IYPW-VPCRMW6-RWOTIBN-DU27J42-AML2NCX-JGEMBQC";
          autoAcceptFolders = false;
        };
        NixOS-Desktop = {
          name = "NixOS-Desktop";
          id = "PVZV2NU-LFXP33P-6I4XSXQ-M3TZWJN-HJOB2UC-2GLQSIE-GGF2TZ4-N22MAQN";
          autoAcceptFolders = false;
        };
        NixOS-Framework = {
          name = "NixOS-Framework";
          id = "FSX7XGK-OPZCHEB-GGK5B2Z-S6KINWL-WWTSUFA-WBIZFQW-I7HZF6L-IKH2NAW";
          autoAcceptFolders = false;
        };
        NixOS-Server1 = {
          name = "NixOS-Server1";
          id = "7NQB6WA-LNGXLBN-4VCFKIX-Z64IF5D-RZSGTIT-7DP6I46-LSKOXYH-AVOV2QQ";
          autoAcceptFolders = false;
        };
        GraphenOS = {
          name = "GraphenOS";
          id = "PTKSZUI-6RLFFB5-JJJ2OQL-YNBAI76-YOZWY7L-VURDNL2-AX7ZTE4-CAYLJQG";
          autoAcceptFolders = false;
        };
      };

      folders = {
        # "sendreceive", "sendonly", "receiveonly", "receiveencrypted"
        "Desktop" = {
          path = "/pool01/shares/jf/Desktop";
          id = "Desktop";
          type = "sendreceive";
          devices = [
            "NixOS-Convertible"
            "NixOS-Desktop"
            "NixOS-Framework"
            "NixOS-Server1"
          ];
          copyOwnershipFromParent = false;
          ignorePerms = true;
          fsWatcherEnabled = true;
          fsWatcherDelayS = 5;
          rescanIntervalS = 60;
        };
        "Documents" = {
          path = "/pool01/shares/jf/Dokumente";
          id = "Documents";
          type = "sendreceive";
          devices = [
            "NixOS-Convertible"
            "NixOS-Desktop"
            "NixOS-Framework"
            "NixOS-Server1"
          ];
          copyOwnershipFromParent = false;
          ignorePerms = true;
          fsWatcherEnabled = true;
          fsWatcherDelayS = 5;
          rescanIntervalS = 60;
        };
        "Downloads" = {
          path = "/pool01/shares/jf/Downloads";
          id = "Downloads";
          type = "sendreceive";
          devices = [
            "NixOS-Convertible"
            "NixOS-Desktop"
            "NixOS-Framework"
            "NixOS-Server1"
            "GraphenOS"
          ];
          copyOwnershipFromParent = false;
          ignorePerms = true;
          fsWatcherEnabled = true;
          fsWatcherDelayS = 5;
          rescanIntervalS = 60;
        };
        "Music" = {
          path = "/pool01/shares/jf/Musik";
          id = "Music";
          type = "sendreceive";
          devices = [
            "NixOS-Convertible"
            "NixOS-Desktop"
            "NixOS-Framework"
            "NixOS-Server1"
          ];
          copyOwnershipFromParent = false;
          ignorePerms = true;
          fsWatcherEnabled = true;
          fsWatcherDelayS = 10;
          rescanIntervalS = 3600;
        };
        "Pictures" = {
          path = "/pool01/shares/jf/Bilder";
          id = "Pictures";
          type = "sendreceive";
          devices = [
            "NixOS-Convertible"
            "NixOS-Desktop"
            "NixOS-Framework"
            "NixOS-Server1"
          ];
          copyOwnershipFromParent = false;
          ignorePerms = true;
          fsWatcherEnabled = true;
          fsWatcherDelayS = 60;
          rescanIntervalS = 3600;
        };
        "Videos" = {
          path = "/pool01/shares/jf/Videos";
          id = "Videos";
          type = "sendreceive";
          devices = [
            "NixOS-Desktop"
            "NixOS-Server1"
          ];
          copyOwnershipFromParent = false;
          ignorePerms = true;
          fsWatcherEnabled = true;
          fsWatcherDelayS = 60;
          rescanIntervalS = 3600;
        };

        "FreeTube" = {
          path = "/pool01/shares/jf/FreeTube";
          id = "FreeTube";
          type = "sendreceive";
          devices = [
            "NixOS-Convertible"
            "NixOS-Desktop"
            "NixOS-Framework"
            "NixOS-Server1"
          ];
          copyOwnershipFromParent = false;
          ignorePerms = true;
          fsWatcherEnabled = true;
          fsWatcherDelayS = 5;
          rescanIntervalS = 60;
        };

        "Android" = {
          path = "/pool01/shares/jf/Dokumente/GraphenOS/Android";
          id = "Android";
          type = "sendreceive";
          devices = [ "GraphenOS" ];
          copyOwnershipFromParent = false;
          ignorePerms = true;
          fsWatcherEnabled = true;
          fsWatcherDelayS = 60;
          rescanIntervalS = 3600;
        };
        "GraphenOS" = {
          path = "/pool01/shares/jf/Dokumente/GraphenOS/GraphenOS";
          id = "GraphenOS";
          type = "sendreceive";
          devices = [ "GraphenOS" ];
          copyOwnershipFromParent = false;
          ignorePerms = true;
          fsWatcherEnabled = true;
          fsWatcherDelayS = 60;
          rescanIntervalS = 3600;
        };
        "Pixel 6a Kamera" = {
          path = "/pool01/shares/jf/Bilder/Pixel 6a Kamera";
          id = "Pixel 6a Kamera";
          type = "sendreceive";
          devices = [ "GraphenOS" ];
          copyOwnershipFromParent = false;
          ignorePerms = true;
          fsWatcherEnabled = true;
          fsWatcherDelayS = 10;
          rescanIntervalS = 3600;
        };
        "Pixel 6a Musik" = {
          path = "/pool01/shares/jf/Musik/Musik";
          id = "Pixel 6a Musik";
          type = "sendonly";
          devices = [ "GraphenOS" ];
          copyOwnershipFromParent = false;
          ignorePerms = true;
          fsWatcherEnabled = true;
          fsWatcherDelayS = 60;
          rescanIntervalS = 3600;
        };
        "Wichtige Dateien" = {
          path = "/pool01/shares/jf/Dokumente/Wichtige Datein";
          id = "Wichtige Dateien";
          type = "sendonly";
          devices = [ "GraphenOS" ];
          copyOwnershipFromParent = false;
          ignorePerms = true;
          fsWatcherEnabled = true;
          fsWatcherDelayS = 60;
          rescanIntervalS = 3600;
        };
      };
    };
  };

  services.nginx = {
    virtualHosts = {
      "syncthing.${config.nixos.server.network.nginx.domain}" = {
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;
        kTLS = true;
        http2 = false;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8384";
          proxyWebsockets = true;
        };
      };
    };
  };
}
