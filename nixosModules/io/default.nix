{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    io = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable io modules bundle.";
      };
    };
  };

  config = mkIf config.nixos.io.enable {
    imports = [
      ./bluetooth.nix
      ./input.nix
      ./razer.nix
    ];
  };
}
