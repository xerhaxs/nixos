{ config, lib, pkgs, ... }:

{
  imports = [
    ./arduino.nix
    ./bottles.nix
    ./diff.nix
    ./dotnet-sdk.nix
    ./geany.nix
    ./hex.nix
    ./java.nix
    ./jetbrains.nix
    ./pulsar.nix
    ./raspberry.nix
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
      arduino.enable = true;
      bottles.enable = true;
      diff.enable = false;
      dotnet-sdk.enable = true;
      geany.enable = true;
      hex.enable = false;
      java.enable = true;
      jetbrains.enable = true;
      pulsar.enable = false;
      raspberry.enable = true;
      virtualisation.enable = true;
      vscodium.enable = true;
    };
  };
}