{ config, lib, pkgs, ... }:

{
  options.nixos = {
    nixosModules = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable nixosModules modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.nixosModules.enable {
    imports = [
      ./base
      ./desktop
      ./disko
      ./hardware
      ./io
      ./pkgs
      ./server
      ./system
      ./theme
      ./userEnvironment
      ./virtualisation
    ];
  };
}
