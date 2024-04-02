{ config, lib, pkgs, ... }:

with lib;

{ 
  options.nixos = {
    virtualisation = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable virtualisation modules bundle.";
      };
    };
  };

  config = mkIf config.nixos.virtualisation.enable {
    imports = [
      ./docker.nix
      ./kvm.nix
      ./podman.nix
      ./waydroid.nix
    ];
  };
}
