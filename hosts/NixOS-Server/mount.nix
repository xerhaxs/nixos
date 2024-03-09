{ config, pkgs, ... }:

{
  #environment.etc.crypttab = {
  #  enable = true;
  #  text = ''
  #    var       /dev/disk/by-partlabel/disk-VAR-luks 	    /root/keyfile.key 	luks
  #  '';
  #};

  fileSystems."/var" = {
    device = "/dev/crypt2/var";
    fsType = "ext4";
    encrypted = {
      enable = true;
      blkDev = "/dev/disk/by-partlabel/disk-VAR-luks";
      keyFile = "/root/keyfile.key";
    };
  };
}
