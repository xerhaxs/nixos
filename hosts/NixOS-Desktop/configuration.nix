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
    windowManager = {
      hyprland.enable = lib.mkForce false; # change
    };
  };

  nixos.hardware = {
    amdcpu.enable = true;
    amdgpu.enable = true;
  };

  nixos.system.powermanagement.profiles.performance = lib.mkForce true;

  nixos.system.user.defaultuser = {
    name = "jf";
    pass = "$y$j9T$NIfKOLrAK89gT5XGx20xK1$wrK821uQS6HRoh6FBlifDpJ2qakLfIWv8C8vyEwnpT/";
  };

  nixos.userEnvironment.enable = lib.mkForce true;

  #programs.hyprland.enable = true;
  #programs.hyprland.xwayland.enable = true;
  #environment.systemPackages = with pkgs; [
  #  dunst
  #  rofi-wayland
  #  hyprlock
  #  waybar
  #  hyprland
  #  swww
  #  hyprlandPlugins.hyprgrass
  #];
}