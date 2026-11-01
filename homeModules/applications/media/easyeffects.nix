{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.media.easyeffects = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable easyeffects";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.media.easyeffects.enable {
    home.packages = with pkgs; [
      crosspipe
    ];

    # Microphone chain: DeepFilterNet noise reduction (RNNoise kept as bypassed alternative), soft gate,
    # EQ (high-pass 80 Hz, presence), compressor 3:1, de-esser, limiter -1.5 dB.
    # Based on https://gist.github.com/jtrv/47542c8be6345951802eebcf9dc7da31, tune per microphone.
    services.easyeffects = {
      enable = true;
      preset.input = "microphone";
      extraPresets.microphone.input = lib.importJSON ./easyeffects-microphone.json;
    };

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/easyeffects"
        ".local/share/easyeffects"
      ];
    };
  };
}
