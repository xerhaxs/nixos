{ config, lib, pkgs, ... }:

{
  imports = [
    ./bluetooth.nix
    ./input.nix
    ./razer.nix
  ];

  options.nixos = {
    io = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable io modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.io.enable {
    nixos.io = {
      bluetooth.enable = true;
      input.enable = true;
      razer.enable = true;
    };
  };
}
