{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    system.nixosvm = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable nixosvm.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.nixosvm.enable {
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
