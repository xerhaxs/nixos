{ config, lib, pkgs, ... }:

{
  options.nixos = {
    pkgs = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable pkgs modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.pkgs.enable {
    imports = [
      ./wallpaper-engine-kde-plugin.nix
    ];
  };
}