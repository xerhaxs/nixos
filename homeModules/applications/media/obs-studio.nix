{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

{
  options.homeManager = {
    applications.media.obs-studio = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable OBS Studio with Plugins.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.media.obs-studio.enable {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        #advanced-scene-switcher
        #droidcam-obs
        input-overlay
        #looking-glass-obs
        obs-3d-effect
        obs-backgroundremoval
        obs-gstreamer
        #obs-multi-rtmp
        obs-pipewire-audio-capture
        obs-scale-to-sound
        obs-source-clone
        obs-teleport
        obs-vintage-filter
        waveform
        wlrobs
      ];
    };

    xdg.configFile."obs-studio/global.ini".text = ''
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
      CurrentTheme3=Catppuccin ${osConfig.nixos.theme.catppuccin.flavor}

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
  };
}
