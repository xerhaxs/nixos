{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    base = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable base modules bundle.";
      };
    };
  };

  config = mkIf config.nixos.base.enable {
    imports = [
      ./shell
      ./texteditor
    ];
  };
}
