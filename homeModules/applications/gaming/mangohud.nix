{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.gaming.mangohud = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable mangohud.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.gaming.mangohud.enable {
    programs.mangohud = {
      enable = true;
      enableSessionWide = false;
      settings = {
        # help

        # fps_limit=0

        # vsync=-1

        # gl_vsync=-2

        # picmip=-17

        # af=-1

        # bicubic

        # trilinear

        # retro

        # legacy_layout=0

        # -1 = default
        #  0 = no display
        #  1 = fps only
        #  2 = horizontal view
        #  3 = extended
        #  4 = high detailed information
        # preset=-1

        # full

        # fps_only

        # time
        # time_no_label

        # time_format="%T"

        # version

        gpu_stats = true;
        # gpu_temp
        # gpu_junction_temp
        # gpu_core_clock
        # gpu_mem_temp
        # gpu_mem_clock
        # gpu_power
        # gpu_load_change
        # gpu_load_value=60,90
        # gpu_load_color=39F900,FDFD09,B22222
        # gpu_fan
        # gpu_voltage

        cpu_stats = true;
        # cpu_temp
        # cpu_power
        # cpu_mhz
        # cpu_load_change
        # cpu_load_value=60,90
        # cpu_load_color=39F900,FDFD09,B22222

        # core_load
        # core_load_change

        # io_read
        # io_write

        vram = true;
        ram = true;
        # swap

        # procmem
        # procmem_shared
        # procmem_virt

        # battery
        # battery_icon
        # device_battery=gamepad,mouse
        # device_battery_icon
        # battery_watt
        # battery_time

        fps = true;
        # fps_sampling_period=500
        # fps_color_change
        # fps_value=30,60
        # fps_color=B22222,FDFD09,39F900
        frametime = true;
        # frame_count
        fps_metrics = [
          "avg"
          "0.01"
        ];

        throttling_status = true;
        #throttling_status_graph

        # engine_version
        # engine_short_names
        # gpu_name
        # vulkan_driver
        # wine
        # exec_name
        # winesync

        # arch

        frame_timing = true;
        # histogram

        # gamemode
        # vkbasalt

        fsr = true;
        # hide_fsr_sharpness
        # debug
        hdr = true;
        # refresh_rate

        # mangoapp_steam

        # fan

        # show_fps_limit

        # resolution

        # media_player
        # media_player_format=title,artist,album

        # network
        # network=eth0,wlo1

        # font_size=24
        # font_scale=1.0
        # font_size_text=24
        # font_scale_media_player=0.55
        # no_small_font

        # font_glyph_ranges=korean,chinese,chinese_simplified,japanese,cyrillic,thai,vietnamese,latin_ext_a,latin_ext_b

        text_outline = true;
        # text_outline_color = 000000
        # text_outline_thickness = 1.5

        position = "top-left";

        # round_corners=0

        # hud_no_margin

        # hud_compact

        # horizontal
        # horizontal_stretch

        # no_display

        # offset_x=0
        # offset_y=0

        # width=0
        # height=140
        # table_columns=3
        # cellpadding_y=-0.085

        # background_alpha=0.5
        # alpha=1.0

        # fcat
        # fcat_overlay_width=24
        # fcat_screen_edge=0

        # text_color=FFFFFF
        # gpu_color=2E9762
        # cpu_color=2E97CB
        # vram_color=AD64C1
        # ram_color=C26693
        # engine_color=EB5B5B
        # io_color=A491D3
        # frametime_color=00FF00
        # background_color=020202
        # media_player_color=FFFFFF
        # wine_color=EB5B5B
        # battery_color=FF9078

        # pci_dev=0:0a:0.0

        # control = -1

        # gl_size_query=viewport

        # gl_bind_framebuffer=0

        # gl_dont_flip=1

        # toggle_hud=Shift_R+F12
        # toggle_hud_position=Shift_R+F11
        # toggle_fps_limit=Shift_L+F1
        # toggle_logging=Shift_L+F2
        # reload_cfg=Shift_L+F4
        # upload_log=Shift_L+F3

        # log_interval=0
        # output_folder=/home/<USERNAME>/mangologs
        # permit_upload=0
        # benchmark_percentiles=97,AVG
        # log_versioning
        # upload_logs
      };
    };
  };
}
