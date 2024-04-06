{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    base.fonts = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable fonts modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.fonts.enable {
    imports = [
      ./fonts.nix
    ];
  };
}