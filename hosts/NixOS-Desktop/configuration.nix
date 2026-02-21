{
  config,
  lib,
  pkgs,
  ...
}:

{
  nixos.desktop = {
    enable = true;
    desktopEnvironment = {
      plasma6.enable = true;
    };
    displayManager = {
      defaultSession = "plasma";
      sddm.enable = true;
    };
    windowManager = {
      hyprland.enable = false;
    };
  };

  nixos.theme.catppuccin = {
    accent = "Mauve";
    flavor = "Mocha";
  };

  nixos.hardware = {
    amdcpu.enable = true;
    amdgpu.enable = true;
  };

  nixos.system.user.defaultuser = {
    name = "jf";
    pass = "$y$j9T$NIfKOLrAK89gT5XGx20xK1$wrK821uQS6HRoh6FBlifDpJ2qakLfIWv8C8vyEwnpT/";
    #passfile = config.sops.secrets."user/nixos-desktop/jf".path;
  };

  nixos.system.secureboot.enable = true;

  nixos.userEnvironment.enable = true;
  nixos.userEnvironment.game.enable = true;

  nixos.virtualisation.android.enable = true;
  nixos.virtualisation.kvm.enable = true;

  services.flatpak.enable = true;
}
