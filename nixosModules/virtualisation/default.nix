{ config, lib, pkgs, ... }:

{ 
  options.nixos = {
    virtualisation = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable virtualisation modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.virtualisation.enable {
    imports = [
      ./docker.nix
      ./kvm.nix
      ./podman.nix
      ./waydroid.nix
    ];
  };
}
