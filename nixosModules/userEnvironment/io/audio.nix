{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    userEnvironment.io.audio = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable audio support";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.io.audio.enable {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;

      extraConfig.pipewire-pulse = {
        "pulse.rules" = [
          {
            matches = [
              {
                "application.process.binary" = "wine64-preloader";
              }
            ];

            actions = {
              update-props = {
                pulse.min.quantum = "1024/48000";
              };
            };
          }
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      pulseaudio
      alsa-plugins
      alsa-utils
      alsa-tools
      alsa-lib
      fftw
    ];
  };
}
