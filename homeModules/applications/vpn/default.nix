{ config, lib, pkgs, ... }:

{
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
    imports = [
      ./mullvad.nix
      ./protonvpn.nix
    ];
  };
}