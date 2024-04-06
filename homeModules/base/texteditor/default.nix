{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    base.texteditor = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable texteditor modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.texteditor.enable {
    imports = [
      ./emacs.nix
      ./helix.nix
      ./neovim.nix
      ./tex.nix
      ./vim.nix
    ];
  };
}