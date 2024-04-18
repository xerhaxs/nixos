{ config, lib, pkgs, ... }:

{
  #homeManager.applications.enable = true;

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
    pass = "$y$j9T$A6v316Tc2Usaan2354fxd1$wulue.bpYvZaWAASMRbzx6OlrxLCODK8higp4OkTLJB";
  };
}