{ config, lib, pkgs, ... }:

{
  options.nixos = {
    userEnvironment.dconf = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable dconf.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.dconf.enable {
    programs.dconf = {
      enable = true;
    };
  };
}
