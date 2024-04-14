{ config, lib, pkgs, ... }:

{
  options.nixos = {
    userEnvironment.printing = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable printing.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.printing.enable {
    services.printing = {
      enable = true;
      startWhenNeeded = false;
      browsing = true;
      openFirewall = true;
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
      openFirewall = true;
    };

    #services.printing.drivers = [
    #  (writeTextDir "share/cups/model/KyoceraECOSYSP2040dn.PPD" (builtins.readFile ../pkgs/KyoceraECOSYSP2040dn.PPD))
    #];

    hardware.sane = {
      enable = true;
      openFirewall = true;
    };

    #networking.firewall = {
    #  allowedTCPPorts = [ 53 139 443 445 515 631 9100 9101 9102 22000 ];
    #  allowedUDPPorts = [ 53 137 161 5353 ];
    #};
  };
}

