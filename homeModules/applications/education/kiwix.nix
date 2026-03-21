{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.education.kiwix = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable kiwix.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.education.kiwix.enable {
    home.packages = with pkgs; [
      kiwix
    ];
  };
}
