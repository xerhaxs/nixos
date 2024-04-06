{ config, lib, pkgs, ... }:

{
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
    imports = [
      ./barrier.nix
      ./kdeconnect.nix
      ./nextcloud-client.nix
      ./onionshare.nix
      ./syncthing.nix
    ];
  };
}