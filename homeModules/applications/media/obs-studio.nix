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

    home.activation.obsConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            GLOBAL="$HOME/.config/obs-studio/global.ini"
            USER="$HOME/.config/obs-studio/user.ini"
            BASIC="$HOME/.config/obs-studio/basic/profiles/Untitled/basic.ini"

            if [ -f "$GLOBAL" ]; then
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" General   Pre19Defaults              false
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" General   Pre21Defaults              false
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" General   Pre23Defaults              false
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" General   "Pre24.1Defaults"          false
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" General   MaxLogs                    10
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" General   ProcessPriority            Normal
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" General   EnableAutoUpdates          true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" General   ConfirmOnExit              true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" General   HotkeyFocusType            NeverDisableHotkeys
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" General   CurrentTheme3              "Catppuccin ${osConfig.nixos.theme.catppuccin.flavor}"
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" General   BrowserHWAccel             true

              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" Video     Renderer                   OpenGL

              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow PreviewEnabled           true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow PreviewProgramMode       true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow SceneDuplicationMode     true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow SwapScenesMode           true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow SnappingEnabled          true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow ScreenSnapping           true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow SourceSnapping           true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow CenterSnapping           true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow SnapDistance             10
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow SpacingHelpersEnabled    true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow RecordWhenStreaming       true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow KeepRecordingWhenStreamStops true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow SysTrayEnabled           true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow SysTrayWhenStarted       false
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow SaveProjectors           true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow ShowTransitions          true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow ShowListboxToolbars      true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow ShowStatusBar            true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow ShowSourceIcons          true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow ShowContextToolbars      true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow StudioModeLabels         true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow VerticalVolControl       false
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow MultiviewMouseSwitch     true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow MultiviewDrawNames       true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow MultiviewDrawAreas       true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow MediaControlsCountdownTimer true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow WarnBeforeStartingStream true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow WarnBeforeStoppingStream true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow WarnBeforeStoppingRecord false
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow AlwaysOnTop              false
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow EditPropertiesMode       false
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow DocksLocked              false
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" BasicWindow SideDocks                false

              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" input-overlay iohook                 true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" input-overlay gamepad                true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" input-overlay overlay                true
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" input-overlay wss_address            0.0.0.0
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" input-overlay logging                false
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" input-overlay server_port            1608
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" input-overlay wss_port               16899
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" input-overlay enable_wss             false
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" input-overlay server_refresh_rate    250
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" input-overlay ds_enhanced_mode       false
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" input-overlay control                false
              ${pkgs.crudini}/bin/crudini --set "$GLOBAL" input-overlay regex                  false
            fi

            if [ -f "$USER" ]; then
              ${pkgs.crudini}/bin/crudini --set "$USER" General   Pre19Defaults                false
              ${pkgs.crudini}/bin/crudini --set "$USER" General   Pre21Defaults                false
              ${pkgs.crudini}/bin/crudini --set "$USER" General   Pre23Defaults                false
              ${pkgs.crudini}/bin/crudini --set "$USER" General   "Pre24.1Defaults"            false
              ${pkgs.crudini}/bin/crudini --set "$USER" General   MaxLogs                      10
              ${pkgs.crudini}/bin/crudini --set "$USER" General   ProcessPriority              Normal
              ${pkgs.crudini}/bin/crudini --set "$USER" General   EnableAutoUpdates            true
              ${pkgs.crudini}/bin/crudini --set "$USER" General   ConfirmOnExit                true
              ${pkgs.crudini}/bin/crudini --set "$USER" General   HotkeyFocusType              NeverDisableHotkeys
              ${pkgs.crudini}/bin/crudini --set "$USER" General   CurrentTheme3                "Catppuccin ${osConfig.nixos.theme.catppuccin.flavor}"

              ${pkgs.crudini}/bin/crudini --set "$USER" Video     Renderer                     OpenGL

              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow PreviewEnabled             true
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow PreviewProgramMode         true
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow SceneDuplicationMode       true
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow SwapScenesMode             true
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow SnappingEnabled            true
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow ScreenSnapping             true
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow SourceSnapping             true
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow CenterSnapping             false
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow SnapDistance               10
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow SpacingHelpersEnabled      true
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow RecordWhenStreaming         true
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow KeepRecordingWhenStreamStops true
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow SysTrayEnabled             true
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow SysTrayWhenStarted         false
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow SaveProjectors             true
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow ShowTransitions            true
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow ShowListboxToolbars        true
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow ShowStatusBar              true
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow ShowSourceIcons            true
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow ShowContextToolbars        true
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow StudioModeLabels           true
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow VerticalVolControl         false
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow MultiviewMouseSwitch       true
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow MultiviewDrawNames         true
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow MultiviewDrawAreas         true
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow MediaControlsCountdownTimer true
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow WarnBeforeStartingStream   true
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow WarnBeforeStoppingStream   true
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow WarnBeforeStoppingRecord   false
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow AlwaysOnTop                false
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow EditPropertiesMode         false
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow DocksLocked                false
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow SideDocks                  false
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow VerticalVolumeControl      false
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow MixerShowInactive          false
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow MixerKeepInactiveLast      false
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow MixerShowHidden            false
              ${pkgs.crudini}/bin/crudini --set "$USER" BasicWindow MixerKeepHiddenLast        false

              ${pkgs.crudini}/bin/crudini --set "$USER" Accessibility SelectRed                255
              ${pkgs.crudini}/bin/crudini --set "$USER" Accessibility SelectGreen              65280
              ${pkgs.crudini}/bin/crudini --set "$USER" Accessibility SelectBlue               16744192
              ${pkgs.crudini}/bin/crudini --set "$USER" Accessibility MixerGreen               2522918
              ${pkgs.crudini}/bin/crudini --set "$USER" Accessibility MixerYellow              2523007
              ${pkgs.crudini}/bin/crudini --set "$USER" Accessibility MixerRed                 2500223
              ${pkgs.crudini}/bin/crudini --set "$USER" Accessibility MixerGreenActive         5046092
              ${pkgs.crudini}/bin/crudini --set "$USER" Accessibility MixerYellowActive        5046271
              ${pkgs.crudini}/bin/crudini --set "$USER" Accessibility MixerRedActive           5000447

              ${pkgs.crudini}/bin/crudini --set "$USER" PropertiesWindow cx                    720
              ${pkgs.crudini}/bin/crudini --set "$USER" PropertiesWindow cy                    580

              ${pkgs.crudini}/bin/crudini --set "$USER" Appearance  FontScale                  10
              ${pkgs.crudini}/bin/crudini --set "$USER" Appearance  Density                    -4
              ${pkgs.crudini}/bin/crudini --set "$USER" Appearance  Theme                      "com.obsproject.Catppuccin.${osConfig.nixos.theme.catppuccin.flavor}"

              ${pkgs.crudini}/bin/crudini --set "$USER" input-overlay iohook                   true
              ${pkgs.crudini}/bin/crudini --set "$USER" input-overlay gamepad                  true
              ${pkgs.crudini}/bin/crudini --set "$USER" input-overlay overlay                  true
              ${pkgs.crudini}/bin/crudini --set "$USER" input-overlay wss_address              0.0.0.0
              ${pkgs.crudini}/bin/crudini --set "$USER" input-overlay logging                  false
              ${pkgs.crudini}/bin/crudini --set "$USER" input-overlay server_port              1608
              ${pkgs.crudini}/bin/crudini --set "$USER" input-overlay wss_port                 16899
              ${pkgs.crudini}/bin/crudini --set "$USER" input-overlay enable_wss               false
              ${pkgs.crudini}/bin/crudini --set "$USER" input-overlay server_refresh_rate      250
            fi

            mkdir -p "$(dirname "$BASIC")"
        if [ ! -f "$BASIC" ]; then
          cat > "$BASIC" << 'EOF'
      [General]
      Name=Untitled

      [Output]
      Mode=Advanced
      FilenameFormatting=%CCYY-%MM-%DD %hh-%mm-%ss
      DelayEnable=false
      DelaySec=20
      DelayPreserve=true
      Reconnect=true
      RetryDelay=2
      MaxRetries=25
      BindIP=default
      IPFamily=IPv4+IPv6
      NewSocketLoopEnable=false
      LowLatencyEnable=false

      [Stream1]
      IgnoreRecommended=false
      EnableMultitrackVideo=false
      MultitrackVideoMaximumAggregateBitrateAuto=true
      MultitrackVideoMaximumVideoTracksAuto=true

      [SimpleOutput]
      FilePath=${config.xdg.userDirs.desktop}
      RecFormat2=mkv
      VBitrate=6000
      ABitrate=160
      UseAdvanced=false
      Preset=veryfast
      NVENCPreset2=p5
      RecQuality=Stream
      RecRB=false
      RecRBTime=20
      RecRBSize=512
      RecRBPrefix=Replay
      StreamAudioEncoder=aac
      RecAudioEncoder=aac
      RecTracks=1
      StreamEncoder=x264
      RecEncoder=x264

      [AdvOut]
      ApplyServiceSettings=true
      UseRescale=false
      TrackIndex=1
      VodTrackIndex=2
      Encoder=obs_x264
      RecType=Standard
      RecFilePath=${config.xdg.userDirs.desktop}
      RecFormat2=mkv
      RecUseRescale=false
      RecTracks=1
      RecEncoder=none
      FLVTrack=1
      StreamMultiTrackAudioMixes=1
      FFOutputToFile=true
      FFFilePath=${config.xdg.userDirs.desktop}
      FFVBitrate=6000
      FFVGOPSize=250
      FFUseRescale=false
      FFIgnoreCompat=false
      FFABitrate=160
      FFAudioMixes=1
      Track1Bitrate=160
      Track2Bitrate=160
      Track3Bitrate=160
      Track4Bitrate=160
      Track5Bitrate=160
      Track6Bitrate=160
      RecSplitFileTime=15
      RecSplitFileSize=2048
      RecRB=false
      RecRBTime=20
      RecRBSize=512
      AudioEncoder=libfdk_aac
      RecAudioEncoder=libfdk_aac
      RecSplitFileType=Time
      FFFormat=
      FFFormatMimeType=
      FFVEncoderId=0
      FFVEncoder=
      FFAEncoderId=0
      FFAEncoder=
      RescaleRes=1920x1080
      RecRescaleRes=1920x1080
      FFRescaleRes=1920x1080

      [Video]
      BaseCX=3840
      BaseCY=1600
      OutputCX=3840
      OutputCY=1600
      FPSType=0
      FPSCommon=60
      FPSInt=30
      FPSNum=30
      FPSDen=1
      ScaleType=bicubic
      ColorFormat=NV12
      ColorSpace=709
      ColorRange=Partial
      SdrWhiteLevel=300
      HdrNominalPeakLevel=1000

      [Audio]
      MonitoringDeviceId=default
      MonitoringDeviceName=Default
      SampleRate=48000
      ChannelSetup=Stereo
      MeterDecayRate=23.53
      PeakMeterType=0

      [Panels]
      CookieId=364F22B9991B70C9
      EOF
        fi
    '';

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/obs-studio"
      ];
    };
  };
}
