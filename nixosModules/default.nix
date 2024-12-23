{ config, lib, pkgs, ... }:

{
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
      base.enable = false;
      desktop.enable = false;
      disko.enable = true;
      hardware.enable = false;
      io.enable = false;
      pkgs.enable = false;
      server.enable = false;
      system.enable = true;
      theme.enable = false;
      userEnvironment.enable = false;
      virtualisation.enable = false;
    };
  };
}
