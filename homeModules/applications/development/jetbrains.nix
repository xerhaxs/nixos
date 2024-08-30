{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.development.jetbrains = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Jetbrains IDEs.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.development.jetbrains.enable {
    home.packages = with pkgs; [
      jetbrains.idea-community
      jetbrains.pycharm-community
      jetbrains.rider
      #jetbrains.clion
      #jetbrains.rust-rover
      #jetbrains.aqua
      #jetbrains.pycharm-professional
      #jetbrains.idea-ultimate
    ];
  };
}
