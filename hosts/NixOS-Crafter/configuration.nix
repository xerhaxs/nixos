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
    intelcpu.enable = true;
    intelgpu.enable = true;
  };

  nixos.system.powermanagement.profiles.performance = lib.mkDefault true;

  nixos.system.user.defaultuser = {
    name = "crafter";
    pass = "$y$j9T$jm4Ok07L9BMRmMMjIh6/v0$R1lQzhy9WB.bGHrGVAogBhuK2b3EtjZPwQRwC9LhaCD";
  };

  nixos.userEnvironment.enable = true;
}