{ config, lib, pkgs, ... }:

{
  imports = [
    ./clementine.nix
    ./heroic.nix
    ./kmymoney.nix
    ./obs-studio.nix
    ./qalculate.nix
  ];

  options.nixos = {
    userEnvironment.config = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable config modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.config.enable {
    nixos.userEnvironment.config = {
      clementine.enable = true;
      heroic.enable = true;
      kmymoney.enable = true;
      obs-studio.enable = true;
      qalculate.enable = true;
    };
  };
}
