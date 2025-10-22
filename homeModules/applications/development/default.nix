{ config, lib, pkgs, ... }:

{
  imports = [
    ./arduino.nix
    ./bottles.nix
    ./diff.nix
    ./dotnet-sdk.nix
    ./geany.nix
    ./hex.nix
    ./imager.nix
    ./java.nix
    ./jetbrains.nix
    ./pulsar.nix
    ./virtualisation.nix
    ./vscodium.nix
  ];

  options.homeManager = {
    applications.development = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable development modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.development.enable {
    homeManager.applications.development = {
      arduino.enable = false;
      bottles.enable = true;
      diff.enable = false;
      dotnet-sdk.enable = false;
      geany.enable = false;
      hex.enable = true;
      imager.enable = true;
      java.enable = true;
      jetbrains.enable = false;
      pulsar.enable = false;
      virtualisation.enable = true;
      vscodium.enable = true;
    };
  };
}