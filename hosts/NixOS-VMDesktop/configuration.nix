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
    amdcpu.enable = true;
    amdgpu.enable = true;
  };

  nixos.system.user.defaultuser = {
    name = "admin";
    pass = "$y$j9T$HDk4CbWnR9fWeTkI/byxp.$f2hONNjOT8hsi0gg74t8HafjzT/de33PWIRJEhfREB7"; # CHANGEME
  };

  nixos.userEnvironment.enable = true;

  services.qemuGuest.enable = true;
}