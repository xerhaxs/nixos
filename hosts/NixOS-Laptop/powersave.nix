{ config, lib, pkgs, ... }:

{
  #services.power-profiles-daemon.enable = true;

  #services.auto-cpufreq.settings = {
  #  enable = false;
  #  settings = {
  #    battery = {
  #      scaling_max_freq = 2000000;
  #      governor = "powersave";
  #      turbo = "never";
  #    };
  #    charger = {
  #      governor = "performance";
  #      turbo = "auto";
  #    };
  #  };
  #};

  #services.tlp = {
  #  enable = false;
  #  settings = {
  #    TLP_ENABLE = 1;
  #    TLP_DEFAULT_MODE = "BAT";
  #    TLP_PERSISTENT_DEFAULT = 1;
  #    PLATFORM_PROFILE_ON_AC = "performance";
  #    PLATFORM_PROFILE_ON_BAT = "low-power";
  #    RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
  #    RADEON_DPM_PERF_LEVEL_ON_BAT = "low";
  #    RADEON_DPM_STATE_ON_AC = "performance";
  #    RADEON_DPM_STATE_ON_BAT = "battery";
  #    NMI_WATCHDOG = 1;
  #    USB_AUTOSUSPEND=0;
  #    CPU_DRIVER_OPMODE_ON_AC = "active";
  #    CPU_DRIVER_OPMODE_ON_BAT = "active";
  #    CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #    CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
  #    CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #    CPU_MIN_PERF_ON_AC = 0;
  #    CPU_MAX_PERF_ON_AC = 100;
  #    CPU_MIN_PERF_ON_BAT = 0;
  #    CPU_MAX_PERF_ON_BAT = 20;
  #    CPU_BOOST_ON_AC = 1;
  #    CPU_BOOST_ON_BAT = 0;
  #    RESTORE_DEVICE_STATE_ON_STARTUP = 0;
  #  };
  #};

  #powerManagement = {
  #  enable = true;
  #  cpuFreqGovernor = "powersave";
  #  scsiLinkPolicy = "min_power";
  #  powertop.enable = true;
  #};
}
