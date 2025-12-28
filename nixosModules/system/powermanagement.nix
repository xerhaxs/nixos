{ config, lib, pkgs, ... }:

{
  options.nixos = {
    system.powermanagement = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable powermanagement options.";
      };
    };
  };

  config.nixos.system.powermanagement.enable = {
    services.upower = {
      enable = true;
      ignoreLid = false;
      criticalPowerAction = "HybridSleep";
      percentageAction = 3;
      percentageCritical = 5;
      percentageLow = 10;
    };

    powerManagement.enable = true;
    services.power-profiles-daemon.enable = true;

    environment.systemPackages = with  pkgs;[
      powerstat
      powertop
    ];
  };
}


  