{ config, lib, pkgs, ... }:

{
  nixos.base.tools.syncthing.enable = lib.mkDefault true;

  nixos.desktop = {
    desktopEnvironment = {
      plasma6.enable = lib.mkDefault true;
    };
    displayManager = {
      defaultSession = "plasma";
      sddm.enable = lib.mkDefault true;
    };
    windowManager = {
      hyprland.enable = lib.mkDefault true;
    };
  };

  nixos.hardware = {
    amdcpu.enable = true;
    amdgpu.enable = true;
  };

  nixos.system.powermanagement.profiles.powersave = lib.mkDefault true;

  nixos.system.user.defaultuser = {
    name = "jf";
    pass = "$y$j9T$VLRm4nCKGD/ww64EwANZr0$Jrfk/VugVr/U7LP82BGFD.wlKOqwDAatzcZCAOOSRs2";
  };

  nixos.userEnvironment.enable = lib.mkDefault true;
}