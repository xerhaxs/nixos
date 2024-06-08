{ config, lib,  pkgs, ... }:

{
  fileSystems."/" = {
    device = lib.mkForce "/dev/pool/root";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = lib.mkForce "/dev/pool/home";
    fsType = "ext4";
  };
}
