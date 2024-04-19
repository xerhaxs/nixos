{ config, lib, pkgs, ... }:

{
  imports = [
    ./antimicrox.nix
    ./heoric.nix
    ./mangohud.nix
    ./prismlauncher.nix
    ./steam.nix
  ];

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
    homeManager.applications.gaming = {
      antimicrox.enable = false;
      heroic.enable = true;
      mangohud.enable = true;
      prismlauncher.enable = true;
      steam.enable = true;
    };
  };
}