{ config, lib, pkgs, ... }:

{
  imports = [
    ./fonts.nix
  ];

  options.homeManager = {
    base.fonts = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable fonts modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.fonts.enable {
    homeManager.base.fonts = {
      fonts.enable = true;
    };
  };
}