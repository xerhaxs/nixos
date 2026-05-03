{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.gaming.steam = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable steam.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.gaming.steam.enable {
    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".steam"
        ".local/share/Steam"
      ];
    };
  };
}
