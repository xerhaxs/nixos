{ config, lib, pkgs, ... }:

{
  environment.etc.crypttab = {
    enable = true;
    text = ''
      data       /dev/disk/by-label/CRYPTDATA 	    /root/keyfile 	luks
      games      /dev/disk/by-label/CRYPTGAMES 	    /root/keyfile 	luks
      backup     /dev/disk/by-label/CRYPTBACKUP 	/root/keyfile 	luks
    '';
  };

  #boot.initrd.luks.devices = {
  # "crypt" = {
  #    device = "/dev/disk/by-partlabel/disk-VAR-luks";
  #    keyFile = "/mnt-root/root/keyfile.key";
  #    preLVM = true;
  #  };
  #};

  nixos.system.mount.enable = lib.mkForce false;

  fileSystems."/" = lib.mkForce {
    device = lib.mkForce "/dev/mapper/crypt-root";
    fsType = "ext4";
  };

  fileSystems."/boot" = lib.mkForce {
    device = lib.mkForce "/dev/disk/by-label/UEFI";
    fsType = "vfat";
  };

  fileSystems."/home" = lib.mkForce {
    device = lib.mkForce "/dev/mapper/crypt-home";
    fsType = "ext4";
  };

  # Internal Storage
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

  fileSystems."/var/lib/radicale" = {
    device = "/mount/Data/Datein/Server/radicale";
    options = [ 
      "bind"
      "auto"
    ];
  };
}
