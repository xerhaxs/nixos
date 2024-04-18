{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.home.haos = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable HAOS.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.home.haos.enable {
    #virtualisation = {
    #  diskSize = 32768;
    #  diskImage = "/mount/Data/Datein/Downloads/nixos/hosts/desktop/server/haos_ova-11.5.qcow2";
    #  cores = 2;
    #  graphics = true;
    #  useEFIBoot = true;
    #  memorySize = 2048;
    #  useSecureBoot = false;
    #};
  };
}