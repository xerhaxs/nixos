{ config, lib, pkgs, ... }:

{
  imports = [
    ./mullvad.nix
    ./protonvpn.nix
  ];

  options.homeManager = {
    applications.vpn = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable vpn modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.vpn.enable {
    homeManager.applications.vpn = {
      #mullvad.enable = true;
      #protonvpn.enable = true;
    };
  };
}