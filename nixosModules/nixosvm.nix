{ config, pkgs, ... }:

{
  virtualisation.vmVariant = {
    virtualisation = {
      #diskSize = 32768;
      #diskImage = "";
      cores = 8;
      graphics = true;
      useEFIBoot = true;
      memorySize = 4096;
      useSecureBoot = false;
    };
  };
}