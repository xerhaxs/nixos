{ config, lib, pkgs, ... }:

{
  nixos.desktop = {
    desktopEnvironment = {
      plasma6.enable = lib.mkForce false;
    };
    displayManager = {
      defaultSession = "plasma";
      sddm.enable = lib.mkForce false;
    };
    windowManager = {
      hyprland.enable = lib.mkForce false;
    };
  };

  nixos.theme.catppuccin = {
    accent = "red";
    flavor = "frappe";
  };

  nixos.hardware = {
    amdcpu.enable = true;
    amdgpu.enable = true;
  };

  nixos.system.powermanagement.profiles.performance = lib.mkForce true;

  nixos.system.user.defaultuser = {
    name = "jf";
    pass = "$y$j9T$VLRm4nCKGD/ww64EwANZr0$Jrfk/VugVr/U7LP82BGFD.wlKOqwDAatzcZCAOOSRs2";
  };

  nixos.userEnvironment.enable = lib.mkForce false;
}