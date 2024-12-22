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
      hyprland.enable = lib.mkForce true;
    };
  };

  nixos.theme.catppuccin = {
    accent = "Mauve";
    flavor = "Mocha";
  };

  nixos.hardware = {
    intelcpu.enable = true;
    intelgpu.enable = true;
  };

  nixos.system = {
    powermanagement.enable = lib.mkForce false;
  };

  nixos.hardware = {
    corectrl.enable = lib.mkForce false;
    openrgb.enable = lib.mkForce false;
  };

  nixos.virtualisation.enable = lib.mkForce false;

  nixos.system.user.defaultuser = {
    name = "jf";
    pass = "$y$j9T$78ZJbkD949MLi7rdkwu6p0$lWZLpYlDMOF3By4TWffCfrSftRJDfekrkAVU8I5KUP3";
  };

  nixos.userEnvironment.enable = lib.mkForce true;
}