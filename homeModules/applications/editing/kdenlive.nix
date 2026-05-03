{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

{
  options.homeManager = {
    applications.editing.kdenlive = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable kdenlive";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.editing.kdenlive.enable {
    home.packages = with pkgs; [
      kdePackages.kdenlive
      glaxnimate
    ];

    programs.plasma.configFile."kdenliverc" = {
      "Media Browser" = {
        "Allow Expansion".value = false;
        "Decoration position".value = 2;
        "Show Inline Previews".value = true;
        "Show hidden files".value = false;
        "Sort by".value = "Name";
        "Sort directories first".value = true;
        "Sort hidden files last".value = false;
        "Sort reversed".value = false;
        "View Style".value = "DetailTree";
      };

      "OnlineResources" = {
        "provider".value = "Freesound";
        "zoom".value = 7;
      };

      "Recent Profiles" = {
        "recentProfileNames".value = "HD 1080p 25 fps";
        "recentProfiles".value = "atsc_1080p_25";
      };

      "RenderWidget" = {
        "showoptions".value = false;
      };

      "Scope_Histogram" = {
        "autoRefresh".value = true;
        "bEnabled".value = true;
        "gEnabled".value = true;
        "logScale".value = false;
        "rEnabled".value = true;
        "realtime".value = false;
        "rec601".value = false;
        "sEnabled".value = false;
        "yEnabled".value = true;
      };

      "Scope_RGB Parade" = {
        "autoRefresh".value = true;
        "axis".value = false;
        "gradref".value = false;
        "paintmode".value = 0;
        "realtime".value = false;
      };

      "Scope_Vectorscope" = {
        "75PBox".value = false;
        "autoRefresh".value = true;
        "axis".value = false;
        "backgroundmode".value = 0;
        "colorspace_ypbpr".value = false;
        "gain".value = 1;
        "iqlines".value = false;
        "paintmode".value = 0;
        "realtime".value = false;
      };

      "Scope_Waveform" = {
        "autoRefresh".value = true;
        "paintmode".value = 0;
        "realtime".value = false;
        "rec601".value = false;
      };

      "UiSettings" = {
        "ColorScheme".value = "BreezeDark";
        "ColorSchemePath".value = "BreezeDark.colors";
      };

      "sdl" = {
        "preferredcomposite".value = "qtblend";
      };

      "timeline" = {
        "trackheight".value = 67;
      };

      "unmanaged" = {
        "default_profile".value = "atsc_1080p_25";
        "defaultrescaleheight".value = 540;
        "defaultrescalewidth".value = 810;
        "guidesCategories".value =
          "Category 1:0:#9b59b6,Category 2:1:#3daee9,Category 3:2:#1abc9c,Category 4:3:#1cdc9a,Category 5:4:#c9ce3b,Category 6:5:#fdbc4b,Category 7:6:#f39c1f,Category 8:7:#f47750,Category 9:8:#da4453";
      };

      "capture" = {
        "decklink_extension".value = "mov";
        "decklink_parameters".value = "vcodec=dnxhd vb=145000k acodec=pcm_s16le threads=%threads";
        "grab_extension".value = "mov";
        "grab_parameters".value = "-crf 25 -vcodec libx264 -preset veryfast -threads 0";
        "v4l_extension".value = "mpg";
        "v4l_parameters".value = "qscale=4 ab=192k vcodec=mpeg2video acodec=mp2 threads=%threads";
      };

      "startup" = {
        "lastSeenVersionMajor".value = 25;
        "lastSeenVersionMicro".value = 3;
        "lastSeenVersionMinor".value = 12;
      };
    };

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".local/share/kdenlive"
      ];
    };
  };
}
