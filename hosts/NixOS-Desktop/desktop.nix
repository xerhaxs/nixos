{ config, lib, pkgs, ... }:

{
  #homeManager.applications.enable = true;

  nixos.base.tools.syncthing.enable = true;

  nixos.desktop = {
    desktopEnvironment = {
      plasma6.enable = true;
    };
    displayManager = {
      defaultSession = "plasma";
      sddm.enable = true;
    };
    windowManager = {
      hyprland.enable = true;
    };
  };

  nixos.hardware = {
    amdcpu.enable = true;
    amdgpu.enable = true;
  };

  nixos.server.enable = lib.mkDefault true;

  nixos.system.nasmount.enable = true;

  nixos.system.powerManagement.profiles.performance = lib.mkDefault true;

  nixos.system.user.defaultuser = {
    name = "jf";
    pass = "$y$j9T$A6v316Tc2Usaan2354fxd1$wulue.bpYvZaWAASMRbzx6OlrxLCODK8higp4OkTLJB";
  };

  nixos.userEnvironment.enable = true;
}