{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    openai-whisper
    upscayl
  ];
}