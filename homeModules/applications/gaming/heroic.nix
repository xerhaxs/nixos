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

    home.activation.heroicConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      CONFIG="${config.xdg.configHome}/heroic/config.json"
      if [ -f "$CONFIG" ]; then
        ${pkgs.jq}/bin/jq '
          .defaultSettings.analyticsOptIn                = false |
          .defaultSettings.checkUpdatesInterval          = 10    |
          .defaultSettings.enableUpdates                 = false |
          .defaultSettings.addDesktopShortcuts           = false |
          .defaultSettings.addStartMenuShortcuts         = false |
          .defaultSettings.autoInstallDxvk               = true  |
          .defaultSettings.autoInstallVkd3d              = true  |
          .defaultSettings.autoInstallDxvkNvapi          = true  |
          .defaultSettings.addSteamShortcuts             = false |
          .defaultSettings.preferSystemLibs              = false |
          .defaultSettings.checkForUpdatesOnStartup      = false |
          .defaultSettings.autoUpdateGames               = false |
          .defaultSettings.defaultInstallPath            = "${config.xdg.userDirs.extraConfig.GAMES}/Heroic" |
          .defaultSettings.libraryTopSection             = "recently_played" |
          .defaultSettings.defaultSteamPath              = "${config.xdg.userDirs.extraConfig.GAMES}/Steam" |
          .defaultSettings.defaultWinePrefix             = "${config.xdg.userDirs.extraConfig.GAMES}/Heroic/Wine" |
          .defaultSettings.hideChangelogsOnStartup       = false |
          .defaultSettings.language                      = "de"  |
          .defaultSettings.maxWorkers                    = 0     |
          .defaultSettings.minimizeOnLaunch              = false |
          .defaultSettings.nvidiaPrime                   = false |
          .defaultSettings.showFps                       = false |
          .defaultSettings.useGameMode                   = true  |
          .defaultSettings.wineCrossoverBottle           = "Heroic" |
          .defaultSettings.winePrefix                    = "${config.xdg.userDirs.extraConfig.GAMES}/Heroic/Prefixes/default" |
          .defaultSettings.wineVersion.bin               = "${config.home.homeDirectory}/.config/heroic/tools/wine/Wine-GE-latest/bin/wine" |
          .defaultSettings.wineVersion.name              = "Wine-GE-latest" |
          .defaultSettings.wineVersion.type              = "wine" |
          .defaultSettings.wineVersion.lib               = "${config.home.homeDirectory}/.config/heroic/tools/wine/Wine-GE-latest/lib64" |
          .defaultSettings.wineVersion.lib32             = "${config.home.homeDirectory}/.config/heroic/tools/wine/Wine-GE-latest/lib" |
          .defaultSettings.wineVersion.wineserver        = "${config.home.homeDirectory}/.config/heroic/tools/wine/Wine-GE-latest/bin/wineserver" |
          .defaultSettings.enableEsync                   = true  |
          .defaultSettings.enableFsync                   = true  |
          .defaultSettings.enableMsync                   = false |
          .defaultSettings.enableWineWayland             = false |
          .defaultSettings.enableHDR                     = false |
          .defaultSettings.enableWoW64                   = false |
          .defaultSettings.eacRuntime                    = false |
          .defaultSettings.battlEyeRuntime               = false |
          .defaultSettings.framelessWindow               = false |
          .defaultSettings.disableUMU                    = false |
          .defaultSettings.verboseLogs                   = false |
          .defaultSettings.downloadProtonToSteam         = false |
          .defaultSettings.noTrayIcon                    = false |
          .defaultSettings.showValveProton               = true  |
          .defaultSettings.gamescope.enableUpscaling     = false |
          .defaultSettings.gamescope.enableLimiter       = false |
          .defaultSettings.gamescope.windowType          = "fullscreen" |
          .defaultSettings.gamescope.upscaleMethod       = "fsr" |
          .defaultSettings.showMangohud                  = false |
          .defaultSettings.experimentalFeatures.automaticWinetricksFixes = true  |
          .defaultSettings.experimentalFeatures.enableNewDesign          = false |
          .defaultSettings.experimentalFeatures.enableHelp               = false |
          .defaultSettings.customThemesPath              = "${config.home.homeDirectory}/.config/heroic/themes" |
          .defaultSettings.downloadNoHttps               = true  |
          .defaultSettings.exitToTray                    = false |
          .defaultSettings.allowInstallationBrokenAnticheat = true
        ' "$CONFIG" > "$CONFIG.tmp" && mv "$CONFIG.tmp" "$CONFIG"
      fi
    '';
  };
}
