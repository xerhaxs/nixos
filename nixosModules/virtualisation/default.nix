{ config, lib, pkgs, ... }:

{ 
  imports = [
    ./android.nix
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
}
