{ config, lib, pkgs, modulesPath, ... }:

{
  options.nixos = {
    hosts.installer.bash = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable installer config.";
      };
    };
  };

  config = lib.mkIf config.nixos.hosts.installer.enable {
    imports = [
      "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    ];

    nixpkgs.hostPlatform = "x86_64-linux";
  };
}