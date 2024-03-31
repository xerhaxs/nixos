{ config, lib, pkgs, ... }:

{
  users.users.${config.defaultuser.name} = {
    name = "${config.defaultuser.name}";
    isNormalUser = true;
    group = "users";
    home = "/home/${config.defaultuser.name}";
    description = "${config.defaultuser.name}";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
    initialHashedPassword = "${config.defaultuser.pass}";
    shell = pkgs.bash;
  };
}

