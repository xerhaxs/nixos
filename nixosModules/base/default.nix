{ config, lib, pkgs, ... }:

{
  imports = [
    ./shell
    ./texteditor
    ./tools
  ];

  options.nixos = {
    base = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable base modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.enable {
    nixos.base = {
      shell.enable = true;
      texteditor.enable = false; #
      tools.enable = false; #
    };
  };
}
