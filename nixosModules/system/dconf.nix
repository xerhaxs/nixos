{ config, lib, pkgs, ... }:

{
  options.nixos = {
    system.dconf = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable dconf.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.dconf.enable {
    programs.dconf = {
      enable = true;
    };
  };
}
