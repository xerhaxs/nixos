{ config, lib, pkgs, ... }:


{
  options = {
    nixos.system.audio = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable audio support";
      };
    };
  };

  config = lib.mkIf config.nixos.system.audio.enable {
    #sound = {
    #  enable = true;
    #  mediaKeys.enable = lib.mkIf (
    #    config.nixos.desktop.desktopEnvironment.cinnamon.enable ||
    #    config.nixos.desktop.desktopEnvironment.gnome.enable ||
    #    config.nixos.desktop.desktopEnvironment.plasma5-bigscreen.enable ||
    #    config.nixos.desktop.desktopEnvironment.plasma5.enable ||
    #    config.nixos.desktop.desktopEnvironment.plasma6.enable ||
    #    config.nixos.desktop.desktopEnvironment.xfce.enable
    #  ) true;
    #  mediaKeys.volumeStep = "1";
    #  enableOSSEmulation = true;
    #};
    
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
