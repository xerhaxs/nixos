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

  config.nixos.system.powermanagement = {
    enable = lib.mkIf config.nixos.system.powermanagement.enable {
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

    profiles.powersave = lib.mkIf config.nixos.system.powermanagement.profiles.powersave {
      powerManagement = {
        cpuFreqGovernor = "powersave";
        scsiLinkPolicy = "min_power";
        powertop.enable = true;
      };
    };

    profiles.balance = lib.mkIf config.nixos.system.powermanagement.profiles.balance {
      powerManagement = {
        cpuFreqGovernor = "ondemand";
        scsiLinkPolicy = "max_performance";
        powertop.enable = true;
      };
    };

    profiles.performance = lib.mkIf config.nixos.system.powermanagement.profiles.performance {
      powerManagement = {
        cpuFreqGovernor = "performance";
        scsiLinkPolicy = "max_performance";
        powertop.enable = false;
      };
    };
  };
}


  