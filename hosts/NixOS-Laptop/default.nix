{ config, pkgs, ... }:

{
  imports = [
    ./bootloader.nix
    #./disko-config.nix
    ./driver.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./powersave.nix
    ./sddm.nix
    ./user.nix
  ];
}
