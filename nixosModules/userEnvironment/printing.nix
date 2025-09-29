{ config, lib, pkgs, ... }:

{
  imports = [
    ../pkgs/sane-extra-config.nix
  ];

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

    environment.systemPackages = with pkgs; [
      cups-kyocera-ecosys-m2x35-40-p2x35-40dnw
    ];

    hardware.sane = {
      enable = true;
      openFirewall = false;
      extraBackends = [ pkgs.sane-airscan ];
      extraConfig."genesys" = ''
        # Enable Canon 4400F
        # Disabled to prevent possible physical damage due to overheating (#436)
        usb 0x04a9 0x2228
      '';
    };

    services.udev.packages = [ pkgs.sane-airscan ];

    services.ipp-usb.enable = true;

    #networking.firewall = {
    #  allowedTCPPorts = [ 53 139 443 445 515 631 9100 9101 9102 22000 ];
    #  allowedUDPPorts = [ 53 137 161 5353 ];
    #};
  };
}

