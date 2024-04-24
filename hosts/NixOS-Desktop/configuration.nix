{ config, lib, pkgs, ... }:

{
  nixos.base.tools.syncthing.enable = lib.mkDefault true;

  nixos.desktop = {
    desktopEnvironment = {
      plasma6.enable = lib.mkDefault true;
    };
    displayManager = {
      defaultSession = "plasma";
      sddm.enable = lib.mkDefault true;
    };
    windowManager = {
      hyprland.enable = lib.mkDefault true;
    };
  };

  nixos.hardware = {
    amdcpu.enable = true;
    amdgpu.enable = true;
  };

  nixos.server.enable = lib.mkDefault true;

  nixos.system.powermanagement.profiles.performance = lib.mkDefault true;

  nixos.system.user.defaultuser = {
    name = "jf";
    pass = "$y$j9T$SaLqQo3ZViOa2ZU7Nr6Zz/$qXmVVTq1ulEv4dloO28JLrGGObyoXYH.smVr7UoL7v0";
  };

  nixos.userEnvironment.enable = lib.mkDefault true;
}