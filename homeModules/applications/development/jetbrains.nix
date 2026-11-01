{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.development.jetbrains = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable JetBrains IntelliJ IDEA and PyCharm (unfree, add idea and pycharm to the unfree predicate in nixosModules/system/nixos.nix first).";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.development.jetbrains.enable {
    home.packages = with pkgs; [
      jetbrains.idea
      jetbrains.pycharm
      #jetbrains.rider
      #jetbrains.clion
      #jetbrains.rust-rover
      #jetbrains.aqua
      #jetbrains.pycharm-professional
      #jetbrains.idea-ultimate
    ];
  };
}
