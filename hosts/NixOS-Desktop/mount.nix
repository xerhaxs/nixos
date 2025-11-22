{ config, lib, pkgs, ... }:

{
  environment.etc.crypttab = {
    enable = true;
    text = ''
      data       /dev/disk/by-label/CRYPTDATA 	    /root/keyfile.key 	luks
      games      /dev/disk/by-label/CRYPTGAMES 	    /root/keyfile.key 	luks
      backup     /dev/disk/by-label/CRYPTBACKUP 	  /root/keyfile.key 	luks
    '';
  };

  #nixos.system.mount.enable = lib.mkForce false;

  fileSystems."/mount/Data" = {
    device = "/dev/mapper/data";
    fsType = "ext4";
    options = [
      "defaults"
      "auto"
    ];
  };

  fileSystems."/mount/Games" = {
    device = "/dev/mapper/games";
    fsType = "ext4";
	  options = [
      "defaults"
      "auto"
    ];
  };

  fileSystems."/mount/Backup" = {
    device = "/dev/mapper/backup";
    fsType = "ext4";
	  options = [
      "defaults"
      "auto"
    ];
  };
}
