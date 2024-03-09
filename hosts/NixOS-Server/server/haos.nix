{ config, pkgs, }:

{
  virualisation = {
    diskSize = 32768;
    #diskImage = "/mount/Data/Datein/Downloads/nixos/hosts/desktop/server/haos_ova-11.5.qcow2";
    cores = 4;
    graphics = true;
    useEFIBoot = true;
    memorySize = 2048;
    useSecureBoot = false;
  };
}