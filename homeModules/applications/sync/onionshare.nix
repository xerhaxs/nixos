{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.sync.onionshare = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable onionshare sync.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.sync.onionshare.enable {
    home.packages = with pkgs; [
      onionshare-gui
    ];
  };
}
