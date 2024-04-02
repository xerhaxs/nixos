{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    system.dconf = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable dconf.";
      };
    };
  };

  config = mkIf config.nixos.system.dconf.enable {
    programs.dconf = {
      enable = true;
    };
  };
}
