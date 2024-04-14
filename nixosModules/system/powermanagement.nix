{ config, lib, pkgs, ... }:

{
  options.nixos = {
    system.powermanagement = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable powermanagment options.";
      };
      profiles = {
        powersave = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "Enables powersave profile.";
        };
        balance = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "Enables balance profile.";
        };
        performance = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "Enables performance profile.";
        };
      };
    };
  };

  config = lib.mkIf config.nixos.system.powermanagement.enable {
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

    powerManagement = {
      cpuFreqGovernor = lib.mkIf config.nixos.system.powermanagement.profiles.powersave "powersave" 
        (lib.mkIf config.nixos.system.powermanagement.profiles.balance "ondemand" "performance");
      scsiLinkPolicy = lib.mkIf config.nixos.system.powermanagement.profiles.powersave "min_power" "max_performance";
    };
  };
}


  