{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.media.vlc = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable vlc.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.media.vlc.enable {
    home.packages = with pkgs; [
      vlc
    ];
  };
}
