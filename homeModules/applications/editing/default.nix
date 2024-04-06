{ config, lib, pkgs, ... }:

{
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
    imports = [
      ./3dprinting.nix
      ./ai.nix
      ./audio.nix
      ./compiler.nix
      ./image.nix
      ./video.nix
    ];
  };
}