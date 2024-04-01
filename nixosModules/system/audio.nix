{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    nixos.system.audio = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable audio support";
      };
    };
    sound.mediaKeys.enable = {
      default = true;
      example = false;
      disableIf = [
        { option = "services.xserver.desktopManager.cinnamon.enable"; value = true; }
        { option = "services.xserver.desktopManager.gnome.enable"; value = true; }
        { option = "services.xserver.desktopManager.plasma5.bigscreen.enable"; value = true; }
        { option = "services.xserver.desktopManager.plasma5.enable"; value = true; }
        { option = "services.desktopManager.plasma6.enable"; value = true; }
        { option = "services.xserver.desktopManager.xfce.enable"; value = true; }
      ];
      description = "Disable mediaKeys if a desktop environment is installed.";
    };
  };

  config = mkIf config.nixos.system.audio.enable {
    sound = {
      enable = true;
      mediaKeys.volumeStep = "1";
      enableOSSEmulation = true;
    };
    
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
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
