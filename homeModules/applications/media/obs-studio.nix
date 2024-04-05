{ config, lib, pkgs, ... }:

{
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      advanced-scene-switcher
      droidcam-obs
      input-overlay
      input-overlay
      looking-glass-obs
      obs-3d-effect
      obs-backgroundremoval
      obs-gstreamer
      obs-multi-rtmp
      obs-pipewire-audio-capture
      obs-scale-to-sound
      obs-source-clone
      obs-teleport
      obs-vintage-filter
      waveform
      wlrobs
    ];
  };
}
