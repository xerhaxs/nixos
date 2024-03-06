{ config, pkgs, ... }:

let
  user = "crafter";
  pass = "$y$j9T$jm4Ok07L9BMRmMMjIh6/v0$R1lQzhy9WB.bGHrGVAogBhuK2b3EtjZPwQRwC9LhaCD";
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

