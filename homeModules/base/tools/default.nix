{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    base.tools = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable tools modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.tools.enable {
    imports = [
      ./backup.nix
      ./common.nix
      ./git.nix
      ./ranger.nix
      ./yt-dlp.nix
    ];
  };
}