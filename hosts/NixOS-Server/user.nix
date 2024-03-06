{ config, pkgs, ... }:

let
  user = "admin";
  pass = "$y$j9T$MXbWf.peSOtvQQtYvZvuZ.$7XUvmCniT4h4o.SFaGqD29F13RWyGW7bNpBcMpHKHH3";
in

{
 users.users.${user} = {
    isNormalUser = true;
    group = "users";
    home = "/home/${user}";
    description = "${user}";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
    initialHashedPassword = "${pass}";
    shell = pkgs.bash;

    #packages = with pkgs; [];
  };
}

