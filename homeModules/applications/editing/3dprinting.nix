{
  config,
  lib,
  pkgs,
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
      blender
      #orca-slicer
      #freecad-wayland
      cura-appimage
    ];
  };
}
