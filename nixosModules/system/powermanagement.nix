{ config, lib, pkgs, ... }:

{
  options.nixos = {
    system.powermanagement = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable Docker virtualisation.";
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
          default = true;
          example = false;
          description = "Enables balance profile.";
        };
        performance  = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "Enables performance profile.";
        }
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

    powersave = lib.mkIf config.nixos.system.powermanagement.powersave {
      powerManagement = {
        cpuFreqGovernor = "powersave";
        scsiLinkPolicy = "min_power";
        powertop.enable = true;
      };
    };

    balance = lib.mkIf config.nixos.system.powermanagement.balance {
      powerManagement = {
        cpuFreqGovernor = "ondemand";
        scsiLinkPolicy = "max_performance";
      };
    };

    performance = lib.mkIf config.nixos.system.powermanagement.performance {
      powerManagement = {
        cpuFreqGovernor = "performance";
        scsiLinkPolicy = "max_performance";
      };
    };
  };
}


  