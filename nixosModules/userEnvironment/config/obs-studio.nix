{ config, lib, pkgs, ... }:

let
  homeDir = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.home.homeDirectory}";
  configDir = "${homeDir}/.config/obs-studio";
  configFile = "${configDir}/global.ini";
  configContent = ''
    [General]
    Pre19Defaults=false
    Pre21Defaults=false
    Pre23Defaults=false
    Pre24.1Defaults=false
    MaxLogs=10
    InfoIncrement=-1
    ProcessPriority=Normal
    EnableAutoUpdates=true
    ConfirmOnExit=true
    HotkeyFocusType=NeverDisableHotkeys
    FirstRun=true
    CurrentTheme3=Catppuccin ${config.nixos.theme.catppuccin.flavor}

    [Video]
    Renderer=OpenGL

    [BasicWindow]
    PreviewEnabled=true
    PreviewProgramMode=true
    SceneDuplicationMode=true
    SwapScenesMode=true
    SnappingEnabled=true
    ScreenSnapping=true
    SourceSnapping=true
    CenterSnapping=true
    SnapDistance=10
    SpacingHelpersEnabled=true
    RecordWhenStreaming=true
    KeepRecordingWhenStreamStops=true
    SysTrayEnabled=true
    SysTrayWhenStarted=false
    SaveProjectors=true
    ShowTransitions=true
    ShowListboxToolbars=true
    ShowStatusBar=true
    ShowSourceIcons=true
    ShowContextToolbars=true
    StudioModeLabels=true
    VerticalVolControl=false
    MultiviewMouseSwitch=true
    MultiviewDrawNames=true
    MultiviewDrawAreas=true
    MediaControlsCountdownTimer=true
    WarnBeforeStartingStream=true
    WarnBeforeStoppingStream=true
    WarnBeforeStoppingRecord=false
    AlwaysOnTop=false
    EditPropertiesMode=false
    DocksLocked=false
    SideDocks=false

    [Basic]
    Profile=Untitled
    ProfileDir=Untitled
    SceneCollection=Untitled
    SceneCollectionFile=Untitled
    ConfigOnNewProfile=true
  '';
in

{
  options.nixos = {
    userEnvironment.config.obs-studio = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable obs-studio config.";
      };
    };
  };

  config = lib.mkIf (config.nixos.userEnvironment.config.obs-studio.enable && config.home-manager.users.${config.nixos.system.user.defaultuser.name}.homeManager.applications.media.obs-studio.enable) {
    boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    
    boot.extraModprobeConfig = ''
      options devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1 4l2loopback
    '';

    systemd.services.obs-studioConfigChecker = {
      description = "Check and create obs-studio config if not present";

      script = ''
        if [ ! -d "${configDir}" ]; then
          mkdir -p "${configDir}"
        fi

        if [ ! -f "${configFile}" ]; then
          echo '${configContent}' > "${configFile}"
        fi

        chown -R ${config.nixos.system.user.defaultuser.name}:users ${configDir}
      '';

      wantedBy = [ "multi-user.target" ];
    };
  };
}
