{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.gaming.heroic = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable heroic.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.gaming.heroic.enable {
    home.packages = with pkgs; [
      heroic
    ];

    /* xdg.configFile."heroic/config.json".text = ''
      {
        "defaultSettings": {
          "analyticsOptIn": false,
          "checkUpdatesInterval": 10,
          "enableUpdates": false,
          "addDesktopShortcuts": false,
          "addStartMenuShortcuts": false,
          "autoInstallDxvk": true,
          "autoInstallVkd3d": true,
          "autoInstallDxvkNvapi": true,
          "addSteamShortcuts": false,
          "preferSystemLibs": false,
          "checkForUpdatesOnStartup": false,
          "autoUpdateGames": false,
          "customWinePaths": [],
          "defaultInstallPath": "${config.xdg.userDirs.extraConfig.GAMES}/Heroic",
          "libraryTopSection": "recently_played",
          "defaultSteamPath": "${config.xdg.userDirs.extraConfig.GAMES}/Steam",
          "defaultWinePrefix": "${config.xdg.userDirs.extraConfig.GAMES}/Heroic/Wine",
          "hideChangelogsOnStartup": false,
          "language": "de",
          "maxWorkers": 0,
          "minimizeOnLaunch": false,
          "nvidiaPrime": false,
          "enviromentOptions": [],
          "wrapperOptions": [],
          "showFps": false,
          "useGameMode": true,
          "wineCrossoverBottle": "Heroic",
          "winePrefix": "${config.xdg.userDirs.extraConfig.GAMES}/Heroic/Prefixes/default",
          "wineVersion": {
            "bin": "${config.home.homeDirectory}.config/heroic/tools/wine/Wine-GE-latest/bin/wine",
            "name": "Wine-GE-latest",
            "type": "wine",
            "lib": "${config.home.homeDirectory}/.config/heroic/tools/wine/Wine-GE-latest/lib64",
            "lib32": "${config.home.homeDirectory}/.config/heroic/tools/wine/Wine-GE-latest/lib",
            "wineserver": "${config.home.homeDirectory}/.config/heroic/tools/wine/Wine-GE-latest/bin/wineserver"
          },
          "enableEsync": true,
          "enableFsync": true,
          "enableMsync": false,
          "enableWineWayland": false,
          "enableHDR": false,
          "enableWoW64": false,
          "eacRuntime": false,
          "battlEyeRuntime": false,
          "framelessWindow": false,
          "beforeLaunchScriptPath": "",
          "afterLaunchScriptPath": "",
          "disableUMU": false,
          "verboseLogs": false,
          "downloadProtonToSteam": false,
          "advertiseAvxForRosetta": false,
          "noTrayIcon": false,
          "showValveProton": true,
          "gamescope": {
            "enableUpscaling": false,
            "enableLimiter": false,
            "windowType": "fullscreen",
            "gameWidth": "",
            "gameHeight": "",
            "upscaleHeight": "",
            "upscaleWidth": "",
            "upscaleMethod": "fsr",
            "fpsLimiter": "",
            "fpsLimiterNoFocus": "",
            "additionalOptions": ""
          },
          "showMangohud": false,
          "experimentalFeatures": {
            "enableNewDesign": false,
            "enableHelp": false,
            "automaticWinetricksFixes": true
          },
          "customThemesPath": "${config.home.homeDirectory}/.config/heroic/themes",
          "downloadNoHttps": true,
          "exitToTray": false,
          "allowInstallationBrokenAnticheat": true
        },
        "version": "v0"
      }
    ''; */
  };
}
