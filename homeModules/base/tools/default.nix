{ config, lib, pkgs, ... }:

{
  imports = [
    ./backup.nix
    ./common.nix
    ./git.nix
    ./ranger.nix
    ./yt-dlp.nix
  ];

  options.homeManager = {
    base.tools = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable tools modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.tools.enable {
    homeManager.base.tools = {
      backup.enable = true;
      common.enable = true;
      git.enable = true;
      ranger.enable = true;
      yt-dlp.enable = true;
    };
  };
}