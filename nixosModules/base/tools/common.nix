{ config, lib, pkgs, ... }:

{
  options.nixos = {
    base.tools.common = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable common tools.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.tools.common.enable {
    environment.systemPackages = with pkgs; [
      wget
      newt # whiptail package for nixos
      gparted
      ntfs3g
    ];
  };
}