{ config, lib, pkgs, ... }:

{
  nixos.desktop = {
    desktopEnvironment = {
      plasma6.enable = lib.mkForce true;
    };
    displayManager = {
      defaultSession = "plasma";
      sddm.enable = lib.mkForce true;
    };
    #windowManager = {
    #  hyprland.enable = lib.mkForce true;
    #};
  };

  nixos.theme.catppuccin = {
    accent = "Mauve";
    flavor = "Mocha";
  };

  nixos.hardware = {
    intelcpu.enable = true;
    #intelgpu.enable = true;
  };

  nixos.system.powermanagement.profiles.powersave = lib.mkForce true;

  nixos.system.user.defaultuser = {
    name = "jf";
    pass = "$y$j9T$VLRm4nCKGD/ww64EwANZr0$Jrfk/VugVr/U7LP82BGFD.wlKOqwDAatzcZCAOOSRs2";
  };

  nixos.userEnvironment.enable = lib.mkForce true;
}