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

  nixos.system.user.defaultuser = {
    name = "jf";
    pass = "$y$j9T$S9GUmOvHiLeQKWHtuGIMx0$.AHr5Ej3c.Bq/AYHO5Yp5T8/21LI81CdaxEm.q/GJg/";
  };

  nixos.userEnvironment.enable = lib.mkForce true;
}