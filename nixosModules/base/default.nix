{ config, lib, pkgs, ... }:

{
  options.nixos = {
    base = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable base modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.enable {
    imports = [
      ./shell
      ./texteditor
      ./tools
    ];
  };
}
