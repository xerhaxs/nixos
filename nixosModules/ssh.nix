{ config, pkgs, ... }:

{
  services.openssh = {
    settings = {
      passwordAuthentication = true;
      kbdInteractiveAuthentication = false;
      permitRootLogin = "yes";
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];
}
