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

    services.logind = {
      enable = true;
      powerKey = "poweroff";
      powerKeyLongPress = "factory-reset";
      suspendKey = "suspend";
      suspendKeyLongPress = "suspend-then-hibernate";
      hibernateKey = "hibernate";
      hibernateKeyLongPress = "suspend-then-hibernate";
      rebootKey = "factory-reset";
      rebootKeyLongPress = "factory-reset";
      lidSwitch = "suspend";
      lidSwitchDocked = "ignore";
      lidSwitchExternalPower = "ignore";
      PowerKeyIgnoreInhibited = "yes";
      SuspendKeyIgnoreInhibited = "yes";
      HibernateKeyIgnoreInhibited = "yes";
      RebootKeyIgnoreInhibited = "yes";
      LidSwitchIgnoreInhibited = "yes";
    };

    environment.systemPackages = with  pkgs;[
      powerstat
      powertop
    ];
  };
}


  