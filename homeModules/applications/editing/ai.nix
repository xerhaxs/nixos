{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.editing.ai = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable AI tools.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.editing.ai.enable {
    home.packages = with pkgs; [
      openai-whisper
      upscayl
    ];
  };
}