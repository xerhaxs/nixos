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
      hyprland.enable = lib.mkForce false;
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

  nixos.system.user.defaultuser = {
    name = "jf";
    pass = "$y$j9T$Sk0YKa.aiOMJV6WkJIfPH/$M9tPRxHihyAZ1TxGjC.KZRDR49rpHy96HJ7anTtr8p/";
  };

  nixos.userEnvironment.enable = lib.mkForce true;
}