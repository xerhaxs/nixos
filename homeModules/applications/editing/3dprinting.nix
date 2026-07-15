{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

{
  options.homeManager = {
    applications.editing."3dprinting" = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable 3D-printing tools.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.editing."3dprinting".enable {
    home.packages = with pkgs; [
      orca-slicer
      #freecad-wayland
    ];

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/FreeCAD"
        ".config/OrcaSlicer"
        ".local/share/FreeCAD"
        ".local/share/orca-slicer"
      ];
    };
  };
}
