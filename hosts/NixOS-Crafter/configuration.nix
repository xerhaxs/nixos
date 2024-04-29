{ config, lib, pkgs, ... }:

{
  nixos.base.tools.syncthing.enable = lib.mkForce true;

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

  nixos.hardware = {
    intelcpu.enable = true;
    intelgpu.enable = true;
  };

  nixos.system.powermanagement.profiles.performance = lib.mkForce true;

  nixos.system.user.defaultuser = {
    name = "crafter";
    pass = "$y$j9T$jm4Ok07L9BMRmMMjIh6/v0$R1lQzhy9WB.bGHrGVAogBhuK2b3EtjZPwQRwC9LhaCD";
  };

  nixos.userEnvironment.enable = lib.mkForce true;
}