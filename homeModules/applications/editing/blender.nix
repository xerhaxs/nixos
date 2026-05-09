{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.editing.blender = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable blender";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.editing.blender.enable {
    home.packages = with pkgs; [
      blender
    ];

    /* home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/blender"
      ];
    }; */
  };
}
