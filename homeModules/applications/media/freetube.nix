{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.media.freetube = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable freetube";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.media.freetube.enable {
    home.packages = with pkgs; [
      freetube
    ];
  };
}
