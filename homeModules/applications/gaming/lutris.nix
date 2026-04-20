{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

{
  options.homeManager = {
    applications.gaming.lutris = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable lutris.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.gaming.lutris.enable {
    programs.lutris = {
      enable = true;
      steamPackage = osConfig.programs.steam.package;
    };
  };
}
