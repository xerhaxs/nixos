{ config, pkgs, ... }:

let
  user = "jf";
  pass = "$y$j9T$A6v316Tc2Usaan2354fxd1$wulue.bpYvZaWAASMRbzx6OlrxLCODK8higp4OkTLJB";
in

{
 users.users.${user} = {
    name = "jf";
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

