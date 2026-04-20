{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.tools.gnomedisk = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable gnomedisk";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.tools.gnomedisk.enable {
    home.packages = with pkgs; [
      gnome-disk-utility
    ];
  };
}
