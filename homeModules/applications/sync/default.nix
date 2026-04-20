{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:

{
  imports = [
    ./kdeconnect.nix
    ./onionshare.nix
    ./rclone.nix
  ];

  options.homeManager = {
    applications.sync = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable sync modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.sync.enable {
    homeManager.applications.sync = {
      kdeconnect.enable = true;
      onionshare.enable = lib.mkDefault false;
      rclone.enable = lib.mkDefault false;
    };
  };
}
