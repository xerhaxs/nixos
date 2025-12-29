{ config, lib, pkgs, ... }:

{
  imports = [
    ./emacs.nix
    ./helix.nix
    ./tex.nix
    ./vim.nix
  ];

  options.homeManager = {
    base.texteditor = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable texteditor modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.texteditor.enable {
    homeManager.base.texteditor = {
      emacs.enable = lib.mkDefault false;
      helix.enable = lib.mkDefault false;
      tex.enable = true;
      vim.enable = true;
    };
  };
}