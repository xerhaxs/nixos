{ config, lib, pkgs, ... }:

{
  services.power-profiles-daemon.enable = true;

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
    scsiLinkPolicy = "min_power";
  };
}
