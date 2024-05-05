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
    intelcpu.enable = true;
    intelgpu.enable = true;
  };

  nixos.system.powermanagement.profiles.performance = lib.mkForce true;

  nixos.system.user.defaultuser = {
    name = "crafter";
    pass = "$y$j9T$NGE6b.r/2wiEsu42u31ay/$gzDPnUYKu7hv2YUvSiS0699rfojQFuBE5Hmdg8iXre4";
  };

  nixos.userEnvironment.enable = lib.mkForce false;
}