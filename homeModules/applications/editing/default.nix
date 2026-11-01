{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./3dprinting.nix
    ./ai.nix
    ./blender.nix
    ./compiler.nix
    ./fusion360.nix
    ./gimp.nix
    ./image.nix
    ./kdenlive.nix
    ./tenacity.nix
  ];

  options.homeManager = {
    applications.editing = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable editing modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.editing.enable {
    homeManager.applications.editing = {
      "3dprinting".enable = lib.mkDefault false;
      ai.enable = lib.mkDefault false;
      blender.enable = lib.mkDefault false;
      compiler.enable = true;
      fusion360.enable = lib.mkDefault false;
      gimp.enable = true;
      image.enable = true;
      kdenlive.enable = true;
      tenacity.enable = true;
    };
  };
}
