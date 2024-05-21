{ config, lib, pkgs, ... }:

let
  user = "${config.nixos.system.user.defaultuser.name}";
  homeDir = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.home.homeDirectory}";
  configDir = "${homeDir}/.config/heroic";
  configFile = "${configDir}/config.json";
  flavor = lib.strings.toLower "${config.nixos.theme.catppuccin.flavor}";
  configContent = ''
    {
      "defaultSettings": {
        "checkUpdatesInterval": 10,
        "enableUpdates": false,
        "addDesktopShortcuts": false,
        "addStartMenuShortcuts": false,
        "autoInstallDxvk": true,
        "autoInstallVkd3d": true,
        "autoInstallDxvkNvapi": true,
        "addSteamShortcuts": false,
        "preferSystemLibs": false,
        "checkForUpdatesOnStartup": true,
        "autoUpdateGames": true,
        "customWinePaths": [],
        "defaultInstallPath": "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.extraConfig.XDG_GAMES_DIR}/Heroic",
        "libraryTopSection": "disabled",
        "defaultSteamPath": "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.extraConfig.XDG_GAMES_DIR}/Steam",
        "defaultWinePrefix": "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.xdg.userDirs.extraConfig.XDG_GAMES_DIR}/Heroic/Wine",
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
        "winePrefix": "${homeDir}/Games/Heroic/Prefixes/default",
        "wineVersion": {
          "bin": "${homeDir}/.config/heroic/tools/wine/Wine-GE-latest/bin/wine",
          "name": "Wine - Wine-GE-latest",
          "type": "wine",
          "lib": "${homeDir}/.config/heroic/tools/wine/Wine-GE-latest/lib64",
          "lib32": "${homeDir}/.config/heroic/tools/wine/Wine-GE-latest/lib",
          "wineserver": "${homeDir}/.config/heroic/tools/wine/Wine-GE-latest/bin/wineserver"
        },
        "enableEsync": true,
        "enableFsync": true,
        "enableMsync": false,
        "eacRuntime": true,
        "battlEyeRuntime": true,
        "framelessWindow": false,
        "beforeLaunchScriptPath": "",
        "afterLaunchScriptPath": "",
        "gamescope": {
          "enableUpscaling": false,
          "enableLimiter": true,
          "windowType": "fullscreen",
          "gameWidth": "",
          "gameHeight": "",
          "upscaleHeight": "",
          "upscaleWidth": "",
          "upscaleMethod": "fsr",
          "fpsLimiter": "144",
          "fpsLimiterNoFocus": "60",
          "additionalOptions": "--hdr-enabled"
        },
        "showMangohud": false,
        "experimentalFeatures": {
          "enableNewDesign": false,
          "enableHelp": false,
          "automaticWinetricksFixes": true
        },
        "customThemesPath": "${homeDir}/.config/heroic/themes"
      },
      "theme": "catppuccin-${flavor}.css",
      "version": "v0"
    }
  '';
in

{
  options.nixos = {
    userEnvironment.heroic = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable heroic options.";
      };
    };
  };

  config = lib.mkIf (config.nixos.userEnvironment.heroic.enable && config.home-manager.users.${config.nixos.system.user.defaultuser.name}.homeManager.applications.gaming.heroic.enable) {
    systemd.user.services.heroicConfigChecker = {
      description = "Check and create Heroic config if not present";

      serviceConfig = {
        ExecStart = ''
          if [ ! -d "${configDir}" ]; then
            mkdir -p "${configDir}"
          fi

          if [ ! -f "${configFile}" ]; then
            echo '${configContent}' > "${configFile}"
          fi
        '';
        Type = "oneshot";
      };

      wantedBy = [ "default.target" ];
    };
  };
}
