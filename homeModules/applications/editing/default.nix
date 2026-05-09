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
    ./compiler.nix
    ./gimp.nix
    ./image.nix
    ./kdenlive.nix
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
      "3dprinting".enable = true;
      ai.enable = true;
      compiler.enable = true;
      gimp.enable = true;
      image.enable = true;
      kdenlive.enable = true;
      tenacity.enable = true;
    };
  };
}
