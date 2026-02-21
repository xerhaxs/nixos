{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    userEnvironment.syncthing = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Syncthing.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.syncthing.enable {
    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

    services.syncthing = {
      enable = true;
      systemService = true;
      user = "${config.nixos.system.user.defaultuser.name}";
      group = "users";
      cert = config.sops.secrets."syncthing/${lib.toLower config.networking.hostName}/cert".path;
      key = config.sops.secrets."syncthing/${lib.toLower config.networking.hostName}/key".path;
      dataDir = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.home.homeDirectory
      }";
      configDir = config.services.syncthing.dataDir + "/.config/syncthing";
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
          tls = true;
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
            path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.desktop
            }";
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
            path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.documents
            }";
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
            path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.download
            }";
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
            path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.music
            }";
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
            path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.pictures
            }";
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
            path = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.videos
            }";
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
            path = "/home/${config.nixos.system.user.defaultuser.name}/.config/FreeTube";
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
            path = "${
              config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.documents
            }/GraphenOS/Android";
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
            path = "${
              config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.documents
            }/GraphenOS/GraphenOS";
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
            path = "${
              config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.pictures
            }/Pixel 6a Kamera";
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
            path = "${
              config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.music
            }/Musik";
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
            path = "${
              config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.documents
            }/Wichtige Datein";
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
  };
}
