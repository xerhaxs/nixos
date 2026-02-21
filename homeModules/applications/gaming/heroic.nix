{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.gaming.heroic = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable heroic.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.gaming.heroic.enable {
    home.packages = with pkgs; [
      heroic
    ];
  };
}
