{ config, pkgs, ... }:

let
  user = "nixos";
  pass = "$y$j9T$wokl9GFpVK889MUxogoDc.$VV6rHmXcz3lea4kfX3v73ARLEplIl7IatX3j1NUHPc/";
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

