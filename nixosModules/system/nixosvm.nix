{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    system.nixosvm = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable nixosvm.";
      };
    };
  };

  config = mkIf config.nixos.system.nixosvm.enable {
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
  };
}