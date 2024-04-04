{ config, lib, pkgs, ... }:

{
  options.nixos = {
    io = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable io modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.io.enable {
    imports = [
      ./bluetooth.nix
      ./input.nix
      ./razer.nix
    ];
  };
}
