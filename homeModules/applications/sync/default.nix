{ config, lib, osConfig, pkgs, ... }:

{
  imports = [
    ./barrier.nix
    ./kdeconnect.nix
    ./nextcloud-client.nix
    ./onionshare.nix
    ./rclone.nix
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
      barrier.enable = lib.mkDefault false;
      kdeconnect.enable = true;
      onionshare.enable = lib.mkDefault false;
      rclone.enable = lib.mkDefault false;
      syncthing.enable = lib.mkIf osConfig.nixos.userEnvironment.syncthing.enable true;
    };
  };
}