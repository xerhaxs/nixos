{ config, lib, pkgs, ... }:

{
  users.users.${config.defaultuser} = {
    name = "${config.defaultuser}";
    isNormalUser = true;
    group = "users";
    home = "/home/${config.defaultuser}";
    description = "${config.defaultuser}";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
    initialHashedPassword = "${config.defaultuser.pass.hash}";
    shell = pkgs.bash;
  };
}

