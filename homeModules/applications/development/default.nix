{ config, lib, osConfig, pkgs, ... }:

{
  imports = [
    ./bottles.nix
    ./diff.nix
    ./dotnet-sdk.nix
    ./geany.nix
    ./hex.nix
    ./imager.nix
    ./java.nix
    ./jetbrains.nix
    ./nixd.nix
    ./pulsar.nix
    ./singleboardcomputer.nix
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
      bottles.enable = true;
      diff.enable = lib.mkDefault false;
      dotnet-sdk.enable = lib.mkDefault false;
      geany.enable = lib.mkDefault false;
      hex.enable = lib.mkDefault false;
      imager.enable = true;
      java.enable = true;
      jetbrains.enable = lib.mkDefault false;
      nixd.enable = true;
      pulsar.enable = lib.mkDefault false;
      singleboardcomputer.enable = lib.mkDefault false;
      virtualisation.enable = lib.mkIf osConfig.nixos.virtualisation.kvm.enable true;
      vscodium.enable = true;
    };
  };
}