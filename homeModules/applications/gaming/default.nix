{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.gaming = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable gaming modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.gaming.enable {
    imports = [
      ./antimicrox.nix
      ./heoric.nix
      ./mangohud.nix
      ./prismlauncher.nix
      ./steam.nix
    ];
  };
}