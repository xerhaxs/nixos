{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.education.stellarium = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable stellarium.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.education.stellarium.enable {
    home.packages = with pkgs; [
      stellarium
    ];
  };
}
