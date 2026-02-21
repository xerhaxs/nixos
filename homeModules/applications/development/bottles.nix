{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.development.bottles = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Bottles.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.development.bottles.enable {
    home.packages = with pkgs; [
      bottles
    ];
  };
}
