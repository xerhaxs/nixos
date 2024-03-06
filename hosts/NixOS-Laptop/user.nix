{ config, pkgs, ... }:

let
  user = "jf";
  pass = "$y$j9T$QJpNF3qTBVhLCq2CwPCbs1$BJOqUB9uV.QhaBK9SU5s/zRIYP/.3kHL9iff399qdS8";
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

