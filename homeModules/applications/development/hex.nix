{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.development.hex = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable hex tools.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.development.hex.enable {
    home.packages = with pkgs; [
      okteta
    ];
  };
}
