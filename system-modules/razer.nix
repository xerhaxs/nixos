{ config, pkgs, ... }:

{
  hardware.openrazer = {
    enable = true;
    devicesOffOnScreensaver = true;
    mouseBatteryNotifier = true;
    syncEffectsEnabled = true;
    users = [ "root" "jf" ];
  };
  environment.systemPackages = with pkgs; [
    razergenie
  ];
}
