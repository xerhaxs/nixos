{ config, pkgs, ... }:

{
  imports = [
    ./bootloader.nix
    ./driver.nix
    ./hardware-configuration.nix
    ./hardware.nix
    ./locals.nix
    ./networking.nix
    ./powersave.nix
    ./sddm.nix
    ./user.nix
  ];
}
