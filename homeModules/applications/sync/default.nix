{ config, lib, osConfig, pkgs, ... }:

{
  imports = [
    ./barrier.nix
    ./kdeconnect.nix
    ./nextcloud-client.nix
    ./onionshare.nix
    ./syncthing.nix
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
      barrier.enable = false;
      kdeconnect.enable = true;
      nextcloud-client.enable = true;
      onionshare.enable = true;
      syncthing.enable = lib.mkIf osConfig.nixos.base.tools.syncthing.enable true;
    };
  };
}