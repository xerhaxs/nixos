{
  config,
  inputs,
  lib,
  pkgs,
  osConfig,
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

    home.activation.heroicCatppuccinTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      THEME_DIR="${config.xdg.configHome}/heroic/themes"
      THEME_FILE="$THEME_DIR/catppuccin-${lib.strings.toLower osConfig.nixos.theme.catppuccin.flavor}-${lib.strings.toLower osConfig.nixos.theme.catppuccin.accent}.css"
      mkdir -p "$THEME_DIR"
      if [ ! -f "$THEME_FILE" ]; then
        cp "${inputs.catppuccin-heroic}/themes/catppuccin-${lib.strings.toLower osConfig.nixos.theme.catppuccin.flavor}-${lib.strings.toLower osConfig.nixos.theme.catppuccin.accent}.css" "$THEME_FILE"
      fi
    '';

    home.activation.heroicConfig = lib.hm.dag.entryAfter [ "writeBoundary" "heroicCatppuccinTheme" ] ''
      CONFIG="${config.xdg.configHome}/heroic/config.json"
      STORE="${config.xdg.configHome}/heroic/store/config.json"

      JQ_SETTINGS='
        .analyticsOptIn                = false |
        .checkUpdatesInterval          = 10    |
        .enableUpdates                 = false |
        .addDesktopShortcuts           = false |
        .addStartMenuShortcuts         = false |
        .autoInstallDxvk               = true  |
        .autoInstallVkd3d              = true  |
        .autoInstallDxvkNvapi          = true  |
        .addSteamShortcuts             = false |
        .preferSystemLibs              = false |
        .checkForUpdatesOnStartup      = false |
        .autoUpdateGames               = false |
        .defaultInstallPath            = "${config.xdg.userDirs.extraConfig.GAMES}/Heroic" |
        .libraryTopSection             = "recently_played" |
        .defaultSteamPath              = "${config.xdg.userDirs.extraConfig.GAMES}/Steam" |
        .defaultWinePrefix             = "${config.xdg.userDirs.extraConfig.GAMES}/Heroic/Wine" |
        .hideChangelogsOnStartup       = false |
        .language                      = "de"  |
        .maxWorkers                    = 0     |
        .minimizeOnLaunch              = false |
        .nvidiaPrime                   = false |
        .showFps                       = false |
        .useGameMode                   = true  |
        .wineCrossoverBottle           = "Heroic" |
        .winePrefix                    = "${config.xdg.userDirs.extraConfig.GAMES}/Heroic/Prefixes/default" |
        .wineVersion.bin               = "${config.home.homeDirectory}/.config/heroic/tools/wine/Wine-GE-latest/bin/wine" |
        .wineVersion.name              = "Wine-GE-latest" |
        .wineVersion.type              = "wine" |
        .wineVersion.lib               = "${config.home.homeDirectory}/.config/heroic/tools/wine/Wine-GE-latest/lib64" |
        .wineVersion.lib32             = "${config.home.homeDirectory}/.config/heroic/tools/wine/Wine-GE-latest/lib" |
        .wineVersion.wineserver        = "${config.home.homeDirectory}/.config/heroic/tools/wine/Wine-GE-latest/bin/wineserver" |
        .enableEsync                   = true  |
        .enableFsync                   = true  |
        .enableMsync                   = false |
        .enableWineWayland             = false |
        .enableHDR                     = false |
        .enableWoW64                   = false |
        .eacRuntime                    = false |
        .battlEyeRuntime               = false |
        .framelessWindow               = false |
        .disableUMU                    = false |
        .verboseLogs                   = false |
        .downloadProtonToSteam         = false |
        .noTrayIcon                    = false |
        .showValveProton               = true  |
        .gamescope.enableUpscaling     = false |
        .gamescope.enableLimiter       = false |
        .gamescope.windowType          = "fullscreen" |
        .gamescope.upscaleMethod       = "fsr" |
        .showMangohud                  = false |
        .experimentalFeatures.automaticWinetricksFixes = true  |
        .experimentalFeatures.enableNewDesign          = false |
        .experimentalFeatures.enableHelp               = false |
        .customThemesPath              = "${config.home.homeDirectory}/.config/heroic/themes" |
        .downloadNoHttps               = true  |
        .exitToTray                    = false |
        .allowInstallationBrokenAnticheat = true
      '

      THEME="catppuccin-${lib.strings.toLower osConfig.nixos.theme.catppuccin.flavor}-${lib.strings.toLower osConfig.nixos.theme.catppuccin.accent}.css"

      if [ -f "$CONFIG" ]; then
        ${pkgs.jq}/bin/jq ".defaultSettings |= ( . | $JQ_SETTINGS )" "$CONFIG" > "$CONFIG.tmp" && mv "$CONFIG.tmp" "$CONFIG"
      fi

      if [ -f "$STORE" ]; then
        ${pkgs.jq}/bin/jq ".settings |= ( . | $JQ_SETTINGS ) | .theme = \"$THEME\"" "$STORE" > "$STORE.tmp" && mv "$STORE.tmp" "$STORE"
      fi
    '';

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/heroic"
      ];
    };
  };
}
