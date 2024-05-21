{ config, lib, pkgs, ... }:

{
  options.nixos = {
    base.tools.ubstop = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable ubstop.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.tools.ubstop.enable {
    programs.ubstop = {
      enable = true;
    };
  };
}