{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./jellyfin.nix
    ./lidarr.nix
    ./nzbhydra2.nix
    ./radarr.nix
    ./readarr.nix
    ./sabnzbd.nix
    ./sonarr.nix
  ];

  options.nixos = {
    server.entertainment = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable entertainment modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.entertainment.enable {
    nixos.server.entertainment = {
      jellyfin.enable = true;
      lidarr.enable = true;
      nzbhydra2.enable = true;
      radarr.enable = true;
      readarr.enable = true;
      sabnzbd.enable = true;
      sonarr.enable = true;
    };
  };
}
