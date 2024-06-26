{ config, lib, pkgs, ... }:

{
  options.nixos = {
    base.tools.htop = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable htop.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.tools.htop.enable {
    programs.htop = {
      enable = true;
      #settings = { };
    };
  };
}