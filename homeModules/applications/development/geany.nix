{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.development.geany = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable geany tools.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.development.geany.enable {
    home.packages = with pkgs; [
      geany
    ];
  };
}
