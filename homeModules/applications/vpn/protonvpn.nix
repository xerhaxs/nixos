{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.vpn.protonvpn = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable protonvpn.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.vpn.protonvpn.enable {
    home.packages = with pkgs; [
      protonvpn-gui
    ];
  };
}

