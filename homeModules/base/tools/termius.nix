{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    base.tools.termius = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable termius.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.tools.termius.enable {
    home.packages = with pkgs; [
      termius
    ];
  };
}
