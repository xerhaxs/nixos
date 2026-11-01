{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./base
    ./desktop
    ./disko
    ./hardware
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
      base.enable = lib.mkDefault true;
      desktop.enable = lib.mkDefault false;
      disko.enable = lib.mkDefault true;
      hardware.enable = lib.mkDefault true;
      server.enable = lib.mkDefault false;
      system.enable = lib.mkDefault true;
      theme.enable = lib.mkDefault true;
      userEnvironment.enable = lib.mkDefault false;
      virtualisation.enable = lib.mkDefault false;
    };
  };
}
