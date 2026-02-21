{
  config,
  lib,
  pkgs,
  ...
}:

{
  environment.etc.crypttab = {
    enable = true;
    text = ''
      data       /dev/disk/by-label/CRYPTDATA 	    /root/.secrets/keyfile.key 	luks
      games      /dev/disk/by-label/CRYPTGAMES 	    /root/.secrets/keyfile.key 	luks
      backup     /dev/disk/by-label/CRYPTBACKUP 	  /root/.secrets/keyfile.key 	luks
    ''; # ,discard
  };

  fileSystems."/mount/Data" = {
    device = "/dev/mapper/data";
    fsType = "ext4";
    options = [
      "defaults"
      "auto"
      #"discard=async"
    ];
  };

  fileSystems."/mount/Games" = {
    device = "/dev/mapper/games";
    fsType = "ext4";
    options = [
      "defaults"
      "auto"
      #"discard=async"
    ];
  };

  fileSystems."/mount/Backup" = {
    device = "/dev/mapper/backup";
    fsType = "ext4";
    options = [
      "defaults"
      "auto"
      #"discard=async"
    ];
  };
}
