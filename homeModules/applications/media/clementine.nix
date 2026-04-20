{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.media.clementine = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable clementine.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.media.clementine.enable {
    home.packages = with pkgs; [
      clementine
    ];
  };
}
