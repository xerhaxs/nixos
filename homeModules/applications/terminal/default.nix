{ config, lib, pkgs, ... }:

{
  imports = [
    ./alacritty.nix
    ./kitty.nix
  ];

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
    homeManager.applications.terminal = {
      alacritty.enable = false;
      kitty.enable = true;
    };
  };
}