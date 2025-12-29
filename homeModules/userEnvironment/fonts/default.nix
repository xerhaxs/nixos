{ config, lib, pkgs, ... }:

{
  imports = [
    ./fonts.nix
  ];

  options.homeManager = {
    userEnvironment.fonts = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable fonts modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.userEnvironment.fonts.enable {
    homeManager.userEnvironment.fonts = {
      fonts.enable = true;
    };
  };
}