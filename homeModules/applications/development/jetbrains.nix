{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.development.jetbrains = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable Jetbrains IDEs.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.development.jetbrains.enable {
    home.packages = with pkgs; [
      jetbrains.idea-community
      jetbrains.pycharm-community
    ];
  };
}
