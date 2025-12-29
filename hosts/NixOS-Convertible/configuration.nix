{ config, lib, pkgs, ... }:

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
    intelcpu.enable = true;
    intelgpu.enable = true;
  };

  nixos.system.user.defaultuser = {
    name = "jf";
    pass = "$y$j9T$S9GUmOvHiLeQKWHtuGIMx0$.AHr5Ej3c.Bq/AYHO5Yp5T8/21LI81CdaxEm.q/GJg/";
  };

  nixos.system.secureboot.enable = true;

  nixos.userEnvironment.enable = true;

  nixos.virtualisation.android.enable = true;
  nixos.virtualisation.kvm.enable = true;
}