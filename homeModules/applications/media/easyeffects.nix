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

    # Chain for a Rode Procaster on input 1 of a Behringer UMC22 (docs/microphone.md): mono from the left
    # channel, DeepFilterNet against preamp noise, soft gate, EQ (high-pass 85 Hz, less 200 and 450 Hz,
    # a little presence), compressor 3:1, de-esser, limiter -1 dB.
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
