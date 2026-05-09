{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.editing.image = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable GIMP";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.editing.image.enable {
    home.packages = with pkgs; [
      gimp
    ];

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/GIMP"
      ];
    };
  };
}
