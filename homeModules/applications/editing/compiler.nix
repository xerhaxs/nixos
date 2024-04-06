{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.editing.compiler = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable Media compiler tools.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.editing.compiler.enable {
    home.packages = with pkgs; [
      gst_all_1.gst-libav
      handbrake
      ffmpeg
    ];
  };
}