{ config, lib, pkgs, ... }: 

{ 
  nixos.disko.disko-uefi-lvm-on-luks.enable = lib.mkForce true;
  _module.args.disks = [ "/dev/sda" ];

  disko.devices = {
    lvm_vg = {
      crypt = {
        lvs = {
          swap = {
            size = lib.mkForce "4G";
          };
          root = {
            size = lib.mkForce "60%FREE";
          };
        };
      };
    };
  };
}
