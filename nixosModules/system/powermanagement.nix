{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    system.powermanagement = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable Docker virtualisation.";
      };
    };
  };

  config = mkIf config.nixos.system.powermanagement.enable {
    services.upower = {
      enable = true;
      ignoreLid = false;
      criticalPowerAction = "HybridSleep";
      percentageAction = 2;
      percentageCritical = 5;
      percentageLow = 10;
    };
    powerManagement.enable = true;
    services.power-profiles-daemon.enable = true;
  };
}
