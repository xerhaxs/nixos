{ config, lib, pkgs, ... }:

{
  nixos.desktop = {
    desktopEnvironment = {
      plasma6.enable = lib.mkForce true;
    };
    displayManager = {
      defaultSession = "plasma";
      sddm.enable = lib.mkForce true;
    };
    windowManager = {
      hyprland.enable = lib.mkForce false;
    };
  };

  nixos.theme.catppuccin = {
    accent = "Mauve";
    flavor = "Mocha";
  };

  nixos.hardware = {
    amdcpu.enable = true;
    amdgpu.enable = true;
  };

  # https://wiki.nixos.org/wiki/Laptop
  #services.auto-cpufreq = {
  #  enable = true;
  #  settings = {
  #    charger = {
  #      governor = "performance";
  #      turbo = "auto";
  #    };
  #    battery = {
  #      governor = "powersave";
  #      turbo = "auto";
  #    };
  #  };
  #};

  environment.systemPackages = with  pkgs;[
    powertop
  ];

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance"; # Sets CPU governor to performance on AC power
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave"; # Sets CPU governor to powersave on battery

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance"; # Favors performance over efficiency on AC
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power"; # Favors power saving on battery

      CPU_BOOST_ON_AC = 1; # Enables CPU turbo boost when plugged in
      CPU_BOOST_ON_BAT = 0; # Disables turbo boost on battery

      CPU_DRIVER_OPMODE_ON_AC = "active"; # Forces AMD pstate driver active mode on AC
      CPU_DRIVER_OPMODE_ON_BAT = "active"; # Forces AMD pstate driver active mode on battery

      PLATFORM_PROFILE_ON_AC = "performance"; # Sets firmware profile to performance on AC
      PLATFORM_PROFILE_ON_BAT = "low-power"; # Sets firmware profile to low power on battery

      DISK_DEVICES = "nvme0n1"; # Target disk device for power management
      DISK_APM_LEVEL_ON_AC = "254"; # Disables aggressive power saving for disk on AC
      DISK_APM_LEVEL_ON_BAT = "128"; # Enables moderate power saving for disk on battery

      PCIE_ASPM_ON_AC = "performance"; # Disables PCIe power saving on AC
      PCIE_ASPM_ON_BAT = "powersupersave"; # Enables maximum PCIe power saving on battery

      #USB_AUTOSUSPEND = 1; # Enables USB autosuspend to save power
      #USB_BLACKLIST_BTUSB = 1; # Prevents Bluetooth USB from being suspended

      #WIFI_PWR_ON_AC = "off"; # Disables WiFi power saving on AC
      #WIFI_PWR_ON_BAT = "on"; # Enables WiFi power saving on battery

      SOUND_POWER_SAVE_ON_AC = 0; # Disables sound card power saving on AC
      SOUND_POWER_SAVE_ON_BAT = 1; # Enables sound card power saving on battery

      RADEON_DPM_STATE_ON_AC = "performance"; # Forces GPU performance state on AC
      RADEON_DPM_STATE_ON_BAT = "battery"; # Forces GPU power saving state on battery

      RADEON_POWER_PROFILE_ON_AC = "high"; # Sets high GPU power profile on AC
      RADEON_POWER_PROFILE_ON_BAT = "low"; # Sets low GPU power profile on battery

      #START_CHARGE_THRESH_BAT0 = 75; # Battery starts charging below this percentage
      #STOP_CHARGE_THRESH_BAT0 = 85; # Battery stops charging at this percentage

      RUNTIME_PM_ON_AC = "on"; # Enables runtime power management on AC
      RUNTIME_PM_ON_BAT = "auto"; # Enables automatic runtime power management on battery

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 75;
    };
  };

  #powerManagement.enable = true;
  services.power-profiles-daemon.enable = lib.mkForce false;
  #powerManagement.powertop.enable = lib.mkForce true;
  #powerManagement.powertop.postStart = ''
  #  ''${lib.getExe' config.systemd.package "udevadm"} trigger -c bind -s usb -a idVendor=046d -a idProduct=c08c
  #''
  #nixos.system.powermanagement.profiles.powersave = lib.mkForce true;

  nixos.system.user.defaultuser = {
    name = "jf";
    pass = "$y$j9T$VLRm4nCKGD/ww64EwANZr0$Jrfk/VugVr/U7LP82BGFD.wlKOqwDAatzcZCAOOSRs2";
  };

  nixos.userEnvironment.enable = lib.mkForce true;
}