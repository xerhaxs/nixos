{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    system.powermanagement = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable powermanagement options.";
      };

      battery = lib.mkOption {
        type = lib.types.bool;
        default = config.nixos.desktop.enable;
        example = false;
        description = "Enable battery and power profile management (upower, power-profiles-daemon).";
      };
    };
  };

  config = lib.mkIf config.nixos.system.powermanagement.enable {
    services.upower = lib.mkIf config.nixos.system.powermanagement.battery {
      enable = true;
      ignoreLid = false;
      criticalPowerAction = "PowerOff";
      percentageAction = 3;
      percentageCritical = 5;
      percentageLow = 10;
    };

    powerManagement.enable = true;
    services.power-profiles-daemon.enable = config.nixos.system.powermanagement.battery;

    services.logind = {
      enable = true;
      settings.Login = {
        HandlePowerKey = "poweroff";
        HandlePowerKeyLongPress = "poweroff";
        HandleSuspendKey = "suspend";
        HandleSuspendKeyLongPress = "suspend";
        HandleHibernateKey = "suspend";
        HandleHibernateKeyLongPress = "suspend";
        HandleRebootKey = "reboot";
        HandleRebootKeyLongPress = "poweroff";
        HandleLidSwitch = "suspend";
        HandleLidSwitchDocked = "ignore";
        HandleLidSwitchExternalPower = "ignore";
        PowerKeyIgnoreInhibited = "yes";
        SuspendKeyIgnoreInhibited = "yes";
        HibernateKeyIgnoreInhibited = "yes";
        RebootKeyIgnoreInhibited = "yes";
        LidSwitchIgnoreInhibited = "yes";
      };
    };

    environment.systemPackages = with pkgs; [
      powerstat
      powertop
    ];
  };
}
