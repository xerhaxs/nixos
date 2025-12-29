{ config, lib, pkgs, ... }:

{
  imports = [
    ./base
    ./desktop
    ./disko
    ./hardware
    ./pkgs
    ./server
    ./system
    ./theme
    ./userEnvironment
    ./virtualisation
  ];

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
    nixos = {
      base.enable = true;
      desktop.enable = lib.mkDefault false;
      disko.enable = true;
      hardware.enable = true;
      pkgs.enable = true;
      server.enable = false;
      system.enable = true;
      theme.enable = true;
      userEnvironment.enable = lib.mkDefault false;
      virtualisation.enable = lib.mkDefault false;
    };
  };
}
