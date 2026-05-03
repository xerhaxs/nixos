{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.sync.syncthing = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable syncthing";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.sync.syncthing.enable {
    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/syncthing"
      ];
    };
  };
}
