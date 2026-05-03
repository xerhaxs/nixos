{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

{
  options.homeManager = {
    applications.media.clementine = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable clementine.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.media.clementine.enable {
    home.packages = with pkgs; [
      clementine
    ];

    home.activation.clementineConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      CONFIG="$HOME/.config/Clementine/Clementine.conf"
      if [ -f "$CONFIG" ]; then
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" General    hidden                        true
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" Analyzer   framerate                     25
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" Analyzer   type                          BlockAnalyzer
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" Appearance b_hide_filter_toolbar         false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" Appearance b_use_sys_icons               true
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" Appearance use-custom-set                false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" Equalizer  enabled                       false

        ${pkgs.crudini}/bin/crudini --set "$CONFIG" GlobalSearch enabled_classicalradio      false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" GlobalSearch enabled_di                  false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" GlobalSearch enabled_icecast             false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" GlobalSearch enabled_intergalacticfm     false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" GlobalSearch enabled_jamendo             false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" GlobalSearch enabled_jazzradio           false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" GlobalSearch enabled_library             true
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" GlobalSearch enabled_magnatune           false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" GlobalSearch enabled_radiobrowser        false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" GlobalSearch enabled_radiotunes          false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" GlobalSearch enabled_rockradio           false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" GlobalSearch enabled_savedradio          false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" GlobalSearch enabled_somafm              false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" GlobalSearch enabled_subsonic            false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" GlobalSearch group_by1                   1
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" GlobalSearch group_by2                   2
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" GlobalSearch group_by3                   0
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" GlobalSearch show_providers              true
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" GlobalSearch show_suggestions            true

        ${pkgs.crudini}/bin/crudini --set "$CONFIG" GstEngine   bufferduration              4000
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" GstEngine   bufferminfill               33
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" GstEngine   monoplayback                false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" GstEngine   rgcompression               true
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" GstEngine   rgenabled                   false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" GstEngine   rgmode                      0
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" GstEngine   samplerate                  -1
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" GstEngine   sink                        autoaudiosink

        ${pkgs.crudini}/bin/crudini --set "$CONFIG" LibraryBackend save_ratings_in_file     true
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" LibraryBackend save_statistics_in_file  true

        ${pkgs.crudini}/bin/crudini --set "$CONFIG" LibraryView auto_open                   true
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" LibraryView pretty_covers               true
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" LibraryView show_dividers               true

        ${pkgs.crudini}/bin/crudini --set "$CONFIG" LibraryWatcher cover_art_patterns       "front, cover"
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" LibraryWatcher monitor                  true
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" LibraryWatcher startup_scan             true

        ${pkgs.crudini}/bin/crudini --set "$CONFIG" MainWindow current_tab                  1
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" MainWindow doubleclick_addmode          1
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" MainWindow doubleclick_playlist_addmode 2
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" MainWindow doubleclick_playmode         2
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" MainWindow group_by1                    7
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" MainWindow group_by2                    2
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" MainWindow group_by3                    0
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" MainWindow hidden                       false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" MainWindow keeprunning                  false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" MainWindow maximized                    true
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" MainWindow menu_playmode                2
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" MainWindow resume_playback_after_start  true
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" MainWindow scrolltrayicon               true
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" MainWindow show_sidebar                 true
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" MainWindow showtray                     false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" MainWindow startupbehaviour             1
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" MainWindow tab_mode                     1

        ${pkgs.crudini}/bin/crudini --set "$CONFIG" Moodbar    calculate                    true
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" Moodbar    save_alongside_originals     false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" Moodbar    show                         true
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" Moodbar    style                        4

        ${pkgs.crudini}/bin/crudini --set "$CONFIG" NetworkRemote allow_downloads           false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" NetworkRemote only_non_public_ip        true
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" NetworkRemote port                      5500
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" NetworkRemote use_auth_code             false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" NetworkRemote use_remote                false

        ${pkgs.crudini}/bin/crudini --set "$CONFIG" OSD         Behaviour                   0
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" OSD         CustomTextEnabled           false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" OSD         ShowArt                     true
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" OSD         ShowOnPausePlayback         true
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" OSD         ShowOnPlayModeChange        true
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" OSD         ShowOnVolumeChange          false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" OSD         Timeout                     5000

        ${pkgs.crudini}/bin/crudini --set "$CONFIG" Player      AutoCrossfadeEnabled        false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" Player      CrossfadeEnabled            true
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" Player      FadeoutDuration             2000
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" Player      FadeoutEnabled              true
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" Player      FadeoutPauseDuration        250
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" Player      FadeoutPauseEnabled         false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" Player      NoCrossfadeSameAlbum        true
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" Player      menu_previousmode           2
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" Player      play_count_short_duration   false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" Player      seek_step_sec               10
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" Player      stop_play_if_fail           true
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" Player      volume                      100

        ${pkgs.crudini}/bin/crudini --set "$CONFIG" PlaylistTabBar warn_close_playlist      true

        ${pkgs.crudini}/bin/crudini --set "$CONFIG" SongMetadata guess_metadata             true

        ${pkgs.crudini}/bin/crudini --set "$CONFIG" WiimotedevSettings device              1
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" WiimotedevSettings enabled             false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" WiimotedevSettings first_conf          false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" WiimotedevSettings only_when_focused   false
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" WiimotedevSettings use_active_action   true
        ${pkgs.crudini}/bin/crudini --set "$CONFIG" WiimotedevSettings use_notification    true
      fi
    '';

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/Clementine"
      ];
      files = [
        ".config/Clementinerc"
      ];
    };
  };
}
