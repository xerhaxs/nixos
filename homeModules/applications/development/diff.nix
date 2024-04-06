{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.development.diff = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable diff tools.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.development.diff.enable {
    home.packages = with pkgs; [
      kompare
    ];
  };
}
