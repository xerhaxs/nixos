{ config, lib, pkgs, ... }:

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
        input-overlay
        looking-glass-obs
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
  };
}
