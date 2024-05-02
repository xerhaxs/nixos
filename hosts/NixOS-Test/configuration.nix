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
    name = "dummy";
    pass = "$y$j9T$GjZ/YRVelFtyOEzczGRs31$Br/TC2Bdb7GIeHwwOxlV9KA.shIgz42l2ye.Suuyue/";
  };

  nixos.userEnvironment.enable = lib.mkForce false;
}