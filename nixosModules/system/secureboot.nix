{ config, lib, pkgs, ... }:

{
  options.nixos = {
    system.secureboot = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable secureboot.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.secureboot.enable {
    environment.systemPackages = with pkgs; [
      sbctl
    ];
  };
}