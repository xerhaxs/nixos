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
    amdcpu.enable = true;
    amdgpu.enable = true;
  };

  # https://wiki.nixos.org/wiki/Laptop
  services.auto-cpufreq = {
    enable = true;
    settings = {
      charger = {
        governor = "performance";
        turbo = "auto";
      };
      battery = {
        governor = "powersave";
        turbo = "auto";
      };
    };
  };
  services.power-profiles-daemon.enable = lib.mkForce false;
  #nixos.system.powermanagement.profiles.powersave = lib.mkForce true;

  nixos.system.user.defaultuser = {
    name = "jf";
    pass = "$y$j9T$VLRm4nCKGD/ww64EwANZr0$Jrfk/VugVr/U7LP82BGFD.wlKOqwDAatzcZCAOOSRs2";
  };

  nixos.userEnvironment.enable = lib.mkForce true;
}