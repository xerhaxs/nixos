{ config, lib, pkgs, ... }:

{
  nixos.base.tools.syncthing.enable = true;

  nixos.desktop = {
    desktopEnvironment = {
      plasma6.enable = true;
    };
    displayManager = {
      defaultSession = "plasma";
      sddm.enbale = true;
    };
    windowManager = {
      hyprland.enbale = true;
    }
  };

  nixos.hardware = {
    amdcpu.enable = true;
    amdgpu.enable = true;
  };

  nixos.system.nasmount.enable = true;

  nixos.system.powerManagement.profiles.powersave = lib.mkDefault true;

  nixos.system.user.defaultuser = {
    name = "jf";
    pass = "$y$j9T$QJpNF3qTBVhLCq2CwPCbs1$BJOqUB9uV.QhaBK9SU5s/zRIYP/.3kHL9iff399qdS8";
  };

  nixos.userEnvironment.enable = true;
}