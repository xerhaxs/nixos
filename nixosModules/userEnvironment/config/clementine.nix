{ config, lib, pkgs, ... }:

let
  homeDir = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.home.homeDirectory}";
  configDir = "${homeDir}/.config/Clementine";
  configFile = "${configDir}/Clementine.conf";
  configContent = ''
    [General]
    hidden=true

    [Analyzer]
    framerate=25
    type=BlockAnalyzer

    [Appearance]
    b_hide_filter_toolbar=false
    b_use_sys_icons=true
    use-custom-set=false
    
    [Equalizer]
    enabled=false

    [GlobalSearch]
    enabled_classicalradio=false
    enabled_di=false
    enabled_icecast=false
    enabled_intergalacticfm=false
    enabled_jamendo=false
    enabled_jazzradio=false
    enabled_library=true
    enabled_magnatune=false
    enabled_radiobrowser=false
    enabled_radiotunes=false
    enabled_rockradio=false
    enabled_savedradio=false
    enabled_somafm=false
    enabled_subsonic=false
    group_by1=1
    group_by2=2
    group_by3=0
    provider_order=library, Box, Seafile, classicalradio, di, dropbox, google_drive, icecast, intergalacticfm, jamendo, jazzradio, magnatune, radiobrowser, radiotunes, rockradio, savedradio, skydrive, somafm, subsonic
    show_providers=true
    show_suggestions=true

    [GstEngine]
    bufferduration=4000
    bufferminfill=33
    device=
    format=
    monoplayback=false
    rgcompression=true
    rgenabled=false
    rgmode=0
    rgpreamp=@Variant(\0\0\0\x87\0\0\0\0)
    samplerate=-1
    sink=autoaudiosink

    [LibraryBackend]
    save_ratings_in_file=true
    save_statistics_in_file=true

    [LibraryConfig]
    last_path=

    [LibraryView]
    auto_open=true
    pretty_covers=true
    show_dividers=true

    [LibraryWatcher]
    cover_art_patterns=front, cover
    monitor=true
    skip_file_extensions=@Invalid()
    startup_scan=true

    [MainWindow]
    current_tab=1
    doubleclick_addmode=1
    doubleclick_playlist_addmode=2
    doubleclick_playmode=2
    file_path=/home/jf
    geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\0\0\0\0\0\0\0\0\aw\0\0\x5\xee\0\0\0\0\0\0\0\0\0\0\aw\0\0\x5\xee\0\0\0\0\0\0\0\0\xf\0\0\0\0\0\0\0\0\0\0\0\aw\0\0\x5\xee)
    group_by1=7
    group_by2=2
    group_by3=0
    hidden=false
    keeprunning=false
    maximized=true
    menu_playmode=2
    playback_position=125
    playback_state=3
    resume_playback_after_start=true
    scrolltrayicon=true
    show_sidebar=true
    showtray=false
    splitter_state=@ByteArray(\0\0\0\xff\0\0\0\x1\0\0\0\x2\0\0\x2\xec\0\0\f\x13\0\xff\xff\xff\xff\x1\0\0\0\x1\0)
    startupbehaviour=1
    tab_index_0=0
    tab_index_1=1
    tab_index_2=2
    tab_index_3=3
    tab_index_4=4
    tab_index_5=5
    tab_index_6=6
    tab_index_7=7
    tab_index_8=8
    tab_mode=1

    [Moodbar]
    calculate=true
    save_alongside_originals=false
    show=true
    style=4

    [NetworkRemote]
    allow_downloads=false
    auth_code=62493
    convert_lossless=false
    files_music_extensions=aac, alac, flac, m3u, m4a, mp3, ogg, wav, wmv
    files_root_folder=
    last_output_format=audio/x-vorbis
    only_non_public_ip=true
    port=5500
    use_auth_code=false
    use_remote=false

    [OSD]
    Behaviour=0
    CustomText1=
    CustomText2=
    CustomTextEnabled=false
    ShowArt=true
    ShowOnPausePlayback=true
    ShowOnPlayModeChange=true
    ShowOnVolumeChange=false
    Timeout=5000

    [Player]
    AutoCrossfadeEnabled=false
    CrossfadeEnabled=true
    FadeoutDuration=2000
    FadeoutEnabled=true
    FadeoutPauseDuration=250
    FadeoutPauseEnabled=false
    NoCrossfadeSameAlbum=true
    max_numprocs_tagclients=24
    menu_previousmode=2
    play_count_short_duration=false
    seek_step_sec=10
    stop_play_if_fail=true
    volume=100

    PlaylistTabBar]
    warn_close_playlist=true

    [SongInfo]
    font_size=8.5
    search_order=lyrics.wikia.com, lyricstime.com, lyricsreg.com, lyricsmania.com, metrolyrics.com, azlyrics.com, songlyrics.com, elyrics.net, lyricsdownload.com, lyrics.com, lyricsbay.com, directlyrics.com, loudson.gs, teksty.org, darklyrics.com

    [SongMetadata]
    guess_metadata=true

    [Subsonic]
    group_by1=7
    group_by2=2
    group_by3=0

    [Transcoder]
    fdkaacenc\bitrate=0
    flacenc\quality=5
    flacenc\streamable-subset=true
    lamemp3enc\bitrate=128
    lamemp3enc\cbr=true
    lamemp3enc\encoding-engine-quality=1
    lamemp3enc\mono=false
    lamemp3enc\quality=4
    lamemp3enc\target=1
    opusenc\bitrate=128000
    speexenc\abr=0
    speexenc\bitrate=0
    speexenc\complexity=3
    speexenc\dtx=false
    speexenc\mode=0
    speexenc\nframes=1
    speexenc\quality=8
    speexenc\vad=false
    speexenc\vbr=false
    vorbisenc\bitrate=-1
    vorbisenc\managed=false
    vorbisenc\max-bitrate=-1
    vorbisenc\min-bitrate=-1
    vorbisenc\quality=0.3

    [WiimotedevActions]
    1=9
    128=1
    16=6
    16384=2
    2=13
    256=2
    32=5
    4=0
    8192=1

    [WiimotedevSettings]
    device=1
    enabled=false
    first_conf=false
    only_when_focused=false
    use_active_action=true
    use_notification=true
  '';
in

{
  options.nixos = {
    userEnvironment.config.clementine = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable clementine config.";
      };
    };
  };

  config = lib.mkIf (config.nixos.userEnvironment.config.clementine.enable) {
    systemd.services.clementineConfigChecker = {
      description = "Check and create Clementine config if not present";

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
