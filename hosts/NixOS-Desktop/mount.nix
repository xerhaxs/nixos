{ config, lib, pkgs, ... }:

{
  environment.etc.crypttab = {
    enable = true;
    text = ''
      data       /dev/disk/by-label/CRYPTDATA 	    /root/keyfile.key 	luks,discard
      games      /dev/disk/by-label/CRYPTGAMES 	    /root/keyfile.key 	luks,discard
      backup     /dev/disk/by-label/CRYPTBACKUP 	  /root/keyfile.key 	luks,discard
    '';
  };

  fileSystems."/mount/Data" = {
    device = "/dev/mapper/data";
    fsType = "ext4";
    options = [
      "defaults"
      "auto"
      "discard=async"
      "nofail"
    ];
  };

  fileSystems."/mount/Games" = {
    device = "/dev/mapper/games";
    fsType = "ext4";
	  options = [
      "defaults"
      "auto"
      "discard=async"
      "nofail"
    ];
  };

  fileSystems."/mount/Backup" = {
    device = "/dev/mapper/backup";
    fsType = "ext4";
	  options = [
      "defaults"
      "auto"
      "discard=async"
      "nofail"
    ];
  };
}
