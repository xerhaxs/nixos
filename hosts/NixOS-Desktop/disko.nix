{ config, disko, lib, pkgs, ... }: 

{ 
  imports = [
    disko.nixosModules.disko
  ];

  {
    _module.args.disks = [ "/dev/nvme0n1" ];
  }
}
