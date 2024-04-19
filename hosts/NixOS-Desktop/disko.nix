{ config, lib, pkgs, ... }: 

{ 
  _module.args.disks = [ "/dev/nvme0n1" ];
}
