{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:

{
  imports = [
    ./bottles.nix
    ./diff.nix
    ./hex.nix
    ./imager.nix
    ./jetbrains.nix
    ./kate.nix
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
      bottles.enable = lib.mkDefault true;
      diff.enable = lib.mkDefault false;
      hex.enable = lib.mkDefault false;
      imager.enable = lib.mkDefault false;
      jetbrains.enable = lib.mkDefault false;
      kate.enable = true;
      singleboardcomputer.enable = lib.mkDefault false;
      virtualisation.enable = lib.mkIf osConfig.nixos.virtualisation.kvm.enable true;
      vscodium.enable = true;
    };
  };
}
