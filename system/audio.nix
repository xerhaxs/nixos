{ config, pkgs, ... }:

{
  sound = {
    enable = true;
    #mediaKeys.enable = true # only on WM - disable for DEs
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
    easyeffects
    helvum
    pulseaudio
    alsa-plugins
    alsa-utils
    alsa-tools
    alsa-lib
    dcadec
    ocamlPackages.alsa
    fftw
    pavucontrol
  ];
}
