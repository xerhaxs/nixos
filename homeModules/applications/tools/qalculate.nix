{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.tools.qalculate = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable qalculate";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.tools.qalculate.enable {
    home.packages = with pkgs; [
      qalculate-gtk
    ];
  };
}
