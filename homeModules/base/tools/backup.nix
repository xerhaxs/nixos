{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    base.tools.backup = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable backup tools.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.tools.backup.enable {
    home.packages = with pkgs; [
      backintime
      grsync
    ];
  };
}
