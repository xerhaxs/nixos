{ config, lib, pkgs, ... }:

{ 
  imports = [
    ./docker.nix
    ./kvm.nix
    ./podman.nix
    ./waydroid.nix
  ];

  options.nixos = {
    virtualisation = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable virtualisation modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.virtualisation.enable {
    nixos.virtualisation = {
      docker.enable = false;
      kvm.enable = true;
      podman.enable = true;
      waydroid.enable = true;
    };
  };
}
