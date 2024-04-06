{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.terminal = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable terminal modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.terminal.enable {
    imports = [
      ./alacritty.nix
      ./kitty.nix
    ];
  };
}