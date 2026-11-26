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
        gpu_stats = true;
        cpu_stats = true;
        vram = true;
        ram = true;
        fps = true;
        frametime = true;
        fps_metrics = [
          "avg"
          "0.01"
        ];
        throttling_status = true;
        frame_timing = true;
        fsr = true;
        hdr = true;
        text_outline = true;
        position = "top-left";
      };
    };
  };
}
