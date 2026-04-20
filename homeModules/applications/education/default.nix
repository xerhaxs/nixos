{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./kiwix.nix
    ./stellarium.nix
  ];

  options.homeManager = {
    applications.education = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable education modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.education.enable {
    homeManager.applications.education = {
      kiwix.enable = lib.mkDefault false;
      stellarium.enable = lib.mkDefault false;
    };
  };
}
