{
  config,
  lib,
  pkgs,
  userName,
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
    boot.kernelParams = [ "snd_hda_intel.snoop=1" ];

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber = {
        enable = true;
        extraConfig = {
          "denon-hdmi-fix" = {
            "node.rules" = [
              {
                matches = [
                  { "node.name" = "alsa_output.pci-0000_0b_00.1.hdmi-surround-extra3"; }
                ];
                actions = {
                  update-props = {
                    "audio.format" = "S32LE";
                    "audio.rate" = 48000;
                    "audio.channels" = 6;
                    "api.alsa.period-size" = 1024;
                    "api.alsa.buffer-size" = 8192;
                    "session.suspend-timeout-seconds" = 0;
                  };
                };
              }
            ];
          };
        };
      };

      extraConfig.pipewire = {
        "10-quantum" = {
          "context.properties" = {
            "default.clock.min-quantum" = 1024;
            "default.clock.quantum" = 2048;
            "default.clock.max-quantum" = 8192;
          };
        };
      };

      extraConfig.pipewire-pulse = {
        "10-wine-quantum" = {
          "pulse.rules" = [
            {
              matches = [
                { "application.process.binary" = "wine64-preloader"; }
                { "application.process.binary" = "wine-preloader"; }
              ];
              actions = {
                update-props = {
                  "pulse.min.quantum" = "1024/48000";
                  "pulse.max.quantum" = "8192/48000";
                };
              };
            }
          ];
        };
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

    users.users."${userName}" = {
      extraGroups = [
        "audio"
      ];
    };
  };
}
