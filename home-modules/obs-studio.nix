{ config, pkgs, ... }:

{
  programs.obs-studio = {
    enable = true;
    #plugins = with pkgs.obs-studio-plugins; [
    #  advanced-scene-switcher
    #  droidcam-obs
    #  input-overlay
    #  looking-glass-obs
    #  wlrobs
    #  waveform
    #  obs-3d-effect
    #  obs-gstreamer
    #  obs-scale-to-sound
    #  obs-teleport
    #  obs-vintage-filter
    #  input-overlay
    #  obs-multi-rtmp
    #  obs-source-clone
     # obs-backgroundremoval
    #  obs-pipewire-audio-capture
    #];
  };
}
