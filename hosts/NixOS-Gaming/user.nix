{ config, pkgs, ... }:

let
  user = "sirmorton";
  pass = "$y$j9T$ZAmhjrTtQkOQOPPLspZhB/$2CG3JjrG5qN3x1iuAwF5excY0oRan6LSCCkemcW2S09";
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

