{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.tools.backintime = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable backintime";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.tools.backintime.enable {
    home.packages = with pkgs; [
      backintime
    ];
  };
}
